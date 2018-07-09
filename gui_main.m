function varargout = gui_main(varargin)

nargout = 0;

% gui_main MATLAB code for gui_main.fig
%      gui_main, by itself, creates a new gui_main or raises the existing
%      singleton*.
%
%      H = gui_main returns the handle to a new gui_main or the handle to
%      the existing singleton*.
%
%      gui_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui_main.M with the given input arguments.
%
%      gui_main('Property','Value',...) creates a new gui_main or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_main

% Last Modified by GUIDE v2.5 19-Mar-2018 13:25:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_main_OpeningFcn, ...
    'gui_OutputFcn',  @gui_main_OutputFcn, ...
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

% --- Executes just before gui_main is made visible.
function gui_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_main (see VARARGIN)



clc

% set(gcf,'units','normalized', 'Position', get(0, 'Screensize'))


tic
fprintf('\nMain: Creo FIGURE e oggetti collegati...')
% fullscreen IMPOSSIBILE SEMBRA...

% cd(fileparts(mfilename('fullpath')))

% Choose default command line output for gui_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%Create tab group
handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'left');

handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Step 1: Carica, salva, esporta', 'Tag', 'tab1');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Step 2: Visualizza', 'Tag', 'tab2');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Step 3: Altezze minime', 'Tag', 'tab3');
handles.tab4 = uitab('Parent', handles.tgroup, 'Title', 'Step 4: Riconoscimento bordi', 'Tag', 'tab4');
handles.tab5 = uitab('Parent', handles.tgroup, 'Title', 'Step 5: Chiusura bordi', 'Tag', 'tab5');
handles.tab6 = uitab('Parent', handles.tgroup, 'Title', 'Step 6: Disegno libero', 'Tag', 'tab6');
handles.tab7 = uitab('Parent', handles.tgroup, 'Title', 'Step 7: Watershed', 'Tag', 'tab7');
handles.tab8 = uitab('Parent', handles.tgroup, 'Title', 'Statistiche 1', 'Tag', 'tab8');
handles.tab9 = uitab('Parent', handles.tgroup, 'Title', 'Statistiche 2', 'Tag', 'tab9');

% get(handles.tab1)

%Place panels into each tab
set(handles.panel1_carica,'Parent',handles.tab1)
set(handles.panel2_visualizza,'Parent',handles.tab2)
set(handles.panel3_altezze_minime,'Parent',handles.tab3)
set(handles.panel4_riconoscimento_bordi,'Parent',handles.tab4)
set(handles.panel5_chiusura_bordi,'Parent',handles.tab5)
set(handles.panel6_disegno_libero,'Parent',handles.tab6)
set(handles.panel7_watershed,'Parent',handles.tab7)
set(handles.panel8_statistiche,'Parent',handles.tab8)
set(handles.panel9_statistiche_2,'Parent',handles.tab9)


%Reposition each panel to same location as panel 1
set(handles.panel2_visualizza,'position',get(handles.panel1_carica,'position'));
set(handles.panel3_altezze_minime,'position',get(handles.panel1_carica,'position'));
set(handles.panel4_riconoscimento_bordi,'position',get(handles.panel1_carica,'position'));
set(handles.panel5_chiusura_bordi,'position',get(handles.panel1_carica,'position'));
set(handles.panel6_disegno_libero,'position',get(handles.panel1_carica,'position'));
set(handles.panel7_watershed,'position',get(handles.panel1_carica,'position'));
set(handles.panel8_statistiche,'position',get(handles.panel1_carica,'position'));
set(handles.panel9_statistiche_2,'position',get(handles.panel1_carica,'position'));

%aggiorno gli handles con i tab e riferimenti ai panel
guidata(hObject, handles);

% pulisco eventuali vecchi salvataggi residui da chiusure non corrette del
% programma
if exist('temp_mat_data.mat.mat', 'file') == 2
    delete('temp_mat_data.mat.mat');
end



% IMMAGINE DEFAULT NEGLI AXES
% ottengo gli handles di tutti gli axes della GUI
hAxes = arrayfun(@cla,findall(0,'type','axes'));
%
% % myImage = imread('.\img\nodata1.gif');
% myImage = imread('.\img\nodata2.png');
myImage = imread(fullfile('.','img','nodata2.png'));
% myImage = imread('.\img\nodata3.png');
%
for i = 1 : length(hAxes)
    axes(hAxes(i));
    imshow(myImage, []);
end




t = toc;
fprintf(' %.3f s\n\n', t);



% setto tutte le altre variabili usate poi ai valori di default e le salvo nel .mat
set_parametri_da_mat(handles);


% funzione che modifica i colori quando si cambia lo zoom o il pan
% Adatta la colorbar allo zoom/pan corrente
h = zoom;
h.ActionPostCallback = @post_zoom_pan_function;

p = pan;
p.ActionPostCallback = @post_zoom_pan_function;





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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Outputs from this function are returned to the command line.
function varargout = gui_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% TUTTE LE AZIONI DA FARE DOPO IL CARICAMENTO VANNO QUI
% --- Executes on button press in button_step0_carica_file.
function button_step0_carica_nuovo_file_Callback(hObject, eventdata, handles)
% hObject    handle to button_step0_carica_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% [FileName, PathName] = uigetfile('..\Export ASCII\*.txt' , 'Seleziona il file ASCII da caricare...');
[FileName, PathName] = uigetfile({'*.txt'; '*.jpg'; '*.png'}, 'Seleziona il file ASCII o immagine da caricare...', '..\Export ASCII\');

% controllo se l'utente ha chiuso la finestra senza selezionare un file, in
% questo caso ignora e non fare nulla.
if FileName == 0
    % User clicked the Cancel button.
    return;
end


% prima di leggere il file controllo che la dimensione sia consona,
% minore di 7 MB  (solitamente è meno di 3 MB),
% /1024^2 per trasformare da bytes a MB
% così evito di bloccare l'app se carico qualcosa di grosso per sbaglio
infofile = dir(strcat(PathName, FileName));

limite_dimensione_import_file = 7; % MB

% disp(infofile.bytes / 1024^2)
if (infofile.bytes / 1024^2) > limite_dimensione_import_file
    s = sprintf('Il file selezionato ha una dimensione eccessiva per essere un precedente salvataggio di parametri!  ');
    s = strcat(s, sprintf('Dimensione file = %.2f MB   Dimensione massima consentita = %.2f MB', infofile.bytes / 1024^2, limite_dimensione_import_file));
    errordlg(s);
    return
end

% è stato selezionato un file corretto per il caricamento, prosegui



% Se esisteva già un .mat vuol dire che c'era già un file caricato, quindi
% pulisci il mat e rimetti gli axes a default
if exist('temp_mat_data.mat', 'file') == 2
    
    
    % setto tutte le altre variabili usate poi ai valori di default e le salvo nel .mat
    set_parametri_da_mat(handles);
    
    % resetta il textbox del numero grani watershed
    set(handles.text_watershed_num_grani_trovati, 'String', '');
    
    % resetta il textbox delle info grano nelle statistiche
    set(handles.text_dati_selezione_grano, 'String', 'No data');
    
    % resetto la table delle statistiche
    set(handles.step7_tabella_statistiche, 'Data', '');
    
    
    % rimetto a OFF i pulsanti di salvataggio parametri e statistiche della
    % prima pagina
    set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'Enable', 'off');
    set(handles.pushbutton_salva_img_ax, 'Enable', 'off');
    
end






% leggi il file selezionato e crea il .mat
file_ok = GUI_importASCII(PathName, FileName);

% se c'è un errore non fare niente, gestita dalla funzione
if ~file_ok
    return
end

fprintf('Main: Caricamento .mat, visualizzazione, set variabili default...');
tic

% Modifica il pulsante per calcolo in corso...
color = get(handles.button_step0_carica_nuovo_file, 'Backgroundcolor');
text = get(handles.button_step0_carica_nuovo_file, 'String');

set(handles.button_step0_carica_nuovo_file, 'Backgroundcolor','r', 'String', 'Caricamento in corso...', 'Enable', 'off');
drawnow


% carica il mat e prosegui
load temp_mat_data.mat;



data = imresize(data, 2);

num_datax2_colonne = size(data, 2);
num_datax2_righe = size(data, 1);


[max_Z_value, Ind_max] = max(data(:));
[max_Z_ind_X, max_Z_ind_Y] = ind2sub(size(data),Ind_max);

% creo vettori dei valori per gli assi X Y Z, approssimati ad 1 decimale,
% che poi visualizzerò sugli assi dei vari grafici 2D e 3D
n_decimali = 1;


% salvo le variabili necessarie alla visualizzazione
save ('temp_mat_data.mat', 'data', 'num_datax2_righe', 'num_datax2_colonne', 'max_Z_value', 'max_Z_ind_X', ...
    'max_Z_ind_Y', 'n_decimali', '-append');

% setto tutte le altre variabili usate poi ai valori di default e le salvo nel .mat
set_parametri_da_mat(handles);


% Abilito il caricamento di eventuali parametri, che sovrascriveranno
% quelli appena caricati da GUI_importASCII
set(handles.pushbutton_carica_parametri, 'Enable', 'on');


% carica i grafici normali dello step 1 visualizza
update_axes();
update_view_2D_3D(handles);


% carica i grafici delle altezze minime senza togliere niente di altezza, Zmin = 0
update_view_Zmin(handles);
set(handles.slider_text, 'Max', floor(max_Z_value));
set(handles.slider_Zmin, 'Max', floor(max_Z_value));

% [10/max_Z_value, 0.1]
set(handles.slider_Zmin, 'SliderStep', [0.01, 0.1]);



% Aggiornamento del box testo nella home (text_carica_nuovo_file)
s1 = sprintf('File caricato: %s\n\nDATI DEL FILE\n', FileName);
s2 = sprintf('Misura lato X = %.4f %s\nMisura lato Y = %.4f %s\n', misura_base, unitX, misura_altezza, unitY);
s3 = sprintf ('Numero misurazioni X = %d\nNumero misurazioni Y = %d\n',  sizeX, sizeY);
s4 = sprintf ('Unità di misura X = %s\nUnità di misura Y = %s\nUnità di misura Z = %s\n', unitX, unitY, unitZ);
s5 = sprintf('Risoluzione X = %.4f %s\nRisoluzione Y = %.4f %s\nRisoluzione Z = %.4f %s', scaleX, unitX, scaleY, unitY, scaleZ, unitZ);
%s6 = sprintf('biasX = %.4f\nbiasY = %.4f\nbiasZ = %.4f\n', biasX, biasY, biasZ);
s6 = '';
s7 = sprintf('Altezza Z massima = %.4f %s\nAltezza Z minima = %.4f %s\n', max_Z_value, unitZ, min_Z_value, unitZ);

set(handles.text_carica_nuovo_file, 'String', {s1 s2 s3 s4 s5 s6 s7});

% Ripristina il pulsante
set(handles.button_step0_carica_nuovo_file, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow

t = toc;
fprintf(' %.3f s\n\n', t);


end



function update_axes()

load temp_mat_data.mat misura_base misura_altezza n_decimali max_Z_value num_datax2_colonne num_datax2_righe;

n_valori_assi = 10;

x_axis_value = round(0 : misura_base/n_valori_assi : misura_base, n_decimali);
y_axis_value = round(misura_altezza : -misura_altezza/n_valori_assi : 0, n_decimali);
z_axis_value = round(0 : max_Z_value/n_valori_assi : max_Z_value, n_decimali);

% creo i tick = divisioni sugli assi alle quali far corrispondere i valori
% delle misure calcolate sopra
xticks = linspace(1, num_datax2_colonne, numel(x_axis_value));
yticks = linspace(1, num_datax2_righe, numel(y_axis_value));
zticks = linspace(1, max_Z_value, numel(z_axis_value));

save ('temp_mat_data.mat', 'x_axis_value', 'y_axis_value', 'z_axis_value', 'xticks', 'yticks', 'zticks', '-append');

end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cancella il file dei parametri elaborati
if exist('temp_mat_data.mat', 'file') == 2
    delete('temp_mat_data.mat');
end


end

function update_view_2D_3D(handles)
% set gli axes = view2D
axes(handles.view2D);
% funzione di visualizzazione 2D in scala di grigi con gli assi in scala
GUI_visualizza2D();
% hold on;
% plot(max_Z_ind_Y,max_Z_ind_X,'r+', 'MarkerSize', 10

% set gli axes = view3D
axes(handles.view3D);
GUI_visualizza3Dsurf('jet');

end

% --- Executes on button press in pushbutton_ingrandisci2D.
function pushbutton_ingrandisci2D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ingrandisci2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
GUI_visualizza2D();
end



% --- Executes on button press in pushbutton_ingrandisci3D.
function pushbutton_ingrandisci3D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ingrandisci3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure;
GUI_visualizza3Dsurf('jet');
end


% --- Executes on slider movement.
function slider_Zmin_Callback(hObject, eventdata, handles)
% hObject    handle to slider_Zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% ottieni il valore dalla slider e settalo
Zmin_soglia = num2str(floor(get(hObject,'Value')));
set(handles.slider_text,'String', Zmin_soglia);

Zmin_soglia = str2double(Zmin_soglia);

% aggiorna le immagini con le Z<Zmin = 0
save ('temp_mat_data.mat', 'Zmin_soglia', '-append');

update_view_Zmin(handles);

end

% --- Executes during object creation, after setting all properties.
function slider_Zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_Zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

end



function slider_text_Callback(hObject, eventdata, handles)
% hObject    handle to slider_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slider_text as text
%        str2double(get(hObject,'String')) returns contents of slider_text as a double

% ottieni il valore dal campo editabile e settalo
Zmin_soglia = floor(str2double(get(hObject,'String')));
set(handles.slider_Zmin,'Value', Zmin_soglia);

% aggiorna le immagini con le Z<Zmin = 0
save ('temp_mat_data.mat', 'Zmin_soglia', '-append');

update_view_Zmin(handles);

end

% --- Executes during object creation, after setting all properties.
function slider_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



end

function update_view_Zmin(handles)

load ('temp_mat_data.mat', 'Zmin_soglia');

axes(handles.view2D_Zmin);
% funzione di visualizzazione 2D in scala di grigi con gli assi in scala
GUI_visualizza2D(Zmin_soglia);
colorbar off

% set gli axes = view3D
axes(handles.view3D_Zmin);
GUI_visualizza3Dsurf('jet', Zmin_soglia);
colorbar off

end



function edit_sens_findpeaks_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sens_findpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sens_findpeaks as text
%        str2double(get(hObject,'String')) returns contents of edit_sens_findpeaks as a double

% aggiorno il valore di sens_findpeaks modificato
sens_findpeaks = str2double(get(hObject,'String'));
save ('temp_mat_data.mat', 'sens_findpeaks', '-append');

end


% --- Executes during object creation, after setting all properties.
function edit_sens_findpeaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sens_findpeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



% --- Executes on button press in pushbutton_calcola_bordi_no_view.
function pushbutton_calcola_bordi_no_view_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calcola_bordi_no_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fprintf('pushbutton_calcola_bordi_no_view: Carica .mat, calcola bordi, visualizza, salva maschere...');
tic

load temp_mat_data.mat data Zmin_soglia parametro_filtro_gaussiano

if ~exist('data', 'var')
    uiwait(errordlg('Nessun dato caricato! Importare prima un file!'));
    return;
end

% Modifica il pulsante per calcolo in corso...
% color = get(handles.pushbutton_avanti_da_4_a_5, 'Backgroundcolor')
color = [0.7098 1 0.6275];
% text = get(handles.pushbutton_avanti_da_4_a_5, 'String');
text = 'Conferma e vai al prossimo step';

set(handles.pushbutton_avanti_da_4_a_5, 'Backgroundcolor','r', 'String', 'Elaborazione in corso...', 'Enable', 'off');
drawnow


%%%%%%%%%%%%%%%%%%%%%%%%%%%    TEST CON FILTRAGGIO %%%%%%%%%%%%%%%%%%%%%
if parametro_filtro_gaussiano == 0
    data_filt = data;
else
    data_filt = imgaussfilt(data, parametro_filtro_gaussiano);
    %     data_filt = gather(imgaussfilt(gpuArray(data), parametro_filtro_gaussiano));
    save ('temp_mat_data.mat', 'data_filt', '-append');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcolo bordi 0° e setto zone a bassa altezza
bw_0 = GUI_calcola_bordi_findpeaks_O_V_no_view(data_filt);
% bw_0 = GUI_GPU_calcola_bordi_findpeaks_O_V_no_view(data_filt);
bw_0(data < Zmin_soglia) = 1;


% Calcolo 45°
data_45 = imrotate(data_filt, 45, 'bicubic');
bw_45 = GUI_calcola_bordi_findpeaks_O_V_no_view(data_45);

% funzione per ruotare e sistemare la maschera di -45°
bw_45 = sistema_bw45(bw_0, bw_45);


% Visualizzo 45°
% axes(handles.view_bordi_45);
% imshow(imoverlay_1mask(mat2gray(data), bw_45, 'rosso')); title('45°')

[bw_0, bw_45] = ridimensiona_bwmask_a_data(data, bw_0, bw_45);

% size(data)
% size(bw_0)
% size(bw_45)

bw_45(data < Zmin_soglia) = 1;

% unione delle due maschere 0° + 45° con OR logico
bw_mask = bw_0 | bw_45;

% consideriamo sempre che all'inizio abbiamo selezionato solo le Z > Zmin_soglia
% Riportiamo questa selezione sulla BWmask
%bw_mask(data < Zmin_soglia) = 1; % quindi 1 = background


% Visualizzo risultato finale
axes(handles.view_bordi_0_45);
imshow(imoverlay_1mask(mat2gray(data), bw_mask, 'rosso'));
% drawnow
axis xy;



% Salvo le tre maschere calcolate: bw_0, bw_45 e bw_mask
save ('temp_mat_data.mat', 'bw_0', 'bw_45', 'bw_mask', '-append');


% ripristina pulsante per calcolo terminato
set(handles.pushbutton_avanti_da_4_a_5, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow

t = toc;
fprintf(' %.3f s\n\n', t);

end



function carica_input_chiusura_bordo(handles)

fprintf('carica_input_chiusura_bordo: carica .mat, min pixel vicini, salva per -> carica_output_chiusura_bordo...');
tic

% Modifica il pulsante per calcolo in corso...
color = get(handles.pushbutton_avanti_input_step5, 'Backgroundcolor');
text = get(handles.pushbutton_avanti_input_step5, 'String');

set(handles.pushbutton_avanti_input_step5, 'Backgroundcolor','r', 'String', 'Elaborazione in corso...', 'Enable', 'off');
drawnow


load ('temp_mat_data.mat', 'data', 'bw_mask', 'num_min_pixel_vicini_input');

bw_mask_input = bw_mask; % lavora su una nuova variabile

% NON MODIFICABILE DALLA GUI, 1 VA BENE
dim_pixel_contorno = 1;

bw_mask_input(1:dim_pixel_contorno, :) = 1;
bw_mask_input(:, 1:dim_pixel_contorno) = 1;
bw_mask_input(size(bw_mask_input, 1) - dim_pixel_contorno+1 : size(bw_mask_input, 1) , :) = 1;
bw_mask_input(:, size(bw_mask_input, 2) - dim_pixel_contorno+1 : size(bw_mask_input, 2) ) = 1;

% Unisco i pixel isolati risultanti dal riconoscimento dei bordi
bw_mask_input = bwmorph(bw_mask_input, 'bridge');

%migliora la skel dopo, no buchi nelle aree
bw_mask_input = bwmorph(bw_mask_input, 'fill', 4);

% tolgo i pixel isolati, si mette a parametro, caso per caso
bw_mask_input = bwareafilt(bw_mask_input, [ num_min_pixel_vicini_input Inf]);

axes(handles.view_chiusura_bordo_input);
imshow(imoverlay_1mask(mat2gray(data), bw_mask_input, 'rosso')); title('Input');
axis xy;

% Salvo la maschera input per il ciclo, ad ogni modifica
save ('temp_mat_data.mat', 'bw_mask_input', '-append');

% ripristina pulsante
set(handles.pushbutton_avanti_input_step5, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow

t = toc;
fprintf(' %.3f s\n\n', t);


end


function edit_num_min_pixel_vicini_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_num_min_pixel_vicini_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_num_min_pixel_vicini_input as text
%        str2double(get(hObject,'String')) returns contents of edit_num_min_pixel_vicini_input as a double

num_min_pixel_vicini_input = str2double(get(hObject, 'String'));
save ('temp_mat_data.mat', 'num_min_pixel_vicini_input', '-append');

% aggiorno la visualizzazione
carica_input_chiusura_bordo(handles);

end

% --- Executes during object creation, after setting all properties.
function edit_num_min_pixel_vicini_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_num_min_pixel_vicini_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes on button press in flag_visualizza.
function flag_visualizza_Callback(hObject, eventdata, handles)
% hObject    handle to flag_visualizza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flag_visualizza

flag_visualizza = get(hObject, 'Value');
save ('temp_mat_data.mat', 'flag_visualizza', '-append');

end



function carica_output_chiusura_bordo(handles)

fprintf('carica_output_chiusura_bordo: chiama GUI_chiudi_bordi_enspoints(), carica risultato, visualizza...');
tic

load ('temp_mat_data.mat', 'data', 'bw_mask_output', 'flag_visualizza');

% Modifica il pulsante per calcolo in corso...
color = get(handles.pushbutton_avanti_da_step5_a_step6, 'Backgroundcolor');
text = get(handles.pushbutton_avanti_da_step5_a_step6, 'String');

set(handles.pushbutton_avanti_da_step5_a_step6, 'Backgroundcolor','r', 'String', 'Elaborazione in corso...', 'Enable', 'off');
drawnow


% chiama la funzione per l'estensione dei minimi intorno agli endpoint
[~, fig_handle] = GUI_chiudi_bordi_enspoints_findpeaks_graph();

load ('temp_mat_data.mat', 'bw_mask_output');

% carica e visualizza il risultato
axes(handles.view_chiusura_bordo_output);
imshow(imoverlay_1mask(mat2gray(data), bw_mask_output, 'rosso')); title('Output');
axis xy;

% se la figure DEMO è aperta, portala in primo piano
if ishandle(fig_handle)
    figure(fig_handle)
    title('Ciclo endpoints finito')
end

% ripristina pulsante
set(handles.pushbutton_avanti_da_step5_a_step6, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow


t = toc;
fprintf(' %.3f s\n\n', t);

end




function carica_pulizia_bordi(handles)

fprintf('carica_pulizia_bordi: chiama GUI_pulizia_bordi(), visualizza...');

% Modifica il pulsante per calcolo in corso...
color = get(handles.pushbutton_avanti_da_step6_a_step7, 'Backgroundcolor');
text = get(handles.pushbutton_avanti_da_step6_a_step7, 'String');

set(handles.pushbutton_avanti_da_step6_a_step7, 'Backgroundcolor','r', 'String', 'Elaborazione in corso...', 'Enable', 'off');
drawnow

GUI_pulizia_bordi();

% carica e visualizza il risultato
load ('temp_mat_data.mat', 'data', 'bw_mask_finale');
axes(handles.view_disegno_libero);
imshow(imoverlay_1mask(mat2gray(data), ~bw_mask_finale, 'rosso'));
axis xy;

% ripristina pulsante
set(handles.pushbutton_avanti_da_step6_a_step7, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow

t = toc;
fprintf(' %.3f s\n\n', t);

end


function set_parametri_da_mat(handles)

% Carico il mat
% Se trovo già le variabili = è stato fatto un caricamento dei parametri prima, quindi li setto.
% Altrimenti metti i valori default

% se esiste un file .mat, caricalo
if exist('temp_mat_data.mat', 'file') == 2
    load ('temp_mat_data.mat');
end


% altrimenti setta le variabili ai loro valori default

% set dell'altezza minima per i dati
if exist('Zmin_soglia', 'var') == 0
    Zmin_soglia = 0;
end
set(handles.slider_text,'String', Zmin_soglia);
set(handles.slider_Zmin, 'Value', Zmin_soglia);


if exist('sens_findpeaks', 'var') == 0 %se non esiste la variabile sens_findpeaks
    
    if exist('data', 'var') == 1 % e se data è stato caricato dal .mat
        
        n_righe = size(data, 1);
        n_col = size(data, 2);
        
        % leggi due righe (a n_righe/3 e n_righe/2)
        [~,~,~,p1]  = findpeaks( - data( round(n_righe / 2), :), 'MinPeakProminence' , 0.5, 'MinPeakDistance', 10);
        
        % leggi due colonne (a n_col/3 e n_col/2)
        [~,~,~,p2]  = findpeaks( - data( :, round(n_col / 2)), 'MinPeakProminence' , 0.5, 'MinPeakDistance', 10);
        
        sens_findpeaks =   min ([(median(p1)) (median(p2))]);
        
        sens_findpeaks =  round(sens_findpeaks);
        
        
    else
        sens_findpeaks = 5; % altrimenti metti 5
    end
end
set(handles.edit_sens_findpeaks, 'String', num2str(sens_findpeaks));


if exist('parametro_filtro_gaussiano', 'var') == 0
    parametro_filtro_gaussiano = 0;
end


% se esiste la matrice dei disegni, cancellala.
% Verrà rifatta alla prima chiamata di pushbutton_disegno_libero_Callback
%     if exist('bw_add_totale', 'var') == 1
%         removevar('temp_mat_data.mat', 'bw_add_totale')
% %         bw_mask_output = bw_mask_output | bw_add_totale;
%     end


% pulisce dai pixel non connessi, limita il rumore prima del riconoscimento
% bordi
if exist('num_min_pixel_vicini_input', 'var') == 0
    num_min_pixel_vicini_input = 0;
end
set(handles.edit_num_min_pixel_vicini_input, 'String', num2str(num_min_pixel_vicini_input));


% 0 false, 1 true, mostra o meno l'avanzamento dei pixel di chiusura
% contorno endpoint
flag_visualizza = 0;


%pixel da esaltare nella distance map in input al watershed: piccolo (1,2,3) se grani piccoli, altrimenti a piacere (5, 10, 15)
% Se riconosce aree troppo piccole, aumentare il valore.
%Se riconosce poche aree grandi, diminuirlo.
if exist('dim_watershed_aree', 'var') == 0
    dim_watershed_aree = 3;
end
set(handles.edit_dim_watershed_aree, 'String', num2str(dim_watershed_aree));


% valore della trasparenza del risultato finale del watershed
if exist('watershed_output_trasparenza', 'var') == 0
    watershed_output_trasparenza = 0.2;
end
set(handles.edit_watershed_output_trasparenza, 'String', num2str(watershed_output_trasparenza));




% alla fine se NON esisteva il file .mat lo creo (no -append)
if exist('temp_mat_data.mat', 'file') == 0
    save ('temp_mat_data.mat', 'Zmin_soglia', 'num_min_pixel_vicini_input', ...
        'flag_visualizza', 'dim_watershed_aree', 'watershed_output_trasparenza',...
        'sens_findpeaks', 'parametro_filtro_gaussiano');
else
    % altrimenti sovrascrivi le nuove variabili
    save ('temp_mat_data.mat', 'Zmin_soglia', 'num_min_pixel_vicini_input', ...
        'flag_visualizza', 'dim_watershed_aree', 'watershed_output_trasparenza',...
        'sens_findpeaks', 'parametro_filtro_gaussiano','-append');
end


end




function step6_watershed(handles)

fprintf('step6_watershed: carica.mat, calcola watershed, visualizza input/output, salva...');
tic


% Modifica il pulsante per calcolo in corso...
color = get(handles.pushbutton_avanti_watershed, 'Backgroundcolor');
text = get(handles.pushbutton_avanti_watershed, 'String');

set(handles.pushbutton_avanti_watershed, 'Backgroundcolor','r', 'String', 'Elaborazione in corso...', 'Enable', 'off');
drawnow


load ('temp_mat_data.mat', 'bw_mask_finale', 'dim_watershed_aree', 'data', 'bw_mask_imfill_esterno', 'Zmin_soglia', 'num_min_pixel_vicini_pulizia_bordi');

distance_map = -bwdist(~bw_mask_finale);
mask = imextendedmin(distance_map, dim_watershed_aree);
watershed_input = imimposemin(distance_map, mask);

% calcolo watershed
watershed_output_labeled = watershed(watershed_input);

ridges = watershed_output_labeled == 0;

watershed_output_labeled(data < Zmin_soglia) = 0;   % riporto le aree di bkg
watershed_output_labeled(bw_mask_imfill_esterno == 0) = 0;    % riporto il bordo nero

% tutto ciò che ha un etichetta > 0 è un grano, quindi così ho una maschera
% binaria con 1 = grano, 0 = bordo
watershed_output_bwmask = watershed_output_labeled > 0;

%tolgo i pixel isolati
watershed_output_bwmask = ~bwareafilt(~watershed_output_bwmask, [ num_min_pixel_vicini_pulizia_bordi Inf]);

% salvo per visualizzare eventuale subplot
save ('temp_mat_data.mat', 'ridges', 'watershed_output_labeled', 'watershed_input', 'watershed_output_bwmask', '-append');

%visualizzo output
visualizza_watershed_output(handles);

t = toc;
fprintf(' %.3f s\n\n', t);


% ripristina pulsante
set(handles.pushbutton_avanti_watershed, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow


% scrivi il numero di grani trovati nel text_watershed_num_grani_trovati
tot_grani = max(watershed_output_labeled(:));
% str = sprintf('Numero grani trovati\n%d', tot_grani);
set(handles.text_watershed_num_grani_trovati, 'String', {'Numero grani trovati', ' ', num2str(tot_grani)});

% A questo punto ho settato tutti i parametri, abilito il pulsante di
% salvataggio dei parametri attuali nella schermata principale


end



function edit_dim_watershed_aree_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dim_watershed_aree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dim_watershed_aree as text
%        str2double(get(hObject,'String')) returns contents of edit_dim_watershed_aree as a double

dim_watershed_aree = str2double(get(hObject, 'String'));
save ('temp_mat_data.mat', 'dim_watershed_aree', '-append');

step6_watershed(handles);

end

% --- Executes during object creation, after setting all properties.
function edit_dim_watershed_aree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dim_watershed_aree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in button_watershed_piu.
function button_watershed_piu_Callback(hObject, eventdata, handles)
% hObject    handle to button_watershed_piu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dim_watershed_aree = str2double(get(handles.edit_dim_watershed_aree, 'String'));
dim_watershed_aree = dim_watershed_aree + 1;

save ('temp_mat_data.mat', 'dim_watershed_aree', '-append');

set(handles.edit_dim_watershed_aree, 'String', num2str(dim_watershed_aree));

step6_watershed(handles);

end


% --- Executes on button press in button_watershed_meno.
function button_watershed_meno_Callback(hObject, eventdata, handles)
% hObject    handle to button_watershed_meno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dim_watershed_aree = str2double(get(handles.edit_dim_watershed_aree, 'String'));

% eseguo le operazioni solo se il valore è >= 0, altrimenti non faccio
% niente
if dim_watershed_aree > 0
    dim_watershed_aree = dim_watershed_aree - 1;
    
    save ('temp_mat_data.mat', 'dim_watershed_aree', '-append');
    
    set(handles.edit_dim_watershed_aree, 'String', num2str(dim_watershed_aree));
    
    step6_watershed(handles);
end



end



function edit_watershed_output_trasparenza_Callback(hObject, eventdata, handles)
% hObject    handle to edit_watershed_output_trasparenza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_watershed_output_trasparenza as text
%        str2double(get(hObject,'String')) returns contents of edit_watershed_output_trasparenza as a double

watershed_output_trasparenza = str2double(get(hObject, 'String'));
save ('temp_mat_data.mat', 'watershed_output_trasparenza', '-append');

visualizza_watershed_output(handles, eventdata);

end


% --- Executes during object creation, after setting all properties.
function edit_watershed_output_trasparenza_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_watershed_output_trasparenza (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function visualizza_watershed_output(handles, eventdata)

load ('temp_mat_data.mat', 'watershed_output_labeled', 'data', 'watershed_output_trasparenza', 'watershed_output_bwmask');

Lrgb = label2rgb(watershed_output_labeled, 'hsv', 'black', 'shuffle');

axes(handles.view_output_watershed);
cla reset

GUI_visualizza2D();
hold on

if watershed_output_trasparenza == 0
    imshow(imoverlay_1mask(mat2gray(data), ~watershed_output_bwmask, 'rosso'), []);
    caxis([min(min(data)) max(max(data))]) % altrimenti prende i livelli di grigio 0-256
else
    himage = imshow(Lrgb);
    himage.AlphaData = watershed_output_trasparenza;
end

title('');
axis on;
axis xy;


drawnow;

end


function visualizza_statistiche_step7(handles, eventdata)

fprintf('visualizza_statistiche_step7 (carica .mat, regionprops, modifica struttura, vis tabella)...');

load ('temp_mat_data.mat', 'watershed_output_labeled', 'data', 'watershed_output_bwmask', 'xticks', 'yticks', 'x_axis_value', 'y_axis_value', ...
    'scaleX', 'scaleY', 'unitX', 'unitY');

% nomi delle proprietà nella funzione REGIONPROPS
% LE PROPRIETA' CON PIù DI UN VALORE DANNO PROBLEMI !!!!
% BoundingBox E WeightedCentroid VENGONO CALCOLATI IN stats MA NON
% VISUALIZZATI
prop_name = {'Area', 'Perimeter', 'MinIntensity', 'MeanIntensity', 'MaxIntensity', 'BoundingBox', 'WeightedCentroid'};


stats_pixel = regionprops(watershed_output_labeled, data, prop_name);

% sistemo struttura per la visualizzazione nella uitable
num_grani = size(stats_pixel, 1);

% % % % % % % % % %
% converti qui le aree da pixel in unità metriche

% HO FATTO UN RADDOPPIO DI DIMENSIONI, QUINDI scaleX VALE META'
% DELL'ORIGINALE
scaleX_dopo_raddoppio = scaleX / 2;
scaleY_dopo_raddoppio = scaleY / 2;

stats_misure_reali = stats_pixel;
for i = 1 : num_grani
    stats_misure_reali(i).Area = (sqrt(stats_pixel(i).Area) * scaleX_dopo_raddoppio) ^ 2;
    stats_misure_reali(i).Perimeter = stats_pixel(i).Perimeter * scaleX_dopo_raddoppio;
    stats_misure_reali(i).LarghezzaBB = stats_pixel(i).BoundingBox(3) * scaleX_dopo_raddoppio;
    stats_misure_reali(i).AltezzaBB = stats_pixel(i).BoundingBox(4) * scaleY_dopo_raddoppio;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_per_uitable = {};

for m = 1:num_grani
    %fprintf('\nRiga %d, Col %d (%s): valore %d', m, n, prop_name{n}, stats(m).(prop_name{n}))
    
    %         data_per_uitable{m,n} = stats_pixel(m).(prop_name{n});
    %             data_per_uitable{m,n} = stats_misure_reali(m).(prop_name{n});
    data_per_uitable{m,1} = stats_misure_reali(m).Area;
    data_per_uitable{m,2} = stats_misure_reali(m).Perimeter;
    data_per_uitable{m,3} = stats_misure_reali(m).LarghezzaBB;
    data_per_uitable{m,4} = stats_misure_reali(m).AltezzaBB;
    data_per_uitable{m,5} = stats_misure_reali(m).MinIntensity;
    data_per_uitable{m,6} = stats_misure_reali(m).MeanIntensity;
    data_per_uitable{m,7} = stats_misure_reali(m).MaxIntensity;
    
end



% % % % % % % % % %


% Nomi da visualizzare nella tabella delle statistiche

nomi_tabella = {'Area', 'Perimetro', 'Misura lato X', 'Misura lato Y', 'Altezza minima', 'Altezza media', 'Altezza massima'};

% visualizzo tabella
set(handles.step7_tabella_statistiche, 'Data', data_per_uitable, 'ColumnName', nomi_tabella);

t = toc;
fprintf(' %.3f s\n\n', t);


% aggiorna l'immagine a fianco della tabella
visualizza_immagine_step7(handles)


save('temp_mat_data.mat', 'stats_pixel', 'stats_misure_reali', 'data_per_uitable', 'num_grani', 'nomi_tabella','-append');


statistiche_hist(handles);


% abilito il pulsante per salvare le immagini e statistiche ottenute
set(handles.pushbutton_salva_img_ax, 'Enable', 'on');


end


function statistiche_hist (handles)

load ('temp_mat_data.mat', 'data', 'unitX', 'stats_misure_reali', 'num_grani', 'data_per_uitable', 'estensione');

if strcmp(estensione, '.txt')
    
    axes(handles.view_panel8_hist);
    cla
    
    valori_aree = cell2mat(data_per_uitable(:, 1));
    
    %# compute edges (evenly divide range into bins)
    nBins = 20;
    edges = linspace(min(valori_aree), max(valori_aree), nBins+1);
    
    %# compute center of bins (used as x-coord for labels)
    bins = ( edges(1:end-1) + edges(2:end) ) / 2;
    
    %# histc
    [counts,binIdx] = histc(valori_aree, edges);
    counts(end-1) = sum(counts(end-1:end));  %# combine last two bins
    counts(end) = [];                        %#
    
    
    %# plot histogram
    bar(edges(1:end-1), counts, 'histc')
    ylabel('Numero grani')
    xlabel(strcat('Intervalli area [ ', unitX, '^{2}]'));
    
    %# format the axis
    set(gca, 'FontSize',9, ...
        'XLim',[edges(1) edges(end)], ...    %# set x-limit to edges
        'YLim',[0 ceil(1.1*max(counts))], ...        %# expand ylimit to accommodate labels
        'XTick',edges, ...                   %# set xticks  on the bin edges
        'XTickLabel',num2str(edges','%.3f')) %'# round to 2-digits
    
    
    title('Istogramma delle aree')
    grid on
    
    
end

end


function visualizza_immagine_step7(handles, num_grano)

fprintf('visualizza_immagine_step7 (carica .mat, BB grano, visualizza img)...');

load ('temp_mat_data.mat', 'data', 'watershed_output_bwmask', 'xticks', 'yticks', 'x_axis_value', 'y_axis_value');

axes(handles.view_step7_grani_stats);
cla reset

% visualizza il singolo grano se è passato come parametro, altrimenti
% visualizza l'intera maschera del watershed
if exist('num_grano', 'var')
    
    if (num_grano == 0)
        
        % caso in cui clicco su un bordo o una zona a bassa altezza
        set(handles.text_dati_selezione_grano, 'String', 'Il punto selezionato non fa parte di nessun grano, è un bordo!');
        
        imshow(imoverlay_1mask(mat2gray(data), ~watershed_output_bwmask, 'rosso'), []);
        
        
    else
        
        % ho bisogno dell'identificazione dei grani anche, in questo caso
        load ('temp_mat_data.mat', 'stats_pixel', 'watershed_output_labeled');
        
        % prova a disegnare anche il bounding box intorno, non eccedere i
        % bordi dell'immagine (maggiore di 1 il sx/sopra, minore del max il dx/sotto)
        col_start = max( 1, floor(stats_pixel(num_grano).BoundingBox(1)));
        riga_start = max( 1, floor(stats_pixel(num_grano).BoundingBox(2)));
        col_add = floor(stats_pixel(num_grano).BoundingBox(3));
        riga_add = floor(stats_pixel(num_grano).BoundingBox(4));
        
        col_end = col_start + col_add;
        riga_end = riga_start + riga_add;
        
        bw_bounding_box = zeros(size(data));
        bw_bounding_box (riga_start :  riga_end, col_start : col_end) = 1;
        bw_bounding_box = bwperim(bw_bounding_box);
        
        imshow(imoverlay_2mask(mat2gray(data), bwperim(watershed_output_labeled == num_grano), 'rosso', bw_bounding_box, 'verde'), []);
        
        print_text_dati_selezione_grano(handles, num_grano);
        %             str = sprintf('\nGrano selezionato #%d', num_grano);
        %             set(handles.text_dati_selezione_grano, 'String', str);
        
    end
    
else
    imshow(imoverlay_1mask(mat2gray(data), ~watershed_output_bwmask, 'rosso'), []);
end


set(gca, 'XTick', xticks, 'XTickLabel', x_axis_value);
set(gca, 'YTick', yticks, 'YTickLabel', flipud(y_axis_value(:)));
axis on;
axis xy;

drawnow

t = toc;
fprintf(' %.3f s\n\n', t);

end


% --- Executes when selected cell(s) is changed in step7_tabella_statistiche.
function step7_tabella_statistiche_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to step7_tabella_statistiche (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    
    handles.currentCell=eventdata.Indices;
    guidata(gcf,handles);
    handles=guidata(gcf);
    Indices=handles.currentCell;
    
    riga_selezionata = Indices(1);
    colonna_selezionata = Indices(2); % estrai gli indici della cella selezionata
    
    visualizza_immagine_step7(handles, riga_selezionata)
    
end

end



% --- Executes on button press in pushbutton_gui_input_click.
function pushbutton_gui_input_click_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gui_input_click (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('temp_mat_data.mat', 'watershed_output_labeled');

% aggiorna l'immagine
visualizza_immagine_step7(handles);

click_fuori_immagine = true;

% evito errori in caso di click fuori dall'immagine
while click_fuori_immagine
    [x,y] = ginput(1);
    x = round(x);
    y = round(y);
    
    if (x < size(watershed_output_labeled, 2)) & (y < size(watershed_output_labeled, 1) & (x > 0) & (y > 0))
        click_fuori_immagine = false;
    else
        set(handles.text_dati_selezione_grano, 'HorizontalAlignment', 'center');
        set(handles.text_dati_selezione_grano, 'String', 'Devi cliccare dentro l''immagine');
    end
end

set(handles.text_dati_selezione_grano, 'HorizontalAlignment', 'left');

num_grano = watershed_output_labeled(y, x);

% aggiorna l'immagine
visualizza_immagine_step7(handles, num_grano);

% aggiorna il testo con le statistiche
print_text_dati_selezione_grano(handles, num_grano)

% quindi apri la visualizzazione 3D del grano selezionato
click_grano_3D_figure(handles, num_grano);

end



function click_grano_3D_figure(handles, num_grano)

load('temp_mat_data.mat', 'stats_pixel', 'stats_misure_reali', 'data', 'watershed_output_labeled', 'unitX', 'unitY', 'unitZ', 'max_Z_value');

% NUM RIGA     NUM ELEMENTO DELL'ARRAY
% stats(5).BoundingBox(1)

%evita errori in caso di click su un grano!
if num_grano ~= 0
    
    % Creo rettangolo bounding box del grano num_grano
    col_start = max( 1, floor(stats_pixel(num_grano).BoundingBox(1)));
    riga_start = max( 1, floor(stats_pixel(num_grano).BoundingBox(2)));
    col_add = floor(stats_pixel(num_grano).BoundingBox(3));
    riga_add = floor(stats_pixel(num_grano).BoundingBox(4));
    
    col_end = col_start + col_add;
    riga_end = riga_start + riga_add;
    
    
    
    % crop di data e watershed al bb trovato
    crop_data_bb = data(riga_start :  riga_end, col_start : col_end);
    crop_watershed_bb = watershed_output_labeled(riga_start :  riga_end, col_start : col_end);
    
    % crop_data_bb = flip(crop_data_bb, 2);
    % crop_watershed_bb = flip (crop_watershed_bb, 2);
    
    
    
    % visualizzo il dato interno del bb a bassa trasparenza
    f = figure;
    surf_bounding_box = surf(crop_data_bb, 'EdgeColor', 'none', 'FaceColor', 'interp');
    alpha(surf_bounding_box, 0.45);
    hold on;
    
    % elimino le zone che non fanno parte del grano rilevato
    crop_grano = crop_data_bb;
    crop_grano(crop_watershed_bb ~= num_grano) = nan;
    
    % visualizzo sopra solo il grano con trasparenza a 1
    surf_grano = surf( crop_grano, 'EdgeColor', 'none', 'FaceColor', 'interp');
    alpha(surf_grano, 1);
    
    
    %% settaggi per la visualizzazione
    
    % serve per disabilitare lo stretch della figure di matlab, che distorce le reali
    % proporzioni del grano, così invece è reale
    %     pbaspect([1 1 1]);
    daspect([0.1 0.1 1]);
    
    
    xlim([1 col_add]);
    ylim([1 riga_add]);
    
    misura_base = stats_misure_reali(num_grano).LarghezzaBB;
    misura_altezza = stats_misure_reali(num_grano).AltezzaBB;
    x_axis_value = round(0 : misura_base / 8 : misura_base, 2);
    y_axis_value = round(misura_altezza : -misura_altezza/8 : 0, 2);
    z_axis_value = round(0 : max_Z_value/8 : max_Z_value, 2);
    
    % creo i tick = divisioni sugli assi alle quali far corrispondere i valori
    % delle misure calcolate sopra
    xticks = linspace(1, col_add, numel(x_axis_value));
    yticks = linspace(1, riga_add, numel(y_axis_value));
    zticks = linspace(1, max_Z_value, numel(z_axis_value));
    
    set(gca, 'XTick', xticks, 'XTickLabel', x_axis_value);
    set(gca, 'YTick', yticks, 'YTickLabel', flipud(y_axis_value(:)));
    set(gca, 'ZTick', zticks, 'ZTickLabel', z_axis_value);
    
    axis xy;
    xlabel(strcat('X [', unitX, ']'));
    ylabel(strcat('Y [', unitY, ']'));
    zlabel(strcat('Z [', unitZ, ']'));
    
    titolo = sprintf('Grano n° %d', num_grano);
    title(titolo);
    colorbar
    
    
    %% test ORIENTATION
    
    
    colWC_ass = round(stats_pixel(num_grano).WeightedCentroid(1));
    rigaWC_ass = round(stats_pixel(num_grano).WeightedCentroid(2));
    
    colWC_rel = colWC_ass - col_start;
    rigaWC_rel = rigaWC_ass - riga_start;
    
    % visualizza il WC sull'immagine 2D delle statistiche
    axes(handles.view_step7_grani_stats);
    hold on;
    plot(colWC_ass, rigaWC_ass, 'r*', 'MarkerSize', 5);
    
    
    % poi visualizza surf 3d del grano
    figure(f);
    hold on;
    
    % marker del punto WC
    plot3(colWC_rel, rigaWC_rel, crop_grano(rigaWC_rel, colWC_rel), 'r*', 'MarkerSize', 15)
    
    % visualizza linea di orientamento = da centro del grano a Z=0 al WC
    % trovato
    line([col_add/2 colWC_rel], [riga_add/2 rigaWC_rel], [0 crop_grano(rigaWC_rel, colWC_rel)], 'Color','red');
    
    %     hold off
    
    %     figure;
    %     subplot (1,2, 1)
    %     imshow(crop_watershed_bb == num_grano); hold on
    %     plot(colWC, rigaWC_rel, 'r*', 'MarkerSize', 15)
    %     subplot (1 ,2, 2)
    %     imshow(crop_grano, []); hold on
    %     plot(colWC, rigaWC_rel, 'r*', 'MarkerSize', 15)
    
    %% OPPURE USO IL MAX AL POSTO DEL WEIGHTEDCENTROID
    [M,I] = max(crop_grano(:));
    [I_row, I_col] = ind2sub(size(crop_grano),I);
    
    plot3(I_col, I_row, crop_grano(I_row, I_col), 'b*', 'MarkerSize', 20)
    
    
    punti_col = [col_add/2 I_col];
    punti_righe = [riga_add/2 I_row];
    punti_z = [0 crop_grano(I_row, I_col)];
    line(punti_col, punti_righe, punti_z, 'Color','b');
    
    
    %     quiver3(punti_col(1), punti_righe(1), punti_z(1),punti_col(2), punti_righe(2), punti_z(2), 'Color','b', 'MaxHeadSize',0.5);
    
    
    
    % visualizza il WC sull'immagine 2D delle statistiche
    axes(handles.view_step7_grani_stats);
    hold on;
    plot(I_col + col_start, I_row + riga_start, 'b*', 'MarkerSize', 5);
    
    % porta la figure del grano 3D in primo piano
    figure(f);
    
    % save('crop_grano.mat', 'crop_grano');
    
    % test3d_originale
    % anaglifico = test3d(crop_grano, 2);
    % figure; imshow(anaglifico)
end

end



% Aggiorna il testo del box sotto all'immagine delle statistiche del grano
% selezionato
function print_text_dati_selezione_grano(handles, num_grano)

load ('temp_mat_data.mat', 'stats_misure_reali', 'unitX', 'unitY', 'unitZ');

% evita errore in caso di click su un bordo
if num_grano ~= 0
    
    str = '';
    
    str = sprintf('Grano selezionato n° %d          Misura %.3f %s x %.3f %s', ...
        num_grano, stats_misure_reali(num_grano).LarghezzaBB, unitX, stats_misure_reali(num_grano).AltezzaBB, unitY);
    
    str = strcat(str, sprintf('\nArea =  %.3f %s^2              Perimetro %.2f %s', ...
        stats_misure_reali(num_grano).Area, unitX, stats_misure_reali(num_grano).Perimeter, unitX));
    
    set(handles.text_dati_selezione_grano, 'String', str);
end

end


% --- Executes on button press in pushbutton_trasparenza_watershed_piu.
function pushbutton_trasparenza_watershed_piu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_trasparenza_watershed_piu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('temp_mat_data.mat', 'watershed_output_trasparenza');

if watershed_output_trasparenza < 0.9
    watershed_output_trasparenza = watershed_output_trasparenza + 0.1;
    
    save('temp_mat_data.mat', 'watershed_output_trasparenza', '-append');
    
    set(handles.edit_watershed_output_trasparenza, 'String', num2str(watershed_output_trasparenza));
    visualizza_watershed_output(handles);
    
end


end


% --- Executes on button press in pushbutton_trasparenza_watershed_meno.
function pushbutton_trasparenza_watershed_meno_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_trasparenza_watershed_meno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('temp_mat_data.mat', 'watershed_output_trasparenza');

% se è 0 non fare nulla
if watershed_output_trasparenza == 0
    return
end


if watershed_output_trasparenza <= 0.1
    
    watershed_output_trasparenza = 0;
    set(handles.edit_watershed_output_trasparenza, 'String', '0');
    
else
    watershed_output_trasparenza = watershed_output_trasparenza - 0.1;
    set(handles.edit_watershed_output_trasparenza, 'String', num2str(watershed_output_trasparenza));
end


save('temp_mat_data.mat', 'watershed_output_trasparenza', '-append');

visualizza_watershed_output(handles);

end


% --- Executes on button press in pushbutton_carica_parametri.
function pushbutton_carica_parametri_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_carica_parametri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName, PathName] = uigetfile(fullfile('.','*.mat') , 'Seleziona il file dei parametri da caricare...');

if FileName == 0
    % User clicked the Cancel button.
    return;
end

% prima di leggere il file controllo che la dimensione sia consona,
% minore di 1 MB (solitamente è pochi KB)
% / 1024 per passare da bytes a KB
% così evito di bloccare l'app se carico qualcosa di grosso per sbaglio
infofile = dir(strcat(PathName, FileName));

sizeMB = infofile.bytes / 1024 / 1024;

if sizeMB > 1
    s1 = sprintf('Il file selezionato ha una dimensione eccessiva per essere un precedente salvataggio di parametri!\n ');
    s2 = sprintf('Dimensione file caricato = %.2f MB', sizeMB);
    s3 = sprintf('Dimensione massima consentita = %.2f MB', 1);
    uiwait(errordlg({s1 s2 s3}));
    return
end


fprintf('Carica parametri: importazione da file %s...\n', FileName);

% importa nel workspace i parametri
load(strcat(PathName, FileName));


% Verifico che il file selezionato contenga tutti i parametri
% necessari, altrimenti torno errore
if ~(exist('dim_watershed_aree') ...
        & exist('num_min_pixel_vicini_input') & exist('sens_findpeaks') ...
        & exist('watershed_output_trasparenza') & exist('Zmin_soglia') & exist('parametro_filtro_gaussiano'))
    
    uiwait(errordlg('Il file selezionato non contiene i parametri aspettati!'));
    return
    
end

% qui ho caricato tutti i parametri necessari, quindi ok!


% parametro OPZIONALE della matrice dei disegni a mano.
% se era stato salvato, importalo
if exist('bw_add_totale', 'var') == 1
    save ('temp_mat_data.mat', 'bw_add_totale', '-append');
end

% quindi salvali (sovrascrivi) sul file temporaneo creato da GUI_importASCII
save ('temp_mat_data.mat', 'dim_watershed_aree', ...
    'num_min_pixel_vicini_input', 'sens_findpeaks', 'watershed_output_trasparenza',...
    'Zmin_soglia', 'parametro_filtro_gaussiano', '-append');


s0 = sprintf('Parametri caricati dal file:\n%s\n\n', FileName);
s1 = sprintf('Zmin_soglia = %.2f', Zmin_soglia);
s2 = sprintf('\nsens_findpeaks = %.2f', sens_findpeaks);
s3 = sprintf('\nparametro_filtro_gaussiano = %d', parametro_filtro_gaussiano);
s4 = sprintf('\nnum_min_pixel_vicini_input = %.2f', num_min_pixel_vicini_input);
s5 = sprintf('\ndim_watershed_aree = %.2f', dim_watershed_aree);
s6 = sprintf('\nwatershed_output_trasparenza = %.2f', watershed_output_trasparenza);

if exist('bw_add_totale', 'var') == 1
    s7 = sprintf('\nMatrice dei disegni a mano: SI');
else
    s7 = sprintf('\nMatrice dei disegni a mano: NO');
end

set(handles.text_carica_parametri, 'String', {s0 s1 s2 s3 s4 s5 s6 s7});






% ora chiamo la funzione per aggiornare i parametri nuovi caricati,
% così gli edittext sono congruenti con il .mat
set_parametri_da_mat(handles);

update_view_Zmin(handles);


% abilita il pulsante per fare l'elaborazione di tutti gli step con i
% parametri appena caricati
set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'Enable', 'on');


end








% --- Executes on button press in pushbutton_subplot_watershed.
function pushbutton_subplot_watershed_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_subplot_watershed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load ('temp_mat_data.mat', 'ridges', 'watershed_output_labeled', 'watershed_input', 'bw_mask_finale', 'watershed_output_bwmask', 'data');

% Visualizza la bwdist input con i bordi
% view_input = watershed_input;
% view_input(~bw_mask_finale == 1) = -Inf;

figure;
subplot (1, 2, 1);  imshow(watershed_input, []), title('Input watershed'); axis xy;
% subplot (1, 2, 2);  imshow(ridges, []), title('"ridges" watershed'); axis xy;

% figure
subplot (1, 2, 2); imshow(imoverlay_1mask(mat2gray(data), (watershed_input == -Inf), 'rosso')); axis xy; title('Seed input watershed')
% subplot (2, 2, 3);  imshow(watershed_output_labeled, []), title('Output watershed labeled'); axis xy;
% subplot (2, 2, 4);  imshow(watershed_output_bwmask, []), title('Output watershed bwmask'); axis xy;

end


% --- Executes on button press in pushbutton_num_min_pixel_vicini_input_piu.
function pushbutton_num_min_pixel_vicini_input_piu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_num_min_pixel_vicini_input_piu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load ('temp_mat_data.mat', 'num_min_pixel_vicini_input');

num_min_pixel_vicini_input = num_min_pixel_vicini_input + 5;

save ('temp_mat_data.mat', 'num_min_pixel_vicini_input', '-append');

set(handles.edit_num_min_pixel_vicini_input, 'String', num2str(num_min_pixel_vicini_input));

% aggiorno la funzione interessata dalla modifica
carica_input_chiusura_bordo(handles)

end


% --- Executes on button press in pushbutton_num_min_pixel_vicini_input_meno.
function pushbutton_num_min_pixel_vicini_input_meno_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_num_min_pixel_vicini_input_meno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load ('temp_mat_data.mat', 'num_min_pixel_vicini_input');


% se il valore è già a 0, non fare nulla
if num_min_pixel_vicini_input == 0
    return
else if num_min_pixel_vicini_input <= 5
        % altrimenti se il valore è 1, 2, 3, 4 setta 0, per non andare in negativo
        num_min_pixel_vicini_input = 0;
    else
        % in tutti gli altri casi (valore > 5) togli 5
        num_min_pixel_vicini_input = num_min_pixel_vicini_input - 5;
    end
end

save ('temp_mat_data.mat', 'num_min_pixel_vicini_input', '-append');

set(handles.edit_num_min_pixel_vicini_input, 'String', num2str(num_min_pixel_vicini_input));

% aggiorno la funzione interessata dalla modifica
carica_input_chiusura_bordo(handles)


end


% --- Executes on button press in pushbutton_avanti_da_4_a_5.
function pushbutton_avanti_da_4_a_5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avanti_da_4_a_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\npushbutton_avanti_da_4_a_5_Callback');

% ottengo i nomi delle variabili attualmente presenti nel .mat
variabili_nel_mat = who('-file', 'temp_mat_data.mat');


% Chiama carica_input_chiusura_bordo se ho i dati necessari all'elaborazione (bw_mask)
if ismember('bw_mask', variabili_nel_mat)
    
    carica_input_chiusura_bordo(handles);
    % quindi passa la visualizzazione al tab corretto
    set(handles.tgroup, 'SelectedTab', handles.tab5);
else
    errordlg('I bordi non sono stati ancora calcolati!!');
end

end


% --- Executes on button press in pushbutton_avanti_input_step5.
function pushbutton_avanti_input_step5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avanti_input_step5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\npushbutton_avanti_input_step5_Callback\n');

% ottengo i nomi delle variabili attualmente presenti nel .mat
variabili_nel_mat = who('-file', 'temp_mat_data.mat');


% Chiama carica_output_chiusura_bordo se ho i dati necessari all'elaborazione (bw_mask_input)
if ismember('bw_mask_input', variabili_nel_mat)
    carica_output_chiusura_bordo(handles);
else
    errordlg('L''input della maschera non è ancora stato calcolato o confermato nello step precedente!');
end


end



% --- Executes on button press in pushbutton_avanti_da_step5_a_step6.
function pushbutton_avanti_da_step5_a_step6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avanti_da_step5_a_step6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fprintf('\npushbutton_avanti_da_step5_a_step6_Callback');

% ottengo i nomi delle variabili attualmente presenti nel .mat
variabili_nel_mat = who('-file', 'temp_mat_data.mat');

% Chiama carica_pulizia_bordi se ho i dati necessari all'elaborazione (bw_mask_input)
if ismember('bw_mask_output', variabili_nel_mat)
    carica_pulizia_bordi(handles);
    set(handles.tgroup, 'SelectedTab', handles.tab6);
else
    errordlg('L''output non è ancora stato calcolato!');
end



end


% --- Executes on button press in pushbutton_avanti_da_step6_a_step7.
function pushbutton_avanti_da_step6_a_step7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avanti_da_step6_a_step7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\npushbutton_avanti_da_step6_a_step7_Callback');

% ottengo i nomi delle variabili attualmente presenti nel .mat
variabili_nel_mat = who('-file', 'temp_mat_data.mat');

% Chiama step6_watershed se ho i dati necessari all'elaborazione (bw_mask_finale)
if ismember('bw_mask_finale', variabili_nel_mat)
    step6_watershed(handles)
    set(handles.tgroup, 'SelectedTab', handles.tab7);
else
    errordlg('L''elaborazione di questo step non è ancora stata calcolata!');
end


end




% Pulsante AVANTI per confermare il watershed e calcolare le
% statistiche nello step successivo
function pushbutton_avanti_watershed_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avanti_watershed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



fprintf('\npushbutton_avanti_watershed_Callback');

% ottengo i nomi delle variabili attualmente presenti nel .mat
variabili_nel_mat = who('-file', 'temp_mat_data.mat');

% Chiama step6_watershed se ho i dati necessari all'elaborazione (watershed_output_labeled)
if ismember('watershed_output_labeled', variabili_nel_mat)
    visualizza_statistiche_step7(handles);
    set(handles.tgroup, 'SelectedTab', handles.tab8);
else
    errordlg('L''elaborazione di questo step non è ancora stata calcolata!');
end


end



% --- Executes on button press in pushbutton_sens_findpeaks_piu.
function pushbutton_sens_findpeaks_piu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sens_findpeaks_piu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load ('temp_mat_data.mat', 'sens_findpeaks');

% raddoppia la sensibilità ad ogni pressione, il (10 * ...)/10 è per calcolare
% solo 1 decimale
sens_findpeaks = round(10 * sens_findpeaks * 2) / 10;

set(handles.edit_sens_findpeaks, 'String', num2str(sens_findpeaks));

save ('temp_mat_data.mat', 'sens_findpeaks', '-append');

pushbutton_calcola_bordi_no_view_Callback('', '', handles);

end


% --- Executes on button press in pushbutton_sens_findpeaks_meno.
function pushbutton_sens_findpeaks_meno_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sens_findpeaks_meno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



load ('temp_mat_data.mat', 'sens_findpeaks');

% dimezza la sensibilità ad ogni pressione
sens_findpeaks = round(10 * sens_findpeaks / 2) / 10;

set(handles.edit_sens_findpeaks, 'String', num2str(sens_findpeaks));

save ('temp_mat_data.mat', 'sens_findpeaks', '-append');

pushbutton_calcola_bordi_no_view_Callback('', '', handles);

end


% --- Executes on button press in pushbutton_avvia_elab_da_parametri_caricati.
function pushbutton_avvia_elab_da_parametri_caricati_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_avvia_elab_da_parametri_caricati (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Modifica il pulsante per calcolo in corso...
color = get(handles.pushbutton_avvia_elab_da_parametri_caricati, 'Backgroundcolor');
text = get(handles.pushbutton_avvia_elab_da_parametri_caricati, 'String');

set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'Backgroundcolor','r', 'String', 'Calcola bordi...', 'Enable', 'off');
drawnow

pushbutton_calcola_bordi_no_view_Callback('', '', handles);

set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'String', 'Chiudi bordi...');
drawnow

carica_input_chiusura_bordo(handles);
carica_output_chiusura_bordo(handles);

set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'String', 'Pulisci bordi...');
drawnow

carica_pulizia_bordi(handles);

set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'String', 'Watershed e statistiche...');
drawnow

step6_watershed(handles)
visualizza_statistiche_step7(handles);

set(handles.pushbutton_avvia_elab_da_parametri_caricati, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow

end



% --- Executes on button press in pushbutton_calcola_bordi_viewOnImage.
function pushbutton_calcola_bordi_viewOnImage_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calcola_bordi_viewOnImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


fprintf('pushbutton_calcola_bordi_viewOnImage: Carica .mat, calcola bordi VIEW, visualizza, salva maschere...');
tic

load temp_mat_data.mat data Zmin_soglia

if ~exist('data', 'var')
    uiwait(errordlg('Nessun dato caricato! Importare prima un file!'));
    return;
end

% Modifica il pulsante per calcolo in corso...
color = get(handles.pushbutton_calcola_bordi_viewOnImage, 'Backgroundcolor');
text = get(handles.pushbutton_calcola_bordi_viewOnImage, 'String');

set(handles.pushbutton_calcola_bordi_viewOnImage, 'Backgroundcolor','r', 'String', 'Elaborazione in corso...', 'Enable', 'off');
drawnow




% Calcolo bordi e setto zone a bassa altezza
bw_0 = GUI_calcola_bordi_findpeaks_O_V_viewOnImage();
bw_0(data < Zmin_soglia) = 1;

% visualizzazione 0°
% axes(handles.view_bordi_0);
% imshow(imoverlay_1mask(mat2gray(data), bw_0, 'rosso')); title ('0°');


% Calcolo 45°
data_45 = imrotate(data, 45, 'bicubic');
bw_45 = GUI_calcola_bordi_findpeaks_O_V_viewOnImage(data_45);

% funzione per ruotare e sistemare la maschera di -45°
bw_45 = sistema_bw45(bw_0, bw_45);
bw_45(data < Zmin_soglia) = 1;

% Visualizzo 45°
% axes(handles.view_bordi_45);
% imshow(imoverlay_1mask(mat2gray(data), bw_45, 'rosso')); title('45°')


% unione delle due maschere 0° + 45° con OR logico
bw_mask = bw_0 | bw_45;

% consideriamo sempre che all'inizio abbiamo selezionato solo le Z > Zmin_soglia
% Riportiamo questa selezione sulla BWmask
%bw_mask(data < Zmin_soglia) = 1; % quindi 1 = background


% Visualizzo risultato finale
axes(handles.view_bordi_0_45);
imshow(imoverlay_1mask(mat2gray(data), bw_mask, 'rosso'));
axis xy;

% Salvo le tre maschere calcolate: bw_0, bw_45 e bw_mask
save ('temp_mat_data.mat', 'bw_0', 'bw_45', 'bw_mask', '-append');


% ripristina pulsante per calcolo terminato
set(handles.pushbutton_calcola_bordi_viewOnImage, 'Backgroundcolor', color, 'String', text, 'Enable', 'on');
drawnow

t = toc;
fprintf(' %.3f s\n\n', t);



end


% --- Executes on button press in pushbutton_calcola_bordi_findpeaks_view_subplot.
function pushbutton_calcola_bordi_findpeaks_view_subplot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calcola_bordi_findpeaks_view_subplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('pushbutton_calcola_bordi_findpeaks_view_subplot_Callback: Carica .mat, calcola bordi VIEW, visualizza, salva maschere...');
tic

variabili_nel_mat = who('-file', 'temp_mat_data.mat');

if ~ismember('data', variabili_nel_mat)
    uiwait(errordlg('Nessun dato caricato! Importare prima un file!'));
    return;
end

% NON TORNA NIENTE, FA SOLO VEDERE COME SELEZIONA I MINIMI DI CURVATURA!
GUI_calcola_bordi_findpeaks_DEMO_view_subplot();

t = toc;
fprintf(' %.3f s\n\n', t);

end





function edit_filtro_gaussiano_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filtro_gaussiano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filtro_gaussiano as text
%        str2double(get(hObject,'String')) returns contents of edit_filtro_gaussiano as a double

parametro_filtro_gaussiano = str2double(get(hObject, 'String'));

save ('temp_mat_data.mat', 'parametro_filtro_gaussiano', '-append');

end

% --- Executes during object creation, after setting all properties.
function edit_filtro_gaussiano_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filtro_gaussiano (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


end



% --- Executes on button press in checkbox_collega_viste_2D_3D.
function checkbox_collega_viste_2D_3D_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_collega_viste_2D_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_collega_viste_2D_3D

if (get(hObject,'Value') == 1)
    linkaxes([handles.view2D , handles.view3D],'xy');
else
    linkaxes([handles.view2D , handles.view3D],'off');
end


end


% --- Executes on button press in pushbutton_ritaglia_visualizzazione_corrente.
function pushbutton_ritaglia_visualizzazione_corrente_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ritaglia_visualizzazione_corrente (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load temp_mat_data.mat data

newColXLim = floor(handles.view2D.XLim);
newRowYLim = floor(handles.view2D.YLim);

% in caso lo zoom vada fuori dall'immagine, evita errori
if newRowYLim(1) < 1
    newRowYLim(1) = 1;
end

if newColXLim(1) < 1
    newColXLim(1) = 1;
end

[n_righe, n_col] = size(data);

if newColXLim(2) > n_col
    newColXLim(2) = n_col;
end

if newRowYLim(2) > n_righe
    newRowYLim(2) = n_righe;
end

% ritaglio il dato alle X:Y dello zoom
data_zoom = data ( newRowYLim(1) : newRowYLim(2) , newColXLim(1) : newColXLim(2) );


f = figure;
imshow(data_zoom, []);
axis xy;


choice = questdlg('Confermare il ritaglio dell''immagine originale con la selezione attuale?', ...
    'Ritaglio dell''immagine', ...
    'Si','No', 'No');

switch choice
    case 'Si'
        
        % chiudo anteprima del ritaglio
        close(f);
        
        % sostituisco DATA con il crop effettuato
        data = data_zoom;
        save('temp_mat_data', 'data', '-append');
        
        
        load ('temp_mat_data');
        
        % salvo gli attuali valori per stamparli poi, in u;no storico
        old_misura_base = misura_base;
        old_misura_altezza = misura_altezza;
        old_sizeX = sizeX;
        old_sizeY = sizeY;
        old_max_Z_value = max_Z_value;
        old_min_Z_value = min_Z_value;
        
        clear bw* ridges watershed* %tolgo i resti di computazioni precedenti
        
        %%%%%%%%%%%%%%% AGGIORNA TUTTI I DATI INTERESSATI DALLA MODIFICA
        num_datax2_colonne = size(data, 2);
        num_datax2_righe = size(data, 1);
        [max_Z_value, Ind_max] = max(data(:));
        [max_Z_ind_X, max_Z_ind_Y] = ind2sub(size(data),Ind_max);
        
        % ricalcolo la dimensione del campione, (num_pixel/2) * scala
        % /2 perchè i pixel sono stati raddoppiati precedentemente
        
        sizeX = floor(num_datax2_colonne/2);
        sizeY = floor(num_datax2_righe/2);
        
        misura_base = sizeX * scaleX;
        misura_altezza = sizeY * scaleY;
        
        
        
        save ('temp_mat_data.mat', 'num_datax2_righe', 'num_datax2_colonne', 'max_Z_value', 'max_Z_ind_X', ...
            'max_Z_ind_Y', 'misura_base', 'misura_altezza', 'sizeX', 'sizeY', '-append');
        
        
        % IMMAGINE DEFAULT NEGLI AXES
        % ottengo gli handles di tutti gli axes della GUI
        hAxes = arrayfun(@cla,findall(0,'type','axes'));
        
        % % myImage = imread('.\img\nodata1.gif');
        %     myImage = imread('.\img\nodata2.png');
        myImage = imread(fullfile('.','img','nodata2.png'));
        
        % myImage = imread('.\img\nodata3.png');
        
        for i = 1 : length(hAxes)
            axes(hAxes(i));
            cla reset
            imshow(myImage, []);
        end
        
        
        % richiama tutte le funzioni per aggiornare lo stato degli step
        set_parametri_da_mat(handles);
        
        update_axes();
        update_view_2D_3D(handles);
        
        update_view_Zmin(handles);
        set(handles.slider_text, 'Max', floor(max_Z_value));
        set(handles.slider_Zmin, 'Max', floor(max_Z_value));
        set(handles.slider_Zmin, 'SliderStep', [10/max_Z_value, 0.1]);
        
        
        
        % Aggiornamento del box testo nella home (text_carica_nuovo_file)
        s0 = sprintf('Nome file:\n%s%s\n\n', PathName, FileName);
        s1 = sprintf('******** DATI PRIMA DEL RITAGLIO ********\n\n');
        s2 = sprintf('Misura lato X = %.4f %s\nMisura lato Y = %.4f %s\n', old_misura_base, unitX, old_misura_altezza, unitY);
        s3 = sprintf ('Numero misurazioni X = %d\nNumero misurazioni Y = %d\n',  old_sizeX, old_sizeY);
        s4 = sprintf('Altezza Z massima = %.4f %s\nAltezza Z minima = %.4f %s\n\n', old_max_Z_value, unitZ, old_min_Z_value, unitZ);
        
        s5 = sprintf('******** NUOVE MISURE DOPO IL RITAGLIO ********\n\n');
        s6 = sprintf('Misura lato X = %.4f %s\nMisura lato Y = %.4f %s\n', misura_base, unitX, misura_altezza, unitY);
        s7 = sprintf ('Numero misurazioni X = %d\nNumero misurazioni Y = %d\n',  sizeX, sizeY);
        s8 = sprintf('Altezza Z massima = %.4f %s\nAltezza Z minima = %.4f %s\n', max_Z_value, unitZ, min_Z_value, unitZ);
        
        %         testo_old = strjoin( {s0, s1, s2, s3, s4}, '\n');
        testo_new = strjoin( {s5, s6, s7, s8});
        
        
        
        set(handles.text_carica_nuovo_file, 'String', {s0, s1, s2, s3, s4, s5, s6, s7, s8} );
        msgbox( testo_new , 'Ritaglio effettuato')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
    case 'No'
        uiwait(msgbox('Ritaglio annullato', 'Nessuna modifica apportata al dato.'))
        close(f)
end







end


% --- Executes on button press in pushbutton_disegno_libero.
function pushbutton_disegno_libero_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_disegno_libero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


load('temp_mat_data.mat', 'data', 'bw_mask_output', 'bw_mask_finale', 'bw_add_totale');

% se è la prima volta che si disegna, allora crea la matrice "storia"
% dei disegni, in essa verranno memorizzati tutti i disegni fatti
% dall'utente e al bisogno si possono cancellare tutti
if exist('bw_add_totale', 'var') == 0
    bw_add_totale = zeros(size(data));
end

data_n_r = size(data, 1);
data_n_c = size(data, 2);

axes(handles.view_disegno_libero);

% aggiorna l'immagine visto che partiamo dalla bw_mask_output (ossia la bw precedente, input di questo step)
imshow(imoverlay_1mask(mat2gray(data), bw_mask_output, 'rosso'), []);
axis xy
drawnow


% catturo il percorso mentre si clicca
hFH = imfreehand('Closed', false);

% nessun punto selezionato, utente esce dall'inserimento
if length(hFH) == 0
    return
end

xy =  round(hFH.getPosition);

delete(hFH);

% vettore di 'distanza' tra i punti della linea interpolata
% minore è la distanza centrale e più punti genera
t = 0 : .02 : 1;
x = xy(:, 1);
y = xy(:, 2);
bw_add = zeros(size(data));

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
        
        bw_add(C(2,ind), C(1,ind)) = 1;
        
        x_interp = cat(1, x_interp, C(1,ind));
        y_interp = cat(1, y_interp, C(2,ind));
        
    end
    
    
end



% calcolo BB del disegno
stat = regionprops( bw_add, 'BoundingBox');

x_start = floor(stat.BoundingBox(1));
y_start = floor(stat.BoundingBox(2));

x_add = floor(stat.BoundingBox(3));
y_add = floor(stat.BoundingBox(4));

x_end = x_start + x_add;
y_end = y_start + y_add;

% controllo che la coord X di inizio sia dentro l'img
if x_start < 1
    x_start = 1;
end

if x_start > data_n_c
    x_start = data_n_c;
end


% controllo che la coord Y di inizio sia dentro l'img
if y_start < 1
    y_start = 1;
end

if y_start > data_n_r
    y_start = data_n_r;
end


% controllo che la coord X di fine sia dentro l'img
if x_end < 1
    x_end = 1;
end

if x_end > data_n_c
    x_end = data_n_c;
end


% controllo che la coord Y di fine sia dentro l'img
if y_end < 1
    y_end = 1;
end

if y_end > data_n_r
    y_end = data_n_r;
end


%    fprintf('data( %d : %d, %d : %d)', x_start, x_end, y_start, y_end);
%    size(data);


data_bb_bw_add = data(y_start : y_end, x_start : x_end);
bb_bw_add = bw_add(y_start : y_end, x_start : x_end);



% aggiorna l'axes principale
axes(handles.view_disegno_libero);
imshow(imoverlay_2mask(mat2gray(data), bw_mask_output, 'rosso', bw_add, 'blu'), []);
axis xy
drawnow

% mostra immagine del BB ingrandita e chiedi se confermare o meno il
% disegno
f = figure;
movegui(f,'west');
imshow(imoverlay_1mask(mat2gray(data_bb_bw_add), bb_bw_add, 'rosso'), [], 'InitialMagnification', 'fit'), axis xy;


choice = questdlg('Confermare l''aggiunta?', ...
    'Conferma', ...
    'SI','NO','NO');


switch choice
    case 'SI'
        
        % aggiungi il disegno alla matrice di tutti i disegni (storico)
        % serve per permettere il reset dei disegni
        bw_add_totale = bw_add_totale | bw_add;
        
        % aggiungi la bw_add alla bw_mask e salvala nel .mat
        %            bw_mask_output = bw_mask_output | bw_add;
        
        
        
        save('temp_mat_data', 'bw_add_totale', '-append');
        
        % aggiorna la visualizzazione e pulisci il disegno
        carica_pulizia_bordi(handles)
        
    case 'NO'
        % non salvare nulla, ripristina la visualizzazione della
        % maschera bw_mask_finale senza modifiche
        axes(handles.view_disegno_libero);
        imshow(imoverlay_1mask(mat2gray(data), ~bw_mask_finale, 'rosso'), []);
        axis xy
        drawnow
        
end

close(f)


end


% --------------------------------------------------------------------
% --- Executes on button press in pushbutton_salva_img_ax.
function pushbutton_salva_img_ax_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_salva_img_ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


addpath(fullfile('.', 'export_fig'));

load('temp_mat_data.mat', 'data', 'FileName', 'bw_mask_finale', 'watershed_output_labeled', 'watershed_output_trasparenza', 'watershed_output_bwmask')

[~, nome_file , ~] = fileparts(FileName);

% posizione dove creare la cartella
folder_path = uigetdir('dove?', 'Dove salvare le immagini?');

% finestra chiusa senza premere OK
if folder_path == 0
    msgbox('Salvataggio annullato');
    return;
end

% nome dei file immagine
prompt = {'Nome con cui salvare i file immagine:', 'Titolo impresso nell''immagine:'};
defaultans = {nome_file, nome_file};
answer = inputdlg(prompt , 'Inserire nome file e titolo' , [1 50] , defaultans);

if length(answer) == 0
    msgbox('Salvataggio annullato');
    return
end

nome_input = answer{1};
titolo = answer{2};

cartella_salvataggio = fullfile(folder_path, strcat('Output export - ', nome_input));

mkdir(cartella_salvataggio);

% 2D
msgbox({'Salvataggio delle immagini nella cartella:', ' ' , cartella_salvataggio, ' ', 'in corso...', '', ...
    '1/4...', '', ''}, 'modal');
f = figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
GUI_visualizza2D();
title( {titolo ; ' '} , 'Interpreter', 'none');
str = strcat(fullfile(cartella_salvataggio, strcat(nome_input, '_2D')));
export_fig (f, str, '-png', '-q101', '-r300')
close(f)

% exist(str, 'file')

% 3D
msgbox({'Salvataggio delle immagini nella cartella:', ' ' , cartella_salvataggio, ' ', 'in corso...', '', ...
    '1/4 OK, 2/4...', ''}, 'modal');
f = figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
GUI_visualizza3Dsurf('jet');
title( {titolo ; ' '} , 'Interpreter', 'none');
str = strcat(fullfile(cartella_salvataggio, strcat(nome_input, '_3D')));
export_fig (f, str, '-png', '-q101', '-r300')
% export_fig file.pdf -q101 -r300 -nocrop -append
close(f)


% output watershed con bordi rossi
msgbox({'Salvataggio delle immagini nella cartella:', ' ' , cartella_salvataggio, ' ', 'in corso...', '', ...
    '1/4 OK, 2/4 OK, 3/4...', '', ''}, 'modal');
f = figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
GUI_visualizza2D();
cl = caxis;% serve per non sfasare i valori della colorbar dalle altezze a 0:256
hold on
imshow(imoverlay_1mask(mat2gray(data), ~watershed_output_bwmask, 'rosso'), []);
caxis(cl); %ripristino i valori della colorbar (venivano sfasati dall'imshow in 0:256)
axis on
axis xy
title( {titolo ; ' '} , 'Interpreter', 'none');
str = strcat(fullfile(cartella_salvataggio, strcat(nome_input, '_grani')));
export_fig (f, str, '-png', '-q101', '-r300')
% export_fig file.pdf -q101 -r300 -nocrop -append
% close(f)


% watershed
msgbox({'Salvataggio delle immagini nella cartella:', ' ' , cartella_salvataggio, ' ', 'in corso...', '', ...
    '1/4 OK, 2/4 OK, 3/4 OK, 4/4...', '', ''}, 'modal');
f = figure('Visible', 'off', 'units','normalized','outerposition',[0 0 1 1]);
GUI_visualizza2D();
hold on
Lrgb = label2rgb(watershed_output_labeled, 'hsv', 'black', 'shuffle');
himage = imshow(Lrgb);
% evita che se la trasparenza è settata a 0 non vengano i colori
if watershed_output_trasparenza == 0
    himage.AlphaData = 0.15;
else
    himage.AlphaData = watershed_output_trasparenza;
end

title( {titolo ; ' '} , 'Interpreter', 'none');
axis on;
axis xy;
str = strcat(fullfile(cartella_salvataggio, strcat(nome_input, '_grani_colore')));
export_fig (f, str, '-png', '-q101', '-r300')
% export_fig file.pdf -q101 -r300 -nocrop -append
close(f)

str = strcat(fullfile(cartella_salvataggio, strcat(nome_input, '_BWmask.mat')));
watershed_output_bwmask = ~watershed_output_bwmask;
save(str, 'watershed_output_bwmask');

str = strcat(fullfile(cartella_salvataggio, strcat(nome_input, '_data.mat')));
save(str, 'data')

uiwait(msgbox({'Salvataggio delle immagini nella cartella:', ' ' , cartella_salvataggio, ' ', 'in corso...', '', ...
    '1/4 OK, 2/4 OK, 3/4 OK, 4/4 OK', '', 'Salvataggio completato!'}, 'modal'));

% if exist(cartella_salvataggio,'dir') ~= 0
%     open(cartella_salvataggio)
% end


% chiamo la funzione per salvare le statistiche dei grani, nella stessa
% cartella
export_statistiche_ascii(cartella_salvataggio, nome_input)

% chiamo la funzione per salvare i parametri usati per la segmentazione
salva_parametri(cartella_salvataggio, nome_input)

end




% salva le statistiche prodotte dalla tabella in un file txt
function export_statistiche_ascii(cartella_salvataggio, nome_file)

load('temp_mat_data.mat', 'FileName', 'data_per_uitable', 'nomi_tabella', 'unitX', 'unitY', 'unitZ');

carattere_delimitatore = ';';

% calcolo ora e data attuali, da aggiungere al nome proposto
format shortg
c = fix(clock);   % c = [year month day hour minute seconds]

stringa_data_ora = sprintf('%d.%02d.%02d-%02d.%02d', c(3), c(2), c(1), c(4), c(5));
nome_file_stats = strcat('statistiche - ', nome_file, ' - ' , stringa_data_ora , '.csv');

% nome temporaneo per salvare i dati, poi andrà cancellato
filename_tmp = strcat(cartella_salvataggio, 'tmp');

% scrivo il file temporaneo dei dati
% AGGIUNGO UNA COLONNA DI ID_GRANO = 1,2,3....
data_per_uitable = [(1:size(data_per_uitable, 1))'  cell2mat(data_per_uitable)];
dlmwrite(filename_tmp, data_per_uitable, 'delimiter', carattere_delimitatore)

% leggo il file temporaneo appena creato
Str = fileread(filename_tmp);

% creo il nuovo file finale
fid = fopen(fullfile(cartella_salvataggio, nome_file_stats), 'w');

if fid == -1
    error('Errore nella creazione del file');
    return
end


% creo i nomi delle colonne
str_num_grano = sprintf('Numero grano');
str_area = sprintf('Area [%s^2]', unitX);
str_perimetro = sprintf('Perimetro [%s]', unitX);
str_x = sprintf('Misura lato X [%s]', unitX);
str_y = sprintf('Misura lato Y [%s]', unitY);
str_altmin = sprintf('Altezza minima [%s]', unitZ);
str_altmed = sprintf('Altezza media [%s]', unitZ);
str_altmax = sprintf('Altezza massima [%s]', unitZ);


nomi_tabella = strcat(str_num_grano, carattere_delimitatore ,  str_area, carattere_delimitatore ,str_perimetro, carattere_delimitatore , ...
    str_x, carattere_delimitatore , str_y, carattere_delimitatore , str_altmin, carattere_delimitatore , str_altmed, carattere_delimitatore , str_altmax);

% scrivo i nomi delle colonne creati prima
fprintf(fid,'%s\n', nomi_tabella);

% scrivo il resto dei dati
fwrite(fid, Str, 'char');


% chiudo e cancello il file temporaneo
fclose(fid);
delete(filename_tmp);


if exist(fullfile(cartella_salvataggio, nome_file_stats), 'file') == 2
    s = sprintf('Le statistiche sono state salvate in %s', fullfile(cartella_salvataggio, nome_file_stats));
    uiwait(msgbox(s));
else
    errordlg('Il file non è stato creato! Errore...');
    return
end


end





function salva_parametri(cartella_salvataggio, nome_file)

load('temp_mat_data.mat');

% calcolo ora e data attuali, da aggiungere al nome proposto
format shortg
c = fix(clock);   % c = [year month day hour minute seconds]

stringa_data_ora = sprintf(' - %d.%02d.%02d-%02d.%02d', c(3), c(2), c(1), c(4), c(5));
nome_proposto = strcat('param - ', nome_file, stringa_data_ora,'.mat');

destinazione_salvataggio = fullfile(cartella_salvataggio, nome_proposto);

save(destinazione_salvataggio, 'dim_watershed_aree', ...
    'num_min_pixel_vicini_input', 'sens_findpeaks', 'watershed_output_trasparenza',...
    'Zmin_soglia', 'parametro_filtro_gaussiano');


% se è stato fatto almeno un disegno a mano allora esisterà la matrice
% bw_add_totale, quindi salvala
if exist('bw_add_totale', 'var') == 1
    save(destinazione_salvataggio, 'bw_add_totale', '-append')
end


s1 = sprintf('Parametri salvati in');
s2 = sprintf('"%s"\n', destinazione_salvataggio);

uiwait(msgbox({s1 s2}, 'Salvataggio completato'));

end







% --- Executes on button press in pushbutton_reset_disegni.
function pushbutton_reset_disegni_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset_disegni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('temp_mat_data.mat', 'bw_add_totale');

% se non esiste la matrice = non c'è nulla da fare
if exist('bw_add_totale', 'var') == 0
    uiwait(msgbox('Nessun disegno trovato...', 'Nessun disegno trovato!'))
    return
end

% Altrimenti chiedi conferma se cancellare o meno
choice = questdlg('Confermare il reset di tutti i disegni a mano libera?', ...
    'Reset disegni', ...
    'Si','No', 'No');

switch choice
    case 'Si'
        
        % altrimenti resetta la matrice = tutta a zero
        bw_add_totale = zeros(size(bw_add_totale));
        
        % salvala nel temp
        save('temp_mat_data', 'bw_add_totale', '-append');
        
        % aggiorna la visualizzazione
        carica_pulizia_bordi(handles)
        
    case 'No'
        return
end


end

% --- Executes on button press in pushbutton_filtro_piu.
function pushbutton_filtro_piu_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_filtro_piu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


parametro_filtro_gaussiano = str2double(get(handles.edit_filtro_gaussiano, 'String'));
parametro_filtro_gaussiano = parametro_filtro_gaussiano + 1;

set(handles.edit_filtro_gaussiano, 'String', num2str(parametro_filtro_gaussiano));

save ('temp_mat_data.mat', 'parametro_filtro_gaussiano', '-append');

pushbutton_calcola_bordi_no_view_Callback(hObject, eventdata, handles);

end

% --- Executes on button press in pushbutton_filtro_meno.
function pushbutton_filtro_meno_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_filtro_meno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

parametro_filtro_gaussiano = str2double(get(handles.edit_filtro_gaussiano, 'String'));

if parametro_filtro_gaussiano <= 0
    return
end

parametro_filtro_gaussiano = parametro_filtro_gaussiano - 1;

set(handles.edit_filtro_gaussiano, 'String', num2str(parametro_filtro_gaussiano));

save ('temp_mat_data.mat', 'parametro_filtro_gaussiano', '-append');

pushbutton_calcola_bordi_no_view_Callback(hObject, eventdata, handles);

end


% --- Executes on button press in pushbutton_ground_truth.
function pushbutton_ground_truth_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ground_truth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

run('ground_truth.m');

end
