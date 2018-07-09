function varargout = ground_truth(varargin)
% GROUND_TRUTH MATLAB code for ground_truth.fig
%      GROUND_TRUTH, by itself, creates a new GROUND_TRUTH or raises the existing
%      singleton*.
%
%      H = GROUND_TRUTH returns the handle to a new GROUND_TRUTH or the handle to
%      the existing singleton*.
%
%      GROUND_TRUTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUND_TRUTH.M with the given input arguments.
%
%      GROUND_TRUTH('Property','Value',...) creates a new GROUND_TRUTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ground_truth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ground_truth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ground_truth

% Last Modified by GUIDE v2.5 22-Jan-2018 17:11:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ground_truth_OpeningFcn, ...
    'gui_OutputFcn',  @ground_truth_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before ground_truth is made visible.
function ground_truth_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ground_truth (see VARARGIN)

% Choose default command line output for ground_truth
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ground_truth wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% funzione che modifica i colori quando si cambia lo zoom o il pan
% Adatta la colorbar allo zoom/pan corrente
h = zoom;
h.ActionPostCallback = @post_zoom_pan_function;

p = pan;
p.ActionPostCallback = @post_zoom_pan_function;

end

% --- Outputs from this function are returned to the command line.
function varargout = ground_truth_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


end

% --- Executes on button press in pushbutton_annulla_ultimo.
function pushbutton_annulla_ultimo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_annulla_ultimo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('temp_mat_data.mat', 'data', 'mask_ground_truth', 'mask_ultimo_disegno');

% tolgo alla totale l'ultimo disegno
mask_ground_truth = mask_ground_truth - mask_ultimo_disegno;

% azzero la mask_ultimo_disegno
mask_ultimo_disegno = zeros(size(mask_ultimo_disegno));

%salvo
save('temp_mat_data.mat', 'mask_ground_truth', 'mask_ultimo_disegno', '-append');

%aggiorno la visualizzazione
imshow(imoverlay_1mask(mat2gray(data), mask_ground_truth, 'rosso'), []);
axis xy
drawnow

end

% --- Executes on button press in pushbutton_fine.
function pushbutton_fine_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('temp_mat_data.mat', 'data', 'mask_ground_truth', 'FileName');

addpath(fullfile('.', 'export_fig'));

%creo contorno di 1 pixel
mask_ground_truth(1,:) = 1;
mask_ground_truth(:,1) = 1;
mask_ground_truth(size(mask_ground_truth,1),:) = 1;
mask_ground_truth(:,size(mask_ground_truth,2)) = 1;


data = flip(data);
mask_ground_truth = flip(mask_ground_truth);


mask_ground_truth = bwareafilt(mask_ground_truth, [ 200 Inf]);

subplot(1, 2, 1)
imshow(data, []);

subplot(1,2,2);
imshow(mask_ground_truth, []);


% posizione dove creare la cartella
folder_path = uigetdir('dove?', 'Dove salvare la maschera?');

% finestra chiusa senza premere OK
if folder_path == 0
    msgbox('Salvataggio annullato');
    return;
end

% salvo maschera logica in .mat
[~, nome_file , ~] = fileparts(FileName);
nome_file_mat = strcat('ground_truth_mask_mat-' , nome_file, '.mat');
cartella_salvataggio = fullfile(folder_path, nome_file_mat);
save(cartella_salvataggio, 'mask_ground_truth');

% salvo la sola maschera GT in .png
nome_file_png = strcat('ground_truth_mask_png-' , nome_file, '.png');
salvataggio_png = fullfile(folder_path, nome_file_png);
imwrite(mask_ground_truth, salvataggio_png);

% salvo il dato immagine su cui è stata fatta la maschera, come .mat
nome_file_mat = strcat('data_mat-' , nome_file, '.mat');
cartella_salvataggio = fullfile(folder_path, nome_file_mat);
save(cartella_salvataggio, 'data');

% salvo l'immagine originale "data" come .png
nome_file_png = strcat('data_png-' , nome_file, '.png');
salvataggio_png = fullfile(folder_path, nome_file_png);
imwrite(mat2gray(data), salvataggio_png);


% salvo la maschera sovraimpressa all'immagine originale, in .png 300dpi
f = figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
GUI_visualizza2D();
title('Ground-truth mask')
cl = caxis;% serve per non sfasare i valori della colorbar dalle altezze a 0:256
hold on
imshow(imoverlay_1mask(mat2gray(data), mask_ground_truth, 'rosso'), []);
caxis(cl); %ripristino i valori della colorbar (venivano sfasati dall'imshow in 0:256)
axis on

nome_file_mat = strcat('ground_truth_mask_over-' , nome_file, '.png');
cartella_salvataggio = fullfile(folder_path, nome_file_mat);
export_fig (f, cartella_salvataggio, '-png', '-q101', '-r300')



uiwait(msgbox(strcat('Maschera salvata in:', cartella_salvataggio)));

close(gcf)

end


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load('temp_mat_data.mat', 'data', 'mask_ground_truth', 'Zmin_soglia');

% se è la prima volta che si calcola la mask_ground_truth, creala
% e setta a 1 gli eventuali pixel sotto la soglia di Zmin_soglia
if exist('mask_ground_truth', 'var') == 0
    mask_ground_truth = zeros(size(data));
    mask_ground_truth(data < Zmin_soglia) = 1;
end


% crea matrice per tenere in memoria l'ultimo disegno, per annullarlo
% eventualmente
mask_ultimo_disegno = zeros(size(data));

data_n_r = size(data, 1);
data_n_c = size(data, 2);

axes(handles.axes_ground_truth);


imshow(imoverlay_1mask(mat2gray(data), mask_ground_truth, 'rosso'), []);
axis xy
drawnow
%
while true
    
    %     z = zoom
    
    % catturo il percorso mentre si clicca
    hFH = imfreehand('Closed', false);
    %
    %     % nessun punto selezionato, utente esce dall'inserimento
    if length(hFH) == 0
        return
    end
    
    xy =  round(hFH.getPosition);
    
    delete(hFH);
    %
    %     % vettore di 'distanza' tra i punti della linea interpolata
    %     % minore è la distanza centrale e più punti genera
    t = 0 : .01 : 1;
    x = xy(:, 1);
    y = xy(:, 2);
    mask_ultimo_disegno = zeros(size(data));
    
    x_interp = [];
    y_interp = [];
    
    for i = 1 : length(xy)-1
        
        punto1 = [x(i) y(i)];
        punto2 = [x(i+1) y(i+1)];
        
        C = round(repmat(punto1, length(t) , 1)' + (punto2 - punto1)' * t);
        
        for ind = 1:length(C)
            
            % non generare punti fuori dalle dim dell'immagine, al massimo
            % segui i bordi
            if C(2,ind) > data_n_r
                C(2,ind) = data_n_r;
            else
                if C(2,ind) < 1
                    C(2,ind) = 1;
                end
            end
            
            
            if C(1,ind) > data_n_c
                C(1,ind) = data_n_c;
            else
                if C(1,ind) < 1
                    C(1,ind) = 1;
                end
            end
            
            mask_ultimo_disegno(C(2,ind), C(1,ind)) = 1;
            
            x_interp = cat(1, x_interp, C(1,ind));
            y_interp = cat(1, y_interp, C(2,ind));
            
        end
        
        
    end
    
    
    
    % chiudo gli eventuali buchi
    mask_ultimo_disegno = bwmorph(mask_ultimo_disegno, 'bridge', Inf);
    
    % aggiungo il disegno alla maschera totale
    mask_ground_truth = mask_ground_truth | mask_ultimo_disegno;
    
    %     e pulisco da rami non opportuni
    mask_ground_truth = bwmorph(mask_ground_truth, 'spur', 2);
    
    
    % salva lo zoom attuale per mantenerlo dopo l'aggiornamento della
    % figure
    tmp_xlim = get(handles.axes_ground_truth, 'xlim');
    tmp_ylim = get(handles.axes_ground_truth, 'ylim');
    
    % aggiorna l'axes principale
    imshow(imoverlay_2mask(mat2gray(data), mask_ground_truth, 'rosso', mask_ultimo_disegno, 'blu'), []);
    axis xy
    %     drawnow
    
    
    save('temp_mat_data.mat', 'mask_ground_truth', 'mask_ultimo_disegno', '-append');
    
    % ripristina lo zoom
    set(handles.axes_ground_truth, 'xlim', tmp_xlim);
    set(handles.axes_ground_truth, 'ylim', tmp_ylim);
    
end

end








% Operazioni chiamate dopo uno zoom in/out
function post_zoom_pan_function(handles, event)

load temp_mat_data.mat data

newColLim = floor(event.Axes.XLim);
newRowYLim = floor(event.Axes.YLim);
newZLim = floor(event.Axes.ZLim);

% in caso lo zoom vada fuori dall'immagine, evita errori
if newRowYLim(1) < 1
    newRowYLim(1) = 1;
end

if newColLim(1) < 1
    newColLim(1) = 1;
end

[n_righe, n_col] = size(data);

if newColLim(2) > n_col
    newColLim(2) = n_col;
end

if newRowYLim(2) > n_righe
    newRowYLim(2) = n_righe;
end

% ritaglio il dato alle X:Y dello zoom
data_zoom = data ( newRowYLim(1) : newRowYLim(2) , newColLim(1) : newColLim(2) );

% calcolo min e max della porzione ritagliata
minZ = floor(min(min(data_zoom)));
maxZ = floor(max(max(data_zoom)));

if minZ < 1
    minZ = 1;
end

% caxis(event.Axes, [minZ maxZ])

% colorbar off

% reimposto le Z con le newZLim solo nel surf 3D!!!
% nel 2D uso il calcolo del minimo della porzione data(Xmin:Xmax, Ymin:Ymax)
titolo = get(event.Axes.Title, 'String');

%strcmp(titolo, 'Visualizzazione 3D')

if strcmp(titolo, 'Visualizzazione 3D')
    %     caxis(event.Axes, [newZLim(1) newZLim(2)])
    %     zlim([newZLim(1) newZLim(2)])
    caxis(gca, [newZLim(1) newZLim(2)]);
    %     zlim(gca, [newZLim(1) newZLim(2)])
    
else
    caxis(gca, [minZ maxZ]);
end

drawnow

%
% figure;
% subplot(1, 2, 1)
% imshow(data_zoom, []); axis xy;
% subplot(1, 2, 2)
% surf(data_zoom, 'EdgeColor', 'none'); axis xy;



% msgbox(sprintf('The new X-Limits are [%.2f %.2f].',newXLim));
% msgbox(sprintf('The new Y-Limits are [%.2f %.2f].',newYLim));
% msgbox(sprintf('The new Z-Limits are [%.2f %.2f].',newZLim));


end

