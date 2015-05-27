function varargout = select(varargin)
%SELECT M-file for select.fig
%      SELECT, by itself, creates a new SELECT or raises the existing
%      singleton*.
%
%      H = SELECT returns the handle to a new SELECT or the handle to
%      the existing singleton*.
%
%      SELECT('Property','Value',...) creates a new SELECT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to select_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SELECT('CALLBACK') and SELECT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SELECT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select

% Last Modified by GUIDE v2.5 27-May-2015 20:11:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_OpeningFcn, ...
                   'gui_OutputFcn',  @select_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before select is made visible.
function select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for select
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = select_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear, clc;

load higgs_data.mat;

[handles.rawlabels,handles.eventID,handles.rawcolumn_names,handles.rawdata] = ...
    dataimport( higgs_data_for_optimization , column_names);

tbl = tabulate(handles.rawlabels);

figure();
    h = pie(tbl(:,3));
    hp = findobj(h, 'Type', 'patch');
    set(hp(1), 'FaceColor', [0 0.4470 0.7410]); set(hp(2), 'FaceColor', [0.8500 0.3250 0.0980]);
    title('Class distribution of original data');
    legend('Decay','Background');
    
handles.data = handles.rawdata;
handles.labels = handles.rawlabels;
handles.column_names = handles.rawcolumn_names;

% Hold 25% of the data, selected randomly, for test phase.
cv = cvpartition(length(handles.data),'holdout',0.25);

%---Training set
handles.Xtrain = handles.data(cv.training(1),:);
handles.Ytrain = handles.labels(cv.training(1),:);

%---Test set
handles.Xtest = handles.data(cv.test(1),:);
handles.Ytest = handles.labels(cv.test(1),:);

%---Display class distribuition
disp('Training Set:')
tabulate(handles.Ytrain)
disp('Test Set:')
tabulate(handles.Ytest)

% --- Executes on button press in load_test_button.
function load_test_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_test_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file = uigetfile('.mat');
test_data = load (file);
f = fieldnames(test_data);

[testlabels,~,~,testrawdata] = dataimport(test_data.(f{2}) , test_data.(f{1}));

handles.Xtest = testrawdata;
handles.Ytest = testlabels;

% --- Executes on button press in back_button.
function back_button_Callback(hObject, eventdata, handles)
% hObject    handle to back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
% hObject    handle to clear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quit_button.
function quit_button_Callback(hObject, eventdata, handles)
% hObject    handle to quit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bayes_button.
function bayes_button_Callback(hObject, eventdata, handles)
% hObject    handle to bayes_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fld_button.
function fld_button_Callback(hObject, eventdata, handles)
% hObject    handle to fld_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in svm_button.
function svm_button_Callback(hObject, eventdata, handles)
% hObject    handle to svm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in multi_svm_button.
function multi_svm_button_Callback(hObject, eventdata, handles)
% hObject    handle to multi_svm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in knn_button.
function knn_button_Callback(hObject, eventdata, handles)
% hObject    handle to knn_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in min_dist_button.
function min_dist_button_Callback(hObject, eventdata, handles)
% hObject    handle to min_dist_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in k_means_button.
function k_means_button_Callback(hObject, eventdata, handles)
% hObject    handle to k_means_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in run_fr.
function run_fr_Callback(hObject, eventdata, handles)
% hObject    handle to run_fr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fr_input_Callback(hObject, eventdata, handles)
% hObject    handle to fr_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fr_input as text
%        str2double(get(hObject,'String')) returns contents of fr_input as a double


% --- Executes during object creation, after setting all properties.
function fr_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fr_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pca_button.
function pca_button_Callback(hObject, eventdata, handles)
% hObject    handle to pca_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lda_button.
function lda_button_Callback(hObject, eventdata, handles)
% hObject    handle to lda_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function fs_input_Callback(hObject, eventdata, handles)
% hObject    handle to fs_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs_input as text
%        str2double(get(hObject,'String')) returns contents of fs_input as a double


% --- Executes during object creation, after setting all properties.
function fs_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kw_pushbutton.
function kw_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to kw_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fc_button.
function fc_button_Callback(hObject, eventdata, handles)
% hObject    handle to fc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fl_button.
function fl_button_Callback(hObject, eventdata, handles)
% hObject    handle to fl_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mRMR_button.
function mRMR_button_Callback(hObject, eventdata, handles)
% hObject    handle to mRMR_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in auc_button.
function auc_button_Callback(hObject, eventdata, handles)
% hObject    handle to auc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fisher_score_button.
function fisher_score_button_Callback(hObject, eventdata, handles)
% hObject    handle to fisher_score_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ms_button.
function ms_button_Callback(hObject, eventdata, handles)
% hObject    handle to ms_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
method = {'mean','mode','removeevents','removefeatures'};

[ handles.MVXtrain , handles.MVYtrain , handles.MVXtest , handles.MVYtest, handles.MVcolumn_names ] ...
    = missingvalues( handles.Xtrain , handles.Ytrain , handles.Xtest ,...
    handles.Ytest , handles.column_names, method{handles.msoption} );


% --- Executes during object creation, after setting all properties.
function replace_button_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to replace_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'mean_radio'
        handles.msoption = 1;
        disp('Ola')
    case 'mode_radio'
        handles.msoption = 2;
    case 'events_radio'
        handles.msoption = 3;
    case 'features_radio'
        handles.msoption = 4;
end


% --- Executes on button press in mean_radio.
function mean_radio_Callback(hObject, eventdata, handles)
% hObject    handle to mean_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mean_radio


% --- Executes during object creation, after setting all properties.
function replace_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to replace_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
