function [bw] = GUI_calcola_bordi_findpeaks_O_V_no_view(data)

    sens_findpeaks = 1;

    % se passo DATA, usa quello e prendi i parametri dal .mat
    % altrimenti leggi tutto dal .mat
    if exist('data', 'var')
        load temp_mat_data.mat sens_findpeaks Zmin_soglia
    else
        load temp_mat_data.mat data sens_findpeaks Zmin_soglia
    end

      
    % ripristino la soglia senza modificare l'originale
    data(data < Zmin_soglia) = 0;
    
    %creo matrice dove salvare i punti rilevati idonei di contorno
    bw = zeros (size(data, 1), size(data, 2));

    %% Analisi gradienti orizzontale e verticale dell'immagine data

    % ANALISI ORIZZONTALE
    
    for num_riga = 1 : size(data, 1)
   
        % seleziona la linea orizzontale dalla matrice DATA
        linea_imm_selezionata = data(num_riga,:);

        % estrai i massimi = punti di flesso con una 'prominenza' > sens_flessi
        [~, peak_index] = findpeaks(-linea_imm_selezionata , 'MinPeakProminence' , sens_findpeaks);

        bw(num_riga, peak_index) = 1;
        
    end


    % ANALISI VERTICALE
    for num_col = 1 : size(data, 2)

        % seleziona la linea verticale dalla matrice DATA
        linea_imm_selezionata = data(:, num_col);

%         estrai i massimi = punti di flesso con una 'prominenza' >
        [~, peak_index] = findpeaks(-linea_imm_selezionata , 'MinPeakProminence', sens_findpeaks);

        bw(peak_index, num_col) = 1;

    end
    
    
end

