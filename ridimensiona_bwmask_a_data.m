function [bw_0, bw_45] = ridimensiona_bwmask_a_data(data, bw_0, bw_45)

r_data = size(data, 1);
c_data = size(data, 2);

r_bw0 = size(bw_0, 1);
c_bw0 = size(bw_0, 2);

r_bw45 = size(bw_45, 1);
c_bw45 = size(bw_45, 2);

% Se necessario ridimensiono bw0 alle dimensioni di data! in righe e colonne
if (r_data ~= r_bw0) | (c_data ~= c_bw0)
    % se ho meno righe in bw0 rispetto a data, aggiungo zeri
    if r_bw0 < r_data
        bw_0(r_bw0+1 : r_data, 1) = 0;
    end
    
    % se ho più righe in bw0 rispetto a data, tolgo
    if r_bw0 > r_data
        bw_0 = bw_0( 1 : r_data, :);
    end
    
    % se ho meno colonne in bw0 rispetto a data, aggiungo zeri
    if c_bw0 < c_data
        bw_0( 1 , c_bw0+1 : c_data ) = 0;
    end
    
    % se ho più colonne in bw0 rispetto a data, tolgo
    if c_bw0 > c_data
        bw_0 = bw_0( :, 1 : c_data);
    end
    
end


% Se necessario ridimensiono bw45 alle dimensioni di data! in righe e colonne
if (r_data ~= r_bw45) | (c_data ~= c_bw45)
    %     disp('bw45 diverso da data')
    
    % se ho meno righe in bw0 rispetto a data, aggiungo zeri
    if r_bw45 < r_data
        %         fprintf('...aggiungo %d righe', r_data - r_bw45)
        bw_45(r_bw45+1 : r_data, 1) = 0;
    end
    
    % se ho più righe in bw0 rispetto a data, tolgo
    if r_bw45 > r_data
        bw_45 = bw_45( 1 : r_data, :);
    end
    
    % se ho meno colonne in bw0 rispetto a data, aggiungo zeri
    if c_bw45 < c_data
        %         fprintf('...aggiungo %d colonne',  c_data - c_bw45)
        bw_45( 1 , c_bw45+1 : c_data ) = 0;
    end
    
    % se ho più colonne in bw0 rispetto a data, tolgo
    if c_bw45 > c_data
        %         disp('...tolgo ',  c_bw45 - c_data, ' colonne')
        bw_45 = bw_45( :, 1 : c_data);
    end
    
end

end