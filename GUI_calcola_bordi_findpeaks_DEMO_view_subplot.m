function [] = GUI_calcola_bordi_findpeaks_DEMO_view_subplot(data, sens_findpeaks)

% verifica i parametri passati, se mancano caricali dal .mat
if exist('data', 'var') == 0 
    load temp_mat_data.mat data
end

if exist('sens_findpeaks', 'var') == 0
    load temp_mat_data.mat sens_findpeaks
end

load temp_mat_data.mat Zmin_soglia

    max_Z_value = max(max(data));
    
    % ripristino la soglia senza modificare l'originale
    data(data < Zmin_soglia) = 0;

    %% Analisi gradienti orizzontale e verticale dell'immagine data

    fig = figure;
    movegui(fig, 'west')
    hold on;

    sizeX = size(data, 1);
    
    % ANALISI ORIZZONTALE
    for num_riga = 1 : sizeX

        
        % seleziona la linea dalla matrice dei gradienti 45° orizzontali calcolati sopra
        linea_imm_selezionata = data(num_riga,:);

        % estrai i massimi = punti di flesso con una 'prominenza' > sens_flessi
        [~, peak_index] = findpeaks(-linea_imm_selezionata , 'MinPeakProminence' , sens_findpeaks);


        %%% vis
        drawnow
        if ishandle(fig)
            
            clf(fig);
            
            subplot(3, 1, 1);
            imshow(repmat(linea_imm_selezionata, 100, 1), []); 
            s = sprintf('Linea immagine ORIZZONTALE %d di %d in analisi', num_riga, sizeX );
            title(s);
            hold on;
            plot(peak_index, repelem(50, length(peak_index)),'r*', 'MarkerSize', 7 );
            xlim([0 length(linea_imm_selezionata)]);
            
            
            subplot (3, 1, 2);
            plot(1:length(linea_imm_selezionata), linea_imm_selezionata); 
            title('Valori numerici linea immagine selezionata (altezze Z)');
            hold on;
            plot(peak_index, linea_imm_selezionata(peak_index),'r*', 'MarkerSize', 7 );
            xlim([0 length(linea_imm_selezionata)]);
            ylim([0 max_Z_value*1.2]);
            
            subplot (3, 1, 3);    % senza output stampa il grafico, altrimenti ritorna i valori
            findpeaks(-linea_imm_selezionata , 'MinPeakProminence' , sens_findpeaks);
            title('Findpeaks(-linea)');
            ylim([-max_Z_value*1.2 100]);
            
            drawnow;
            
        else
            return
        end
        %%%

        
    end


       
end

