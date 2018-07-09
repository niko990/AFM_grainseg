function [bw_mask_output, fig_ciclo] = GUI_chiudi_bordi_enspoints_findpeaks_graph()

visualizza_figure_test = false;

load ('temp_mat_data.mat', 'flag_visualizza', 'data', 'bw_mask_input', 'num_datax2_colonne', ...
    'num_datax2_righe', 'Zmin_soglia', 'sens_findpeaks', 'num_min_pixel_vicini_input');

addpath(fullfile('.', 'export_fig'));

num_righe = num_datax2_righe;
num_colonne = num_datax2_colonne;

bw_mask_output = bw_mask_input;

contatore = 1;

if flag_visualizza == 1
    fig_ciclo = figure('name', 'Avanzamento bordi');
else
    fig_ciclo = '';
end
drawnow

bw_mask_output = imdilate(bw_mask_output, strel('disk',1));
bw_mask_output = bwmorph(bw_mask_output, 'fill', 4);
bw_mask_output = bwmorph(bw_mask_output, 'bridge');
bw_mask_output = bwmorph(bw_mask_output, 'skel', Inf);
bw_mask_output = bwmorph(bw_mask_output, 'fill', 4);
bw_mask_output = bwmorph(bw_mask_output, 'skel', Inf);


% metà dimensione della finestra di intorno 13x13
mezza_dim = floor( 12 / 2);

% f=figure;


bw_mask_output_old = bw_mask_output;
% creo maschera dove aggiungo i pixel minimi di ogni intorno di endpoint
intorno_mask_pixel_aggiunti = zeros(size(bw_mask_input));

endpoints = bwmorph(bw_mask_output, 'endpoints');

% torna gli indici di tutti i punti a 1 nella maschera!
[endpoints_rows, endpoints_cols] = find(endpoints);

%     figure
%     imshow(imoverlay_1mask(mat2gray(data), bw_mask_output, 'blu'), [])
%     hold on
%     scatter(endpoints_cols, endpoints_rows, 'r*')
% %     title(sprintf('endpoint inizio %d', i))
%     axis xy

% scorro tutti gli endpoint trovati
%     figure
for k = 1 : length(endpoints_rows)
    
    % (x,y) del punto endpoint nell'immagine originale grande, non crop
    pixel_endpoint_colonna_full = endpoints_cols(k);
    pixel_endpoint_riga_full = endpoints_rows(k);
    
    %non considerare gli endpoint sul contorno, solo quelli interni con
    %almeno un 3x3 intorno
    % controllo di non uscire dal bordo per creare l'intorno 3x3 o 5x5
    if (pixel_endpoint_riga_full - mezza_dim < 1 || pixel_endpoint_riga_full + mezza_dim > num_righe || pixel_endpoint_colonna_full - mezza_dim < 1 || pixel_endpoint_colonna_full + mezza_dim > num_colonne)
        continue
    end
    
    % coordinate limite per l'intorno di data da ritagliare
    left_limit =  pixel_endpoint_colonna_full - mezza_dim;
    right_limit = pixel_endpoint_colonna_full + mezza_dim;
    up_limit = pixel_endpoint_riga_full - mezza_dim;
    down_limit = pixel_endpoint_riga_full + mezza_dim;
    
    % ritaglio di data e mask (RIGHE , COLONNE)
    crop_data = data(up_limit : down_limit, left_limit : right_limit);
    
    % calcolo bw
    bw_findpeaks_0 = GUI_calcola_bordi_findpeaks_2input(crop_data, sens_findpeaks/4);
    
    
    
    % Calcolo crop_data a 45°
    data_45 = imrotate(crop_data, 45, 'bicubic');
    bw_findpeaks_45 = GUI_calcola_bordi_findpeaks_2input(data_45, sens_findpeaks/4);
    
    % funzione per ruotare e sistemare la maschera di -45°
    bw_findpeaks_45 = sistema_bw45(bw_findpeaks_0, bw_findpeaks_45);
    %     bw_findpeaks_45(crop_data < Zmin_soglia) = 1;
    
    % ridimensiona le maschere alla dimensione del ritaglio, altrimenti
    % l'OR è impossibile
    [bw_findpeaks_0, bw_findpeaks_45] = ridimensiona_bwmask_a_data(crop_data, bw_findpeaks_0, bw_findpeaks_45);
    
    % unione delle due maschere 0° + 45° con OR logico
    bw_findpeaks = bw_findpeaks_0 | bw_findpeaks_45;
    
    
    
    
    % torno le coordinate xy dei pixel a 1 nella bw
    [pixel_min_riga, pixel_min_colonna] = find(bw_findpeaks);
    
    % per ogni punto a 1 nella bw_mask setto 1 nella maschera dei pixel
    % aggiunti
    for lun = 1:length(pixel_min_riga)
        intorno_mask_pixel_aggiunti(up_limit + pixel_min_riga(lun) -1, left_limit + pixel_min_colonna(lun) -1) = 1;
    end
end

%         figure
%         subplot(1,3,1)
%         imshow(imoverlay_1mask(mat2gray(data), bw_mask_output, 'blu'))
%         hold on
%         scatter (pixel_endpoint_colonna_full, pixel_endpoint_riga_full, 'r*')
%
%         subplot(1,3,2)
%         surf(crop_data)
%
%         subplot(1,3,3)
%         imshow(imoverlay_2mask(mat2gray(crop_data), bw_mask_totale, 'rosso', crop_mask, 'blu'), 'InitialMagnification','fit')

bw_mask_output = bw_mask_output | intorno_mask_pixel_aggiunti;
bw_mask_output = bwmorph(bw_mask_output, 'bridge');
bw_mask_output = bwmorph(bw_mask_output, 'fill', 4);
bw_mask_output = bwmorph(bw_mask_output, 'thin', Inf);
bw_mask_output = bwareafilt(bw_mask_output, [num_min_pixel_vicini_input Inf]);

% se la figura è aperta (non chiusa dall'utente), allora stampa
drawnow % forza l'aggiornamento degli elementi grafici (se la figure è stata chiusa, così lo rilevo)
if ishandle(fig_ciclo)
    subplot(2,2,1)
    imshow(imoverlay_2mask(mat2gray(data),  bw_mask_output, 'rosso', bw_mask_input, 'blu'), 'InitialMagnification', 100);
    axis xy
    title (strcat('Dopo findpeaks sensibilità ', ' ', num2str(sens_findpeaks/4)));
    drawnow;
    %     pause(2);
end



%%
% ricalcolo gli endpoints e
% aggiungo il calcolo con la metrice di adiacenza, cammini minimi, etc

% metà dimensione della finestra di intorno 9x9
mezza_dim = floor( 8 / 2);

for ciclo_grafo = 1:3
    
    intorno_mask_pixel_aggiunti = zeros(size(bw_mask_input));
    endpoints = bwmorph(bw_mask_output, 'endpoints');
    
    % torna gli indici di tutti i punti a 1 nella maschera!
    [endpoints_rows, endpoints_cols] = find(endpoints);
    
    for k = 1 : length(endpoints_rows)
        
        % (x,y) del punto endpoint nell'immagine originale grande, non crop
        pixel_endpoint_colonna_full = endpoints_cols(k);
        pixel_endpoint_riga_full = endpoints_rows(k);
        
        if (pixel_endpoint_riga_full - mezza_dim < 1 || pixel_endpoint_riga_full + mezza_dim > num_righe || pixel_endpoint_colonna_full - mezza_dim < 1 || pixel_endpoint_colonna_full + mezza_dim > num_colonne)
            continue
        end
        
        % coordinate limite per l'intorno di data da ritagliare
        left_limit =  pixel_endpoint_colonna_full - mezza_dim;
        right_limit = pixel_endpoint_colonna_full + mezza_dim;
        up_limit = pixel_endpoint_riga_full - mezza_dim;
        down_limit = pixel_endpoint_riga_full + mezza_dim;
        
        % ritaglio di data e mask (RIGHE , COLONNE)
        crop_data = data(up_limit : down_limit, left_limit : right_limit);
        crop_mask = bw_mask_output(up_limit : down_limit, left_limit : right_limit);
        
        crop_data_originale = crop_data;
        
        % indice e (x,y) del punto endpoint del CROP
        pixel_endpoint_indice_crop = sub2ind(size(crop_data),mezza_dim+1, mezza_dim+1);
        [pixel_endpoint_riga_crop,pixel_endpoint_colonna_crop]=ind2sub(size(crop_data),pixel_endpoint_indice_crop);
        %         pixel_endpoint_valore = crop_data(pixel_endpoint_riga_crop, pixel_endpoint_colonna_crop);
        
        % CALCOLO DEL PUNTO MINIMO DA COLLEGARE CON L'ENDPOINT
        maschera_label = bwlabel(crop_mask);
        pixel_endpoint_label = maschera_label(pixel_endpoint_riga_crop, pixel_endpoint_colonna_crop);
        
        if visualizza_figure_test
            f1 = figure;
            imshow(imoverlay_1mask(mat2gray(crop_data), crop_mask, 'blu'), 'InitialMagnification', 'fit')
            hold on
            scatter(pixel_endpoint_riga_crop,pixel_endpoint_colonna_crop, 120, 'r', 'filled')
            export_fig (f1, '1_data_crop_con_mask', '-png', '-q101', '-r50')
        end
        
        % se ho una singola componente (quella dell'endpoint) penalizza la
        % maschera per trovare un minimo che sia nella direzione del ramo,
        % altrimenti non penalizzare e prendi il minimo a 0 dell'altra
        % componente
        if max(max(maschera_label)) == 1
            % rovescia in verticale e orizzontale la maschera, ottengo una
            % approssimazione di dove punta il bordo, quindi penalizzo (aumento
            % i valori) i valori dei pixel del 5% in base alla distanza dalla
            % presunta direzione del bordo, così da scegliere un minimo che non
            % è indietro ma continua nella stessa direzione
            mask_penalizza_orientamento = bwdist(flip(flip(crop_mask,1), 2));
            
            if visualizza_figure_test
                f2 = figure;
                imshow(crop_mask, 'InitialMagnification', 'fit')
                export_fig (f2, '2_mask', '-png', '-q101', '-r50')
                
                f3 = figure;
                imshow(flip(flip(crop_mask,1), 2), 'InitialMagnification', 'fit')
                export_fig (f3, '3_mask_flip', '-png', '-q101', '-r50')
                
                f4 = figure;
                imshow(mat2gray(mask_penalizza_orientamento), 'InitialMagnification', 'fit')
                export_fig (f4, '4_mask_penalizza', '-png', '-q101', '-r50')
            end
            
            % penalizzo i punti distanti dalla direzione prevista sommando
            % un valore che rappresenta la distanza crescente da tale direzione
            %             crop_data_penalizzata = crop_data + 0.5 * mask_penalizza_orientamento;
            
            % calcolo valore percentuale
            % nuovo_val_percentuale = val_originale * (100 - percentuale) / 100
            crop_data_penalizzata = crop_data .* (100 + mask_penalizza_orientamento) ./ 100;
            
            
            
            if visualizza_figure_test
                mask_penalizza_orientamento
                crop_data
                crop_data_penalizzata
                
                f5 = figure;
                imshow(imoverlay_1mask(mat2gray(crop_data_penalizzata), crop_mask, 'blu'), 'InitialMagnification', 'fit')
                hold on
                scatter(pixel_endpoint_riga_crop,pixel_endpoint_colonna_crop, 120, 'r', 'filled')
                export_fig (f5, '5_data_penalizzata', '-png', '-q101', '-r50')
                
            end
            
            % alza leggermente il valore dell'endpoint per evitare che
            % venga scelto continuamente come minimo
            %             crop_data_penalizzata(mezza_dim+1, mezza_dim+1) = pixel_endpoint_valore*1.05;
            
            [pixel_min_valore, pixel_min_indice] = min(crop_data_penalizzata(:));
            [pixel_min_riga, pixel_min_colonna] = ind2sub(size(crop_data_penalizzata),pixel_min_indice);
        else
            % scegli il pixel minore del'altra componente: mettendo al valore max tutti i pixel che non
            % fanno parte dell'altra componente
            crop_data(maschera_label == pixel_endpoint_label | maschera_label == 0) = max(max(crop_data));
            [pixel_min_valore, pixel_min_indice] = min(crop_data(crop_data>0));
            [pixel_min_riga, pixel_min_colonna] = ind2sub(size(crop_data),pixel_min_indice);
        end
        
        % matrice adiacenza 0/1
        [r,c] = size(crop_data);
        adj = zeros(size(crop_data));
        diagVec1 = repmat([ones(c-1,1); 0],r,1);  %# Make the first diagonal vector
        diagVec1 = diagVec1(1:end-1);             %# Remove the last value
        diagVec2 = [0; diagVec1(1:(c*(r-1)))];    %# Make the second diagonal vector
        diagVec3 = ones(c*(r-1),1);               %# Make the third diagonal vector
        diagVec4 = diagVec2(2:end-1);             %# Make the fourth diagonal vector
        adj = diag(diagVec1,1)+ diag(diagVec2,c-1)+ diag(diagVec3,c)+ diag(diagVec4,c+1);
        adj = adj+adj.';
        
        % matrice adiacenza pesata
        adj_weighted = zeros(size(adj));
        [r,c] = size(adj_weighted);
        for i=1:r
            for j=1:c
                if adj(i,j)==1
                    [r_v1,c_v1]=ind2sub(size(crop_data),i);
                    [r_v2,c_v2]=ind2sub(size(crop_data),j);
                    valore_1 = crop_data_originale(r_v1,c_v1);
                    valore_2 = crop_data_originale(r_v2,c_v2);
                    adj_weighted(i,j)= abs(valore_1 + valore_2);
                end
            end
        end
        
        
        %creo grafo dalla matrice di adiacenza pesata
        G = graph(adj_weighted);
        
        
        % calcolo cammino minimo da endpoint al pixel minimo
        [P,d] = shortestpath(G,pixel_min_indice, pixel_endpoint_indice_crop, 'Method', 'positive');
        
        if visualizza_figure_test
            
            %             P
            %             d
            %             f7 = figure;
            %             h = plot(G, 'EdgeLabel',round(G.Edges.Weight));
            %             highlight(h,P,'EdgeColor','r','LineWidth',1.5, 'NodeColor','r')
            %             highlight(h,P(1), 'NodeColor','g', 'Marker', 'square', 'MarkerSize', 10)
            %             highlight(h,P(end), 'NodeColor','g', 'Marker', 'square', 'MarkerSize', 10)
            %
            %
                        f8 = figure;
                        imshow(imoverlay_1mask(mat2gray(crop_data_originale), crop_mask, 'blu'), 'InitialMagnification', 'fit')
                        hold on
        end
        
        % verifico il percorso minimo
        num_pixel_sovrapposti_path = 0;
        for i = 1: length(P)
            indice_vertice_path = P(i);
            [r_vertice,c_vertice]=ind2sub(size(crop_data),indice_vertice_path);
            pixel_vertice_label = maschera_label(r_vertice, c_vertice);
            
            if visualizza_figure_test
                                hold on
                                scatter(c_vertice,r_vertice, 120, 'g', 'square', 'filled')
            end
            
            % se tocco pixel che fanno parte della stessa componente
            % connessa della bwmask
            if pixel_vertice_label == pixel_endpoint_label
                num_pixel_sovrapposti_path = num_pixel_sovrapposti_path + 1;
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if visualizza_figure_test
                        hold on
                        scatter(pixel_endpoint_colonna_crop, pixel_endpoint_riga_crop, 120, 'r', 'filled')
                        hold on
                        scatter(pixel_min_colonna, pixel_min_riga, 120, 'y', 'filled')
                        export_fig (f8, '8_data_path', '-png', '-q101', '-r50')
            
                        f9 = figure;
                        surf(crop_data_originale);
                        set(gca,'Xdir','reverse')%,'Ydir','reverse')
                        alpha(.7)
                        daspect([1 1 0.1]);
                        hold on
                        for y = 1:9
                            for x = 1:9
                                if crop_mask(y, x) == 1
                                    scatter3(x, y, crop_data_originale(y, x), 300,'b', 'filled')
                                end
                            end
                        end
                        hold on
                        for i = 1: length(P)
                            indice_vertice_path = P(i);
                            [r_vertice,c_vertice]=ind2sub(size(crop_data),indice_vertice_path);
                            scatter3(c_vertice, r_vertice , crop_data_originale(r_vertice, c_vertice), 150,'g','square', 'filled')
                        end
                        hold on;
                        scatter3(4+1,4+1,crop_data_originale(4+1, 4+1), 150,'r', 'filled')
                        hold on;
                        scatter3(pixel_min_colonna, pixel_min_riga, crop_data_originale(pixel_min_riga, pixel_min_colonna), 200,'y', 'filled')
                        xlim([1 9])
                        ylim([1 9])
                        export_fig (f9, '9_surf3D', '-png', '-q101', '-r100')
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        % 1 pixel è l'endpoint, se ne ho più di 1 vuol dire che ho fatto
        % cicli sulla stessa componente, qundi non va bene
        if num_pixel_sovrapposti_path <= 1
            for i = 1: length(P)
                indice_vertice_path = P(i);
                [r_vertice,c_vertice]=ind2sub(size(crop_data),indice_vertice_path);
                intorno_mask_pixel_aggiunti(up_limit + r_vertice -1, left_limit + c_vertice -1) = 1;
            end
        end
        
    end
    
    
    % aggiorno la maschera precedente con i nuovi pixel e faccio bridge
    bw_mask_output = bw_mask_output | intorno_mask_pixel_aggiunti;
    bw_mask_output = imdilate(bw_mask_output, strel('disk',1));
    bw_mask_output = bwmorph(bw_mask_output, 'bridge');
    bw_mask_output = bwmorph(bw_mask_output, 'thin', Inf);
    bw_mask_output = bwmorph(bw_mask_output, 'fill', 4);
    bw_mask_output = bwmorph(bw_mask_output, 'thin', Inf);
    bw_mask_output = bwareafilt(bw_mask_output, [num_min_pixel_vicini_input Inf]);
    
    
    % se la figura è aperta (non chiusa dall'utente), allora stampa
    drawnow % forza l'aggiornamento degli elementi grafici (se la figure è stata chiusa, così lo rilevo)
    if ishandle(fig_ciclo)
        subplot(2,2,contatore+1)
        imshow(imoverlay_2mask(mat2gray(data),  bw_mask_output, 'blu', intorno_mask_pixel_aggiunti, 'rosso'), 'InitialMagnification', 100);
        axis xy
        title (strcat('Pixel aggiunti: fine ciclo #', ' ', num2str(contatore)));
        drawnow;
        %         pause(1);
    end
    
    contatore = contatore + 1;
    
    %     isequaln(bw_mask_output, bw_mask_output_old)
    %
    %     subplot(1,2,1); imshow(bw_mask_output)
    %     subplot(1,2,2); imshow(bw_mask_output_old)
    %             drawnow;
    %         pause(0.3);
    %     if isequaln(bw_mask_output, bw_mask_output_old) | contatore > 14
    %         break
    %     else
    %
    %         %         contatore
    %         contatore = contatore + 1;
    %         continue
    %     end
    
    % end
    
end


bw_mask_output(data < Zmin_soglia) = 1;

save('temp_mat_data.mat', 'bw_mask_output', '-append');

end

