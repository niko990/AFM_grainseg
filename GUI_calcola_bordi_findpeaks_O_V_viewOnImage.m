function [bw] = GUI_calcola_bordi_findpeaks_O_V_viewOnImage(data, sens_findpeaks)

% verifica i parametri passati, se mancano caricali dal .mat
if exist('data', 'var') == 0 
    load temp_mat_data.mat data
end

if exist('sens_findpeaks', 'var') == 0
    load temp_mat_data.mat sens_findpeaks
end

load temp_mat_data.mat Zmin_soglia


% ripristino la soglia senza modificare l'originale
data(data < Zmin_soglia) = 0;

bw = zeros (size(data, 1), size(data, 2));

%% Analisi gradienti orizzontale e verticale dell'immagine data

f = figure();
movegui(f, 'west')
imshow(data, [], 'InitialMagnification', 'fit')
axis xy
hold on;

% ANALISI ORIZZONTALE
for num_riga = 1 : size(data, 1)
    
    
    % seleziona la linea
    linea_imm_selezionata = data(num_riga,:);
    
    % estrai i massimi = punti di flesso con una 'prominenza' > sens_flessi
    [~, peak_index] = findpeaks(-linea_imm_selezionata , 'MinPeakProminence' , sens_findpeaks);
    
    if ishandle(f)
        plot(peak_index(:), repelem(num_riga, length(peak_index)), 'y+', 'MarkerSize', 1 );
        drawnow;      
    end
    
    bw(num_riga, peak_index) = 1;
        
end



% ANALISI VERTICALE
for num_col = 1 : size(data, 2)
    
    %     seleziona la linea
    linea_imm_selezionata = data(:, num_col);
    
    %         estrai i massimi = punti di flesso con una 'prominenza' >
    [~, peak_index] = findpeaks(-linea_imm_selezionata , 'MinPeakProminence', sens_findpeaks);
    
    if ishandle(f)
        plot(repelem(num_col, length(peak_index)), peak_index(:), 'c+', 'MarkerSize', 1 );
        drawnow;
    end
    
    bw(peak_index, num_col) = 1;
end

end

