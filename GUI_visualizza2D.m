function [] = GUI_visualizza2D (zmin_value)

    load temp_mat_data.mat data xticks yticks x_axis_value y_axis_value max_Z_value num_datax2_colonne num_datax2_righe  unitX unitY unitZ;

    
    
        % permetti di visualizzare solo le Z > zmin_value, altrimenti
    % visualizza tutto
        if exist('zmin_value', 'var')
            % setta a 0 tutte le altezze, se specificato
            data (data < zmin_value)= 0;
        end

    
    % visualizzazione gray 2D
    imshow(data, [], 'InitialMagnification', 'fit');
    title('Visualizzazione 2D');

    set(gca, 'XTick', xticks, 'XTickLabel', x_axis_value);
    set(gca, 'YTick', yticks, 'YTickLabel', flipud(y_axis_value(:)));

    xlabel(strcat('X [', unitX, ']'));
    ylabel(strcat('Y [', unitY, ']'));

    c = colorbar;
    c.Label.String = strcat('Altezze Z [', unitZ, ']');

    xlim([0 num_datax2_colonne]);
    ylim ([0 num_datax2_righe]);
    zlim([0 max_Z_value]);
    
    % serve per disabilitare lo stretch della figure di matlab, che distorce le reali
    % proporzioni del grano, così invece è reale
%     pbaspect([1 1 1]);
%     daspect([1 1 10]);


    axis on; % attiva gli assi (valori)
    axis xy; % forza asse y ad avere lo 0 in basso

end

