
% Operazioni per riportare la maschera ora ruotata di 45° a 0° per poi
% sovrapporla con l'altra mask

function [bw_45_finale] = sistema_bw45(bw_0, bw_45)


% riporto la maschera da 45° a 0, per sovrapporla alla bw_0
bw_45_0 = imrotate(bw_45, -45, 'bicubic');

% soglio perchè ruotandola diventa in scala di grigi, con tutti i metodi
bw_45_0_sogliato = imbinarize(bw_45_0, graythresh(bw_45_0));

% crop alle giuste dimensioni
centroX = floor( size(bw_45_0_sogliato, 1) / 2 );
centroY = floor( size(bw_45_0_sogliato, 2) / 2 );
meta_bw_X = floor( size(bw_0, 1) / 2 );
meta_bw_Y = floor( size(bw_0, 2) / 2 );
bw_45_finale = bw_45_0_sogliato( (centroX - meta_bw_X + 1 ) : (centroX + meta_bw_X  ), (centroY - meta_bw_Y + 1 ) : (centroY + meta_bw_Y));

% devo togliere 3 righe di contorno perchè sono bianche.
bw_45_finale(1:3, :) = 0;
bw_45_finale(:, 1:3) = 0;
bw_45_finale(size(bw_45_finale, 1) - 3 : size(bw_45_finale, 1) , :) = 0;
bw_45_finale(:, size(bw_45_finale, 2) - 3 : size(bw_45_finale, 2) ) = 0;

end