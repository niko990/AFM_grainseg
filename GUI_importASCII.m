function [file_ok] = GUI_importASCII(PathName, FileName)
%importASCII Seleziona il file ASCII da importare
%   Apre il file, rileva tutti i dati dello header e carica la matrice dei
%   dati come variabili globali visibili nel workspace
%   Inoltre sistema le profondità portandole a RELATIVE = Z_min è 0.
%   Calcola Z_max e Z_min.
   
    % indica che c'è stato un errore nella lettura file (sintassi sbagliata)
    file_ok = true;
    
    fprintf('GUI_importASCII: lettura e salvataggio dati dal file %s...', FileName);
    tic
    
    
    % leggo un immagine normale - SOLO PER TEST
    [~, ~, estensione] = fileparts(lower(FileName));
    if strcmp(estensione, '.jpg')  | strcmp(estensione, '.png')
        img = imread(strcat(PathName, FileName));
        
        
        if size(img,3)==3 % se è RGB, converti in gray
            data = double(rgb2gray(img));
        else % altrimenti va bene così
            data = double(img);
        end
        %figure; imshow(data, []);   
        
        sizeX = size(data, 1);
        sizeY = size(data, 2);
        scaleX = 0;
        scaleY = 0;
        scaleZ = 0;
        biasX = 0;
        biasY = 0;
        biasZ = 0;
        unitX = '';
        unitY = '';
        unitZ = '';
        misura_base = 0;
        misura_altezza = 0;
        min_Z_value = 0;
                
        save temp_mat_data.mat
        return
    
    else
    
    
    %filepath = fullfile(PathName, FileName);
    fid = fopen(strcat(PathName, FileName));
    scan_header = textscan(fid,'%s %s',14,'Delimiter','=');

%     scan_header =    1×2 cell array   :    {14×1 cell}    {14×1 cell}

%     scan_header{1, 1} : NOMI DEI PARAMETRI ESPORTATI DA NOVA
    %     {'File Format '                                      }
    %     {'Created by Nova, NT-MDT ltd., 20/09/2017 12:46:31' }
    %     {'File: C:\......\file.mdt'                          }
    %     {'NX '                                               }
    %     {'NY '                                               }
    %     {'Scale X '                                          }
    %     {'Scale Y '                                          }
    %     {'Scale Data '                                       }
    %     {'Bias X '                                           }
    %     {'Bias Y '                                           }
    %     {'Bias Data '                                        }
    %     {'Unit X '                                           }
    %     {'Unit Y '                                           }
    %     {'Unit Data '                                        }
    
%     scan_header{1, 2} : VALORI DEI RELATIVI PARAMETRI
    %     {'ASCII'    }
    %     {0×0 char   }
    %     {0×0 char   }
    %     {'256'      }
    %     {'256'      }
    %     {'0.0078'   }
    %     {'0.0078'   }
    %     {'-0.0780'  }
    %     {'34.8338'  }
    %     {'34.0000'  }
    %     {'2555.8259'}
    %     {'um'       }
    %     {'um'       }
    %     {'nm'       }
    
    %scan_header {1, 1} {n}   : legge il NOME PARAMETRO della riga n-esima
    %scan_header {1, 2} {n}   : legge il VALORE della riga n-esima
    
    % Verifico che sia stato selezionato un file dal formato corretto:
    % controllo i nomi dei parametri: il primo (NX, riga 4) e l'ultimo (Unit Data, riga 14)
    
    if ~(strcmp(scan_header{1, 1}{4}, 'NX ') & strcmp(scan_header{1, 1}{14}, 'Unit Data '))
        errordlg('Il file selezionato non rispetta il formato di esportazione ASCII di NOVA!');
        fclose(fid);
        file_ok = false;
        return
    end
    
    
    
    % Lettura dati header dal file
    sizeX = str2double(scan_header{1,2}{4}); % num pixel X
    sizeY = str2double(scan_header{1,2}{5}); % num pixel Y

    scaleX = str2double(scan_header{1,2}{6}); % distanza tra 2 misurazioni X nell'unità di misura
    scaleY = str2double(scan_header{1,2}{7}); % distanza tra 2 misurazioni Y nell'unità di misura
    scaleZ = str2double(scan_header{1,2}{8}); % distanza tra 2 misurazioni Z nell'unità di misura

    biasX = str2double(scan_header{1,2}{9}); % offset X per ottenere la misura assoluta del campione, se necessario
    biasY = str2double(scan_header{1,2}{10}); % offset Y per ottenere la misura assoluta del campione, se necessario
    biasZ = str2double(scan_header{1,2}{11}); % offset Z per ottenere la misura assoluta del campione, se necessario

    unitX = scan_header{1,2}{12}; % unità di misura [stringa] di esportazione di X (um, nm, Angstrom,...)
    unitY = scan_header{1,2}{13}; % unità di misura [stringa] di esportazione di Y (um, nm, Angstrom,...)
    unitZ = scan_header{1,2}{14}; % unità di misura [stringa] di esportazione di Z (um, nm, Angstrom,...)

    % Lettura degli [sizeX * sizeY] valori Z
    delimiterIn = ' ';
    headerlinesIn = 16;
    data = importdata(strcat(PathName, FileName) , delimiterIn , headerlinesIn);
    data = data.data;

    % chiusura file
    fclose(fid);


    % SPIANA IL DATO, TOGLI L'INCLINAZIONE
%     figure;subplot(1, 2, 1), imshow(data, []);
    data = detrend_2d(data);
%     subplot(1, 2, 2), imshow(data, []);

    % bisogna flippare perchè la lettura dei dati parte
    % dal primo elemento ma è rovescia rispetto alla visualizzazione di NOVA
    %data = flip(data ,1);
    %data = flip(data ,2);

    % dimensioni del campione rettangolare/quadrato nell'unità di misura
    % dell'esportazione (um, nm,...)
    misura_base = sizeX * scaleX;
    misura_altezza = sizeY * scaleY;


    %% Analisi MAX, MIN

    % minimo valore di profondità -> PER PASSARE DA Z ASSOLUTE A RELATIVE
    min_Z_value = min(data(:));

    % calcolo della profondità relativa: tutte le Z - Zmin
    % così la profondità parte da 0 e non da valori dipendenti dallo spessore
    % della piastrina o altre variabili dello strumento
    % se Zmin > 0 : abbassa tutti i dati di Zmin, porta tutto sullo 0
    % se Zmin < 0 : alza tutti i dati a 0
    data = data - min_Z_value;

    % aggiornamento e verifica che Zmin sia 0 zero
    min_Z_value = min(data(:));

    % tolgo le variabili che non è necessario salvare nel .mat
    clear fid scan_header delimiterIn headerlinesIn
    
    save temp_mat_data.mat

    t = toc;
    fprintf(' %.3f s\n\n', t);
    
    
    end
    
end

