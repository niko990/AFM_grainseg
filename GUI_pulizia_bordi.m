function [] = GUI_pulizia_bordi()

load ('temp_mat_data.mat', 'data', 'bw_mask_output', 'Zmin_soglia', 'bw_add_totale');

% se esiste la variabile 'bw_add_totale', cioè dove vengono memorizzati i
% disegni a mano libera dell'utente, allora aggiungila (OR) alla
% bw_mask_output per ottenere un totale, altrimenti procedi solo con la bw_mask_output
%
% ALLA FINE SALVA COMUNQUE LA bw_mask_finale
if exist('bw_add_totale', 'var') == 1
    bw_mask_output = bw_mask_output | bw_add_totale;
end


bw_mask_output = bwmorph(bw_mask_output, 'bridge');

%%%%%%%%% PARAMETRIZZATO QUI, TOLTO DAL MAIN
% GUARDO QUANTI PIXEL SONO A 1 IN TOTALE, ALTRIMENTI IN IMG PICCOLE TOLGO
% TUTTO!!
% conta quanti pixel sono a 1 nell'immagine, togli tutti gli agglomerati
% che sono più piccoli di TOT_PIXEL/5
num_min_pixel_vicini_pulizia_bordi = round(sum(sum(bw_mask_output == 1, 2)) / 250);

bw_mask_output = bwareafilt(bw_mask_output, [ num_min_pixel_vicini_pulizia_bordi Inf]);

bw_mask_output = bwmorph(bw_mask_output, 'thin', Inf);

bw_mask_output = bwmorph(bw_mask_output, 'fill', 4);

bw_mask_output = bwmorph(bw_mask_output, 'thin', Inf);

% ripristino le zone a profondità minore del voluto come background
bw_mask_output(data < Zmin_soglia) = 1; % quindi 1 = background



% fill dei pixel a 0 circondati da 1
bw_mask_imfill_interno = imfill(~bw_mask_output, [1 1]);
%  figure; imshow( bw_mask_imfill_interno , []); title('test imfill a');

% aggiungo bordo di contorno
bw_mask_imfill_esterno = imfill(bw_mask_output, 'holes');
%  figure; imshow( bw_mask_imfill_esterno , []); title('test imfill b');

bw_mask_finale = bw_mask_imfill_interno & bw_mask_imfill_esterno;
% figure; imshow( bw_mask_finale , []); title('BW aree 1');

% bw_mask_imfill_esterno SERVE AL WATERSHED DOPO
save ('temp_mat_data.mat', 'bw_mask_finale', 'bw_mask_imfill_esterno', 'num_min_pixel_vicini_pulizia_bordi', '-append');

end

