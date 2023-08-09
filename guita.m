function varargout = guita(varargin)
% GUITA M-file for guita.fig
%      GUITA, by itself, creates a new GUITA or raises the existing
%      singleton*.
%
%      H = GUITA returns the handle to a new GUITA or the handle to
%      the existing singleton*.
%
%      GUITA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITA.M with the given input arguments.
%
%      GUITA('Property','Value',...) creates a new GUITA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guita_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guita_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guita

% Last Modified by GUIDE v2.5 18-Jul-2011 12:21:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guita_OpeningFcn, ...
                   'gui_OutputFcn',  @guita_OutputFcn, ...
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


% --- Executes just before guita is made visible.
function guita_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guita (see VARARGIN)

% Choose default command line output for guita
    handles.output = hObject;

    set(handles.btn_fcm,'Enable','off');
    set(handles.btn_valid,'Enable','off');
    set(handles.btn_center,'Enable','off');
    axes(handles.axes1);
    axis off;
    axes(handles.axes2);
    axis off;
    axes(handles.axes3);
    axis off;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guita wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guita_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName as text
%        str2double(get(hObject,'String')) returns contents of fileName as a double


% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
    [file, folder]=uigetfile(...
        {'*.gif;','File Image(*.gif;)';'*.png;','File Image(*.png;)';...
         '*.bmp;','File Image(*.bmp;)';'*.tif;','File Image(*.tif;)';...
         '*.jpg;','File Image(*.jpg;)';'*.*','Semua File(*.*)'}, 'Pilih Gambar',...
         'C:\Users\hisyam_fahm\Documents\MATLAB\TAq');
    if file ~= 0
        img = [folder file];
        handles.image = imread(img);
        %Membedakan citra 2D atau 3D
        if length(size(handles.image))== 3
            handles.image = handles.image;
            handles.image = rgb2gray(handles.image);   
            %handles.image = round(handles.image*255);
        end
        %Mendapatkan image input
        [handles.y,handles.x]=size(handles.image);
        h = fspecial('gaussian');
        handles.image = uint8(imfilter(handles.image, h));  
        set(handles.fileName,'String',img);
        axes(handles.axes1);
        imshow(handles.image);
%         colormap('gray');
%         axis(handles.axes1,'off'); 
    end
    clear handles.centers;
    set(handles.btn_fcm,'Enable','off');
    set(handles.btn_valid,'Enable','off');
    set(handles.btn_center,'Enable','off');
    set(handles.ps_de,'String',0);
    set(handles.ps_fcm,'String',0);
    set(handles.db_de,'String',0);
    set(handles.db_fcm,'String',0);
    set(handles.d_de,'String',0);
    set(handles.d_fcm,'String',0);
    set(handles.rt_de,'String',0);
    set(handles.rt_fcm,'String',0);
guidata(hObject, handles);

% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
    set(handles.btn_fcm,'Enable','off');
    set(handles.btn_valid,'Enable','off');
    set(handles.btn_center,'Enable','off');
    Cmax = str2double(get(handles.edit_cmax,'String'));
    pop_size = str2double(get(handles.edit_popmax,'String'));
    t_max = str2double(get(handles.edit_tmax,'String'));;
    cr_min = 0.5;
    cr_max = 1;
    handles.centers = ones(1,2);
    tic
    Z = initial(pop_size,Cmax);
    %======================Tahap 2: Penglompokan tiap pixel====================
    %Perulangan untuk tiap kromosom pada populasi
    for i=1:pop_size
        [handles.cluster,group,Z] = clustering(Z,1,handles.image);
        Z = cek_aktif(Z,Cmax,i);
        axes(handles.axes2);
        imshow(handles.cluster);
    end
    %=====================Tahap 3: Operasi genetik pada tiap generasi==========
    Y = Z;
    R = zeros(3,Cmax,pop_size);
    F = 0.5*(1+rand(1));
    for t=1:t_max
        %==============================Mutasi==================================
        Cr = cr_max-(cr_max-cr_min)*(t/t_max);
        r1 = ceil(pop_size.*rand(1));
        r2 = ceil(pop_size.*rand(1));
        while r2==r1
            r2 = ceil(pop_size.*rand(1));
        end
        r3 = ceil(pop_size.*rand(1));
        while r3==r2 || r3==r1
            r3 = ceil(pop_size.*rand(1));
        end
        %============================Crossover=================================
        for i=1:pop_size
            for j=1:Cmax
                Y(1,j,i) = abs(Z(1,j,r1)+F*(Z(1,j,r2)-Z(1,j,r3)));
                if rand(1)<=Cr
                    R(:,j,i) = Y(:,j,i);
                else
                    R(:,j,i) = Z(:,j,i);
                end
            end
            R = cek_aktif(R,Cmax,i);
            while length(find(R(3,:,i)))<=2
                r1 = ceil(pop_size.*rand(1));
                r2 = ceil(pop_size.*rand(1));
                while r2==r1
                    r2 = ceil(pop_size.*rand(1));
                end
                r3 = ceil(pop_size.*rand(1));
                while r3==r2 || r3==r1
                    r3 = ceil(pop_size.*rand(1));
                end
                for j=1:Cmax
                    Y(1,j,i) = abs(Z(1,j,r1)+F*(Z(1,j,r2)-Z(1,j,r3)));
                    if rand(1)<=Cr
                        R(:,j,i) = Y(:,j,i);
                    else
                        R(:,j,i) = Z(:,j,i);
                    end
                end
                R = cek_aktif(R,Cmax,i);
            end
        end
        for i=1:pop_size
            [handles.cluster,group,R] = clustering(R,1,handles.image);
            R = cek_aktif(R,Cmax,i);
        end
        for i=1:pop_size
            ps1 = fit_de(Z,handles.image,i,group);
            ps2 = fit_de(R,handles.image,i,group);
            if ps1<=ps2
                Z(:,:,i) = R(:,:,i);
            end
            axes(handles.axes2);
            imshow(handles.cluster);
        end
    end
    %==========================Tahap 3: Seleksi kromosom=======================
    ff = -1;
    best = 1;
    for i=1:pop_size
        ps = fit_de(Z,handles.image,i,group);
        if ps>=ff && length(find(Z(3,:,i)))>2
            ff = ps;
            best = i;
        end
    end
    kromosom = Z(:,:,best);
    kromosom = cek_aktif(kromosom,Cmax,1);
    [handles.cluster,group,kromosom] = clustering(kromosom,1,handles.image);
    group = double(group(:)');
    center = kromosom(2,:,1);
    center(kromosom(3,:,1)==0)=0;
    [r,c,center] = find(center);
    ps = fit(handles.image,group,center)/10;
    db = davies(handles.image,group,center)/10;
    d = dunn(handles.image,group,center);
    toc
    time = toc;
    handles.centers(1:length(center),1) = center';
    handles.valid(1,1) = ps;
    handles.valid(2,1) = db;
    handles.valid(3,1) = d;
    handles.valid(4,1) = time;
    axes(handles.axes2);
    handles.kelas = length(find(kromosom(3,:,1)));
    imshow(handles.cluster);
    set(handles.btn_fcm,'Enable','on');
guidata(hObject, handles);

% --- Executes on button press in btn_fcm.
function btn_fcm_Callback(hObject, eventdata, handles)
    tic
    ff = 1000;
    % best = 1;
    Cmax = handles.kelas;
    for n_class=2:Cmax
        [center,U,obj_fcn] = fcm(double(handles.image(:)),Cmax);
        class = max(U);
        center = center';
        [m,n] = size(U);
        clusters = zeros(m,n);
        for i=1:Cmax
            clusters(i,U(i,:) == class) = i;
        end
        group = max(clusters);
        result = uint8(((group-1)*255)/(Cmax-1));
        %[y,x] = size(handles.image);
        result = reshape(result,handles.y,handles.x);
        axes(handles.axes3);
        imshow(result);
        % colormap('gray');
        % axis(handles.axes3,'off');
        ps = fit(handles.image,group,center);
        db = davies(handles.image,group,center);
        d = dunn(handles.image,group,center);
        if abs(ps-ff)<=0.0001
            break;
        elseif ps < ff
            ff = ps;
        end
    end
    toc
    time = toc;
    handles.centers(1:length(center),2) = center';
    handles.valid(1,2) = ps;
    handles.valid(2,2) = db;
    handles.valid(3,2) = d;
    handles.valid(4,2) = time;
    set(handles.btn_valid,'Enable','on');
    set(handles.btn_center,'Enable','on');
    % if str2double(get(handles.txt_ps,'String')) <= str2double(get(handles.txt_psfcm,'String'))
    %     set(handles.txt_ps,'ForegroundColor',[0 0.5 0]);
    %     set(handles.txt_psfcm,'ForegroundColor',[0 0 0]);
    % else
    %     set(handles.txt_psfcm,'ForegroundColor',[0 0.5 0]);
    %     set(handles.txt_ps,'ForegroundColor',[0 0 0]);
    % end
    % set(handles.btn_fcm,'Enable','off');
    % set(handles.edit_cmax,'Enable','on');
    % set(handles.edit_popmax,'Enable','on');
    % set(handles.edit_tmax,'Enable','on');
guidata(hObject, handles);

% --- Executes on button press in btn_valid.
function btn_valid_Callback(hObject, eventdata, handles)
    set(handles.ps_de,'String',handles.valid(1,1));
    set(handles.ps_fcm,'String',handles.valid(1,2));
    set(handles.db_de,'String',handles.valid(2,1));
    set(handles.db_fcm,'String',handles.valid(2,2));
    set(handles.d_de,'String',handles.valid(3,1));
    set(handles.d_fcm,'String',handles.valid(3,2));
    set(handles.rt_de,'String',handles.valid(4,1));
    set(handles.rt_fcm,'String',handles.valid(4,2));

    if handles.valid(1,1) <= handles.valid(1,2)
        set(handles.ps_de,'ForegroundColor',[0 0.5 0]);
        set(handles.ps_fcm,'ForegroundColor',[0 0 0]);
    else
        set(handles.ps_fcm,'ForegroundColor',[0 0.5 0]);
        set(handles.ps_de,'ForegroundColor',[0 0 0]);
    end
    if handles.valid(2,1) <= handles.valid(2,2)
        set(handles.db_de,'ForegroundColor',[0 0.5 0]);
        set(handles.db_fcm,'ForegroundColor',[0 0 0]);
    else
        set(handles.db_fcm,'ForegroundColor',[0 0.5 0]);
        set(handles.db_de,'ForegroundColor',[0 0 0]);
    end
    if handles.valid(3,2) <= handles.valid(3,1)
        set(handles.d_de,'ForegroundColor',[0 0.5 0]);
        set(handles.d_fcm,'ForegroundColor',[0 0 0]);
    else
        set(handles.d_fcm,'ForegroundColor',[0 0.5 0]);
        set(handles.d_de,'ForegroundColor',[0 0 0]);
    end
    if handles.valid(4,1) <= handles.valid(4,2)
        set(handles.rt_de,'ForegroundColor',[0 0.5 0]);
        set(handles.rt_fcm,'ForegroundColor',[0 0 0]);
    else
        set(handles.rt_fcm,'ForegroundColor',[0 0.5 0]);
        set(handles.rt_de,'ForegroundColor',[0 0 0]);
    end

% if handles.valid(1,1) <= handles.valid(1,2)
%     set(handles.tb_valid,'ForegroundColor',[0 0 0]);
% else
%     set(handles.tb_valid,'ForegroundColor',[0 0.5 0]);
% end
% set(handles.tb_valid,'Data',handles.valid);
% hObject    handle to btn_valid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);

function btn_center_Callback(hObject, eventdata, handles)
    set(handles.tb_valid,'Data',handles.centers);
    clear handles.centers;
guidata(hObject, handles);

function edit_cmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cmax as text
%        str2double(get(hObject,'String')) returns contents of edit_cmax as a double


% --- Executes during object creation, after setting all properties.
function edit_cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_popmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_popmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_popmax as text
%        str2double(get(hObject,'String')) returns contents of edit_popmax as a double


% --- Executes during object creation, after setting all properties.
function edit_popmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_popmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tmax as text
%        str2double(get(hObject,'String')) returns contents of edit_tmax as a double


% --- Executes during object creation, after setting all properties.
function edit_tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ps as text
%        str2double(get(hObject,'String')) returns contents of edit_ps as a double


% --- Executes during object creation, after setting all properties.
function edit_ps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_psfcm_Callback(hObject, eventdata, handles)
% hObject    handle to edit_psfcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_psfcm as text
%        str2double(get(hObject,'String')) returns contents of edit_psfcm as a double


% --- Executes during object creation, after setting all properties.
function edit_psfcm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_psfcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
    slider_value = get(hObject,'Value');
    slider_value = ceil(slider_value*20)+3;
    set(handles.edit_cmax,'String',slider_value);
guidata(hObject, handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
    slider_value = get(hObject,'Value');
    slider_value = ceil(slider_value*15)+5;
    set(handles.edit_popmax,'String',slider_value);
guidata(hObject, handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
    slider_value = get(hObject,'Value');
    slider_value = ceil(slider_value*25)+5;
    set(handles.edit_tmax,'String',slider_value);
guidata(hObject, handles);


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ps_de_Callback(hObject, eventdata, handles)
% hObject    handle to ps_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ps_de as text
%        str2double(get(hObject,'String')) returns contents of ps_de as a double


% --- Executes during object creation, after setting all properties.
function ps_de_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ps_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function db_de_Callback(hObject, eventdata, handles)
% hObject    handle to db_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of db_de as text
%        str2double(get(hObject,'String')) returns contents of db_de as a double


% --- Executes during object creation, after setting all properties.
function db_de_CreateFcn(hObject, eventdata, handles)
% hObject    handle to db_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d_de_Callback(hObject, eventdata, handles)
% hObject    handle to d_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d_de as text
%        str2double(get(hObject,'String')) returns contents of d_de as a double


% --- Executes during object creation, after setting all properties.
function d_de_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ps_fcm_Callback(hObject, eventdata, handles)
% hObject    handle to ps_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ps_fcm as text
%        str2double(get(hObject,'String')) returns contents of ps_fcm as a double


% --- Executes during object creation, after setting all properties.
function ps_fcm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ps_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function db_fcm_Callback(hObject, eventdata, handles)
% hObject    handle to db_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of db_fcm as text
%        str2double(get(hObject,'String')) returns contents of db_fcm as a double


% --- Executes during object creation, after setting all properties.
function db_fcm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to db_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d_fcm_Callback(hObject, eventdata, handles)
% hObject    handle to d_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d_fcm as text
%        str2double(get(hObject,'String')) returns contents of d_fcm as a double


% --- Executes during object creation, after setting all properties.
function d_fcm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rt_de_Callback(hObject, eventdata, handles)
% hObject    handle to rt_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rt_de as text
%        str2double(get(hObject,'String')) returns contents of rt_de as a double


% --- Executes during object creation, after setting all properties.
function rt_de_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rt_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rt_fcm_Callback(hObject, eventdata, handles)
% hObject    handle to rt_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rt_fcm as text
%        str2double(get(hObject,'String')) returns contents of rt_fcm as a double


% --- Executes during object creation, after setting all properties.
function rt_fcm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rt_fcm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [file, folder]=uigetfile(...
        {'*.gif;','File Image(*.gif;)';'*.png;','File Image(*.png;)';...
         '*.bmp;','File Image(*.bmp;)';'*.tif;','File Image(*.tif;)';...
         '*.jpg;','File Image(*.jpg;)';'*.*','Semua File(*.*)'}, 'Pilih Gambar',...
         'C:\Users\hisyam_fahm\Documents\MATLAB\TAq');
    if file ~= 0
        img = [folder file];
        handles.image = imread(img);
        %Membedakan citra 2D atau 3D
        if length(size(handles.image))== 3
            handles.image = handles.image;
            handles.image = rgb2gray(handles.image);   
            %handles.image = round(handles.image*255);
        end
        %Mendapatkan image input
        [handles.y,handles.x]=size(handles.image);
        h = fspecial('gaussian');
        handles.image = uint8(imfilter(handles.image, h));  
        set(handles.fileName,'String',img);
        axes(handles.axes1);
        imshow(handles.image);
%         colormap('gray');
%         axis(handles.axes1,'off'); 
    end
    clear handles.centers;
    set(handles.btn_fcm,'Enable','off');
    set(handles.btn_valid,'Enable','off');
    set(handles.btn_center,'Enable','off');
    set(handles.ps_de,'String',0);
    set(handles.ps_fcm,'String',0);
    set(handles.db_de,'String',0);
    set(handles.db_fcm,'String',0);
    set(handles.d_de,'String',0);
    set(handles.d_fcm,'String',0);
    set(handles.rt_de,'String',0);
    set(handles.rt_fcm,'String',0);
guidata(hObject, handles);

% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(guita);


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function hlp_Callback(hObject, eventdata, handles)
% hObject    handle to hlp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hlp;

% --------------------------------------------------------------------
function param_Callback(hObject, eventdata, handles)
% hObject    handle to param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
param;


% --------------------------------------------------------------------
function cv_Callback(hObject, eventdata, handles)
% hObject    handle to cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cv;
