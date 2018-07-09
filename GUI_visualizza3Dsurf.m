function [] = GUI_visualizza3Dsurf(color, zmin_value)

load temp_mat_data.mat data xticks yticks zticks x_axis_value y_axis_value z_axis_value max_Z_value num_datax2_colonne num_datax2_righe unitX unitY unitZ;

    % permetti di visualizzare solo le Z > zmin_value, altrimenti
    % visualizza tutto
    if exist('zmin_value', 'var')
        % setta a 0 tutte le altezze, se specificato
        data (data < zmin_value)= 0;
    end

    


    
    s = surf(data);

    c = colorbar;
    c.Label.String = strcat('Altezze Z [', unitZ, ']');

    
    colormap (gca, color);
    
    s.EdgeColor = 'none';
    s.FaceColor = 'interp';
    s.FaceLighting = 'gouraud';

    xlabel(strcat('X [', unitX, ']'));
    ylabel(strcat('Y [', unitY, ']'));
    zlabel(strcat('Z [', unitZ, ']'));

    set(gca, 'XTick', xticks, 'XTickLabel', x_axis_value);
    set(gca, 'YTick', yticks, 'YTickLabel', flipud(y_axis_value(:)));
    set(gca, 'ZTick', zticks, 'ZTickLabel', z_axis_value);

    % toglie spazio bianco bordi grafico
    xlim([0 num_datax2_colonne]);
    ylim ([0 num_datax2_righe]);
    zlim([0 max_Z_value]);
    
    % serve per disabilitare lo stretch della figure di matlab, che distorce le reali
    % proporzioni del grano, così invece è reale
%     pbaspect([1 1 1]);
%     daspect([1 1 1]);
daspect([0.5 0.5 1]);    

    title('Visualizzazione 3D');
    




end


