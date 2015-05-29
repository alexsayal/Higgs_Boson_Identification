function varargout = GUI_Main(varargin)
%GUI_MAIN M-file for GUI_Main.fig
%      GUI_MAIN, by itself, creates a new GUI_MAIN or raises the existing
%      singleton*.
%
%      H = GUI_MAIN returns the handle to a new GUI_MAIN or the handle to
%      the existing singleton*.
%
%      GUI_MAIN('Property','Value',...) creates a new GUI_MAIN using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_Main_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_MAIN('CALLBACK') and GUI_MAIN('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_MAIN.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Main

% Last Modified by GUIDE v2.5 29-May-2015 15:31:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Main_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Main_OutputFcn, ...
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


% --- Executes just before GUI_Main is made visible.
function GUI_Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

movegui(gcf,'center')

% Choose default command line output for GUI_Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Main_OutputFcn(hObject, eventdata, handles)
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

%clear, clc;

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

set(handles.text_left, 'String', sprintf('Load Successful\nCross-Validation by Hold-Out at 75/25%'));
guidata(hObject, handles);

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

set(handles.text_left, 'String', sprintf('Load Test Successful\nTest Set Replaced'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function mv_button_group_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mv_button_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.mvoption = 1;
guidata(hObject,handles);

% --- Executes on button press in mv_button.
function mv_button_Callback(hObject, eventdata, handles)
% hObject    handle to mv_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
method = {'mean','mode','removeevents','removefeatures'};

[ handles.MVXtrain , handles.YTrain_touse , handles.MVXtest , handles.YTest_touse, handles.column_names_norm , print ] ...
    = missingvalues( handles.Xtrain , handles.Ytrain , handles.Xtest ,...
    handles.Ytest , handles.column_names, method{handles.mvoption} );

handles.dim = size(handles.MVXtrain,2);

set(handles.text_left, 'String', print);
guidata(hObject, handles);

% --- Executes when selected object is changed in mv_button_group.
function mv_button_group_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in mv_button_group 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'mean_radio'
        handles.mvoption = 1;
    case 'mode_radio'
        handles.mvoption = 2;
    case 'events_radio'
        handles.mvoption = 3;
    case 'features_radio'
        handles.mvoption = 4;
end
guidata(hObject, handles);

% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_left,'String','');
set(handles.text_right,'String','');
set(handles.fs_input,'String','');
set(handles.cmin_input,'String','');
set(handles.cmax_input,'String','');
set(handles.cstep_input,'String','');
set(handles.gmin_input,'String','');
set(handles.gmax_input,'String','');
set(handles.gstep_input,'String','');
set(handles.kmin_input,'String','');
set(handles.kmax_input,'String','');
set(handles.limit_input,'String','1000');
set(handles.nfold_input,'String','10');
clear all;


% --- Executes on button press in quit_button.
function quit_button_Callback(hObject, eventdata, handles)
% hObject    handle to quit_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close all;

% --- Executes on button press in class_button.
function class_button_Callback(hObject, eventdata, handles)
% hObject    handle to class_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.text_right,'String',' ');
class = {'bayes','fld','linsvm','libsvm','kNN','mindist','kmeans'};
selected = class{handles.class_option};

switch selected
    case 'bayes'
        %%---Bayes Classifier
        nfold = str2double(get(handles.nfold_input,'String')); 
        type = handles.bayes_option;
        [ handles.CL_bayes_performance , handles.CL_bayes_model , print] = ...
            CL_bayes( handles.XTrain_touse , handles.YTrain_touse , handles.XTest_touse , handles.YTest_touse , type , nfold);
        set(handles.text_right,'String',print);
        
    case 'fld'
        %%---FLD Classifier
        nfold = str2double(get(handles.nfold_input,'String'));
        type = handles.fld_option;
        [ handles.CL_fld_performance , handles.CL_fld_model , print] = ...
            CL_fld( handles.XTrain_touse , handles.YTrain_touse , handles.XTest_touse , handles.YTest_touse , type , nfold);
        set(handles.text_right,'String',print);

    case 'linsvm'
        %%---SVM with LibLINEAR
        nfold = str2num(get(handles.nfold_input,'String'));
        Cmin = str2num(get(handles.cmin_input,'String'));
        Cmax = str2num(get(handles.cmax_input,'String'));
        Cstep = str2num(get(handles.cstep_input,'String'));
        C = Cmin:Cstep:Cmax;
        [ handles.CL_linsvm_performance , handles.CL_linsvm_model , print] = ...
            CL_linSVM( handles.XTrain_touse , handles.YTrain_touse , handles.XTest_touse , handles.YTest_touse, C , nfold);
        set(handles.text_right,'String',print);
     
    case 'libsvm'
        %%---SVM with LibSVM
        nfold = str2num(get(handles.nfold_input,'String'));
        Cmin = str2num(get(handles.cmin_input,'String'));
        Cmax = str2num(get(handles.cmax_input,'String'));
        Cstep = str2num(get(handles.cstep_input,'String'));
        C = Cmin:Cstep:Cmax;
        gmin = str2num(get(handles.gmin_input,'String'));
        gmax = str2num(get(handles.gmax_input,'String'));
        gstep = str2num(get(handles.gstep_input,'String'));
        gamma = gmin:gstep:gmax;
        limit = str2num(get(handles.limit_input, 'String')); % Limit the number of events
        [ handles.CL_libsvm_performance , handles.CL_libsvm_model , print] = ...
            CL_libSVM( handles.XTrain_touse , handles.YTrain_touse , handles.XTest_touse , handles.YTest_touse, C , gamma , nfold, limit);
        set(handles.text_right,'String',print);
        
    case 'kNN'
        %%---kNN
        nfold = str2num(get(handles.nfold_input,'String'));
        Kmin = str2num(get(handles.kmin_input,'String'));
        Kmax = str2num(get(handles.kmax_input,'String'));
        K = Kmin:Kmax;
        limit = str2num(get(handles.limit_input, 'String')); % Limit the number of events
        [ handles.CL_kNN_performance , handles.CL_kNN_model , print ] = ...
            CL_kNN(handles.XTrain_touse , handles.YTrain_touse , handles.XTest_touse , handles.YTest_touse , K , nfold, limit);
        set(handles.text_right,'String',print);
        
    case 'kmeans'
        %%---K-means
        nfold = str2num(get(handles.nfold_input,'String'));
        [ handles.C_kmean_performance , handles.C_kmeans_model , print] = ...
            C_kmeans( handles.XTrain_touse , handles.YTrain_touse , nfold );
       set(handles.text_right,'String',print);
       
    case 'mindist'
        %%---Minimum Distance
        [ handles.CL_mindist_performance , handles.CL_mindist_m1 , handles.CL_mindist_m2 , print] = ...
            CL_mindist( handles.XTrain_touse , handles.YTrain_touse , handles.XTest_touse , handles.YTest_touse );
        set(handles.text_right,'String',print);
        
end
guidata(hObject, handles);

function nfold_input_Callback(hObject, eventdata, handles)
% hObject    handle to nfold_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfold_input as text
%        str2double(get(hObject,'String')) returns contents of nfold_input as a double


% --- Executes during object creation, after setting all properties.
function nfold_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfold_input (see GCBO)
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

handles.class_option = 1;
set(handles.text_right,'String',sprintf('Bayesian Classifier Selected.\nPlease Choose Type (default or reject option).'));
guidata(hObject,handles);

% --- Executes on button press in fld_button.
function fld_button_Callback(hObject, eventdata, handles)
% hObject    handle to fld_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.class_option = 2;
set(handles.text_right,'String',sprintf('Fisher Linear Discriminant Classifier Selected.\nPlease Choose Type (linear or quadratic).'));
guidata(hObject,handles);

% --- Executes on button press in svm_button.
function svm_button_Callback(hObject, eventdata, handles)
% hObject    handle to svm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.class_option = 3;
set(handles.text_right,'String',sprintf('LibLinear SVM Classifier Selected.\nPlease Set C Values.'));
guidata(hObject,handles);

% --- Executes on button press in libsvm_button.
function libsvm_button_Callback(hObject, eventdata, handles)
% hObject    handle to libsvm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.class_option = 4;
set(handles.text_right,'String',sprintf('LibSVM Classifier Selected.\nPlease Set C and Gamma Values\nMind the event number limit (default is 1000).'));
guidata(hObject,handles);

% --- Executes on button press in knn_button.
function knn_button_Callback(hObject, eventdata, handles)
% hObject    handle to knn_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.class_option = 5;
set(handles.text_right,'String',sprintf('k-NN Classifier Selected.\nPlease Set K Values\nMind the event number limit (default is 1000).'));
guidata(hObject,handles);

% --- Executes on button press in min_dist_button.
function min_dist_button_Callback(hObject, eventdata, handles)
% hObject    handle to min_dist_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.class_option = 6;
set(handles.text_right,'String',sprintf('Minimum Distance Classifier Selected.\nEuclidian distance.'));
guidata(hObject,handles);

% --- Executes on button press in k_means_button.
function k_means_button_Callback(hObject, eventdata, handles)
% hObject    handle to k_means_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.class_option = 7;
set(handles.text_right,'String',sprintf('k-Means Classifier Selected.'));
guidata(hObject,handles);

% --- Executes on button press in fr_button.
function fr_button_Callback(hObject, eventdata, handles)
% hObject    handle to fr_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%----Create Structure----%
FRdataTemp.X = handles.XTrain_touse';
FRdataTemp.y = handles.YTrain_touse';
FRdataTemp.dim = size(FRdataTemp.X,1);
FRdataTemp.num_data = size(FRdataTemp.X,2);

option = handles.fr_option;

switch option
%----PCA----%
    case 1
        threshold = get(handles.fr_input,'String'); %---Percentage of Eigenvalues to keep
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif str2num(threshold)<=0 || str2num(threshold)>1
            warndlg('Input must be a value between 0 and 1');
        else
            [ handles.XTrain_touse , W ] = FeatureReduction( FRdataTemp , 'pca' , str2num(threshold));
            handles.XTest_touse = handles.XTest_touse*W;
            set(handles.text_left, 'String', sprintf('PCA executed.\n%d Principal Components.',size(W,2)));
        end
%----LDA----%        
    case 2
        threshold = get(handles.fr_input,'String'); %---Number of features desired
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif mod(str2num(threshold),1)~=0
            warndlg('Input must be integer');
        elseif str2num(threshold)<=0
            warndlg('Input must be positive');
        elseif str2num(threshold)>handles.dim
            warndlg(strcat('Input must be <= ',{' '},num2str(handles.dim))); 
        else
            [ handles.XTrain_touse , W ] = FeatureReduction( FRdataTemp , 'lda' , str2num(threshold));
            handles.XTest_touse = handles.XTest_touse*W;
            set(handles.text_left, 'String', 'LDA executed');
        end
end

handles.XTest_touse = handles.XTest_touse';
handles.fr_run = 'true';

guidata(hObject,handles);


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

set(handles.fr_input,'Visible','on');
handles.fr_option = 1;
set(handles.fr_text,'String','EIGENVALUE PERCENTAGE:','Visible','On');
guidata(hObject,handles);

% --- Executes on button press in lda_button.
function lda_button_Callback(hObject, eventdata, handles)
% hObject    handle to lda_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fr_input,'Visible','on');
handles.fr_option = 2;
set(handles.fr_text,'String','NUMBER OF COMPONENTS:','Visible','On');
guidata(hObject,handles);


% --- Executes on button press in fs_button.
function fs_button_Callback(hObject, eventdata, handles)
% hObject    handle to fs_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(handles.fr_run,'true')
    handles.XTrain_touse = handles.XTrain_norm;
    handles.XTest_touse = handles.XTest_norm;
    handles.fr_run = 'false';
end

switch handles.fs_option
%----Kruskal-Wallis----%
    case 1
        threshold = get(handles.fs_input,'String'); %---Number of features desired based on chi2 values
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif mod(str2num(threshold),1)~=0
            warndlg('Input must be integer');
        elseif str2num(threshold)<=0
            warndlg('Input must be positive');
        elseif str2num(threshold)>handles.dim
            warndlg(strcat('Input must be <= ',{' '},num2str(handles.dim))); 
        else
            [handles.XTrain_touse , handles.column_names , FSfeatures,print] = FS_kruskal( handles.XTrain_touse , handles.YTrain_touse , handles.column_names , str2num(threshold) );
            handles.XTest_touse = handles.XTest_touse(:,FSfeatures);
            set(handles.text_left,'String',print);
        end
        
%----Correlation between features----%   
    case 2
        threshold = get(handles.fs_input,'String'); %---Correlation cut-off value
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif str2num(threshold)<=0 || str2num(threshold)>1
            warndlg('Input must be a value between 0 and 1');
        else
            [handles.XTrain_touse , handles.column_names , FSfeatures, print] = FS_corr( handles.XTrain_touse , handles.YTrain_touse , handles.column_names , 'feat' ,str2num(threshold));
            handles.XTest_touse = handles.XTest_touse(:,FSfeatures);
            set(handles.text_left,'String',print);
        end
%----Correlation between features and labels----% 
    case 3
        threshold = get(handles.fs_input,'String'); %---Correlation cut-off value
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif str2num(threshold)<=0 || str2num(threshold)>1
            warndlg('Input must be a value between 0 and 1');
        else
            [handles.XTrain_touse , handles.column_names , FSfeatures, print] = FS_corr( handles.XTrain_touse , handles.YTrain_touse , handles.column_names , 'featlabel' , str2num(threshold));
            handles.XTest_touse = handles.XTest_touse(:,FSfeatures);
            set(handles.text_left,'String',print);
        end
%----mRMR----% 
    case 4
        threshold = get(handles.fs_input,'String'); %---Number of features desired
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif mod(str2num(threshold),1)~=0
            warndlg('Input must be integer');
        elseif str2num(threshold)<=0
            warndlg('Input must be positive');
        elseif str2num(threshold)>handles.dim
            warndlg(strcat('Input must be <= ',{' '},num2str(handles.dim))); 
        else
            [handles.XTrain_touse , handles.column_names , FSfeatures, print] = FS_mRMR( handles.XTrain_touse , handles.YTrain_touse , handles.column_names , str2num(threshold));
            handles.XTest_touse = handles.XTest_touse(:,FSfeatures);
            set(handles.text_left,'String',print);
        end
        
%----Area under curve----% 
    case 5
        threshold = get(handles.fs_input,'String'); %---AUC cut-off value
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif str2num(threshold)<=0 || str2num(threshold)>1
            warndlg('Input must be a value between 0 and 1');
        else
            [handles.XTrain_touse , handles.column_names , FSfeatures,print] = FS_AUC( handles.XTrain_touse , handles.YTrain_touse , handles.column_names , str2num(threshold));
            handles.XTest_touse = handles.XTest_touse(:,FSfeatures);
            set(handles.text_left,'String',print);
        end
%----Fisher Score----% 
    case 6
        threshold = get(handles.fs_input,'String'); %---Number of features desired
        if isempty(str2num(threshold))
            warndlg('Input must be numerical');
        elseif mod(str2num(threshold),1)~=0
            warndlg('Input must be integer');
        elseif str2num(threshold)<=0
            warndlg('Input must be positive');
        elseif str2num(threshold)>handles.dim
            warndlg(strcat('Input must be <= ',{' '},num2str(handles.dim))); 
        else
            [handles.XTrain_touse , handles.column_names , FSfeatures,print] = FS_fisher(handles.XTrain_touse , handles.YTrain_touse , handles.column_names, str2num(threshold)); 
            handles.XTest_touse = handles.XTest_touse(:,FSfeatures); 
            set(handles.text_left,'String',print);
        end
end
guidata(hObject,handles);


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

set(handles.fs_input,'Visible','on');
handles.fs_option = 1;
set(handles.fs_text,'String','NUMBER OF FEATURES:','Visible','On');
guidata(hObject,handles);


% --- Executes on button press in fc_button.
function fc_button_Callback(hObject, eventdata, handles)
% hObject    handle to fc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fs_input,'Visible','on');
handles.fs_option = 2;
set(handles.fs_text,'String','CUT-OFF VALUE:','Visible','On');
guidata(hObject,handles);


% --- Executes on button press in fl_button.
function fl_button_Callback(hObject, eventdata, handles)
% hObject    handle to fl_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fs_input,'Visible','on');
handles.fs_option = 3;
set(handles.fs_text,'String','CUT-OFF VALUE:','Visible','On');
guidata(hObject,handles);

% --- Executes on button press in mRMR_button.
function mRMR_button_Callback(hObject, eventdata, handles)
% hObject    handle to mRMR_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fs_input,'Visible','on');
handles.fs_option = 4;
set(handles.fs_text,'String','NUMBER OF FEATURES:','Visible','On');
guidata(hObject,handles);

% --- Executes on button press in auc_button.
function auc_button_Callback(hObject, eventdata, handles)
% hObject    handle to auc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fs_input,'Visible','on');
handles.fs_option = 5;
set(handles.fs_text,'String','CUT-OFF VALUE:','Visible','On');
guidata(hObject,handles);

% --- Executes on button press in fisher_score_button.
function fisher_score_button_Callback(hObject, eventdata, handles)
% hObject    handle to fisher_score_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fs_input,'Visible','on');
handles.fs_option = 6;
set(handles.fs_text,'String','NUMBER OF FEATURES:','Visible','On');
guidata(hObject,handles);

% --- Executes on button press in norm_button.
function norm_button_Callback(hObject, eventdata, handles)
% hObject    handle to norm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.XTrain_touse , m , sigma , print] = scalestd(handles.MVXtrain);
handles.XTest_touse = scalestd(handles.MVXtest,m,sigma);

handles.XTrain_norm = handles.XTrain_touse;
handles.XTest_norm = handles.XTest_touse;
handles.column_names_norm = handles.column_names;

handles.column_names = handles.column_names_norm;

handles.fr_run = 'false';

set(handles.text_left, 'String', print);
guidata(hObject,handles);

% --- Executes on button press in mean_radio.
function mean_radio_Callback(hObject, eventdata, handles)
% hObject    handle to mean_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mean_radio


% --- Executes on button press in mode_radio.
function mode_radio_Callback(hObject, eventdata, handles)
% hObject    handle to mode_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mode_radio


% --- Executes on button press in events_radio.
function events_radio_Callback(hObject, eventdata, handles)
% hObject    handle to events_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of events_radio


% --- Executes on button press in features_radio.
function features_radio_Callback(hObject, eventdata, handles)
% hObject    handle to features_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of features_radio


% --- Executes during object creation, after setting all properties.
function mean_radio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mean_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function limit_input_Callback(hObject, eventdata, handles)
% hObject    handle to limit_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of limit_input as text
%        str2double(get(hObject,'String')) returns contents of limit_input as a double


% --- Executes during object creation, after setting all properties.
function limit_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limit_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fld_popup_input.
function fld_popup_input_Callback(hObject, eventdata, handles)
% hObject    handle to fld_popup_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fld_popup_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fld_popup_input


% --- Executes during object creation, after setting all properties.
function fld_popup_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fld_popup_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cmin_input_Callback(hObject, eventdata, handles)
% hObject    handle to cmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmin_input as text
%        str2double(get(hObject,'String')) returns contents of cmin_input as a double


% --- Executes during object creation, after setting all properties.
function cmin_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cmax_input_Callback(hObject, eventdata, handles)
% hObject    handle to cmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmax_input as text
%        str2double(get(hObject,'String')) returns contents of cmax_input as a double


% --- Executes during object creation, after setting all properties.
function cmax_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cstep_input_Callback(hObject, eventdata, handles)
% hObject    handle to cstep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cstep_input as text
%        str2double(get(hObject,'String')) returns contents of cstep_input as a double


% --- Executes during object creation, after setting all properties.
function cstep_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cstep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gmin_input_Callback(hObject, eventdata, handles)
% hObject    handle to gmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gmin_input as text
%        str2double(get(hObject,'String')) returns contents of gmin_input as a double


% --- Executes during object creation, after setting all properties.
function gmin_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gmax_input_Callback(hObject, eventdata, handles)
% hObject    handle to gmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gmax_input as text
%        str2double(get(hObject,'String')) returns contents of gmax_input as a double


% --- Executes during object creation, after setting all properties.
function gmax_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gstep_input_Callback(hObject, eventdata, handles)
% hObject    handle to gstep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gstep_input as text
%        str2double(get(hObject,'String')) returns contents of gstep_input as a double


% --- Executes during object creation, after setting all properties.
function gstep_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gstep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in bayes_popup_input.
function bayes_popup_input_Callback(hObject, eventdata, handles)
% hObject    handle to bayes_popup_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bayes_popup_input contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bayes_popup_input


% --- Executes during object creation, after setting all properties.
function bayes_popup_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bayes_popup_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16


% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15


% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12


% --- Executes on button press in df_bayes_radio.
function df_bayes_radio_Callback(hObject, eventdata, handles)
% hObject    handle to df_bayes_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of df_bayes_radio


% --- Executes when selected object is changed in bayes_panel.
function bayes_panel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in bayes_panel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'df_bayes_radio'
        handles.bayes_option = 'df';
    case 'cls_bayes_radio'
        handles.bayes_option = 'cls';
end
guidata(hObject, handles);

% --- Executes when selected object is changed in fld_panel.
function fld_panel_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in fld_panel 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'linear_fld_radio'
        handles.fld_option = 'linear';
    case 'quad_fld_radio' 
        handles.fld_option = 'quad';
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bayes_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bayes_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.bayes_option = 'df';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fld_panel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fld_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.fld_option = 'linear';
guidata(hObject, handles);



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kmax_input_Callback(hObject, eventdata, handles)
% hObject    handle to kmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kmax_input as text
%        str2double(get(hObject,'String')) returns contents of kmax_input as a double


% --- Executes during object creation, after setting all properties.
function kmax_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kmin_input_Callback(hObject, eventdata, handles)
% hObject    handle to kmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kmin_input as text
%        str2double(get(hObject,'String')) returns contents of kmin_input as a double


% --- Executes during object creation, after setting all properties.
function kmin_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to kmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kmin_input as text
%        str2double(get(hObject,'String')) returns contents of kmin_input as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to kmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kmax_input as text
%        str2double(get(hObject,'String')) returns contents of kmax_input as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to cmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmin_input as text
%        str2double(get(hObject,'String')) returns contents of cmin_input as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to cmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmax_input as text
%        str2double(get(hObject,'String')) returns contents of cmax_input as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to cstep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cstep_input as text
%        str2double(get(hObject,'String')) returns contents of cstep_input as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cstep_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in help_button.
function help_button_Callback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUI_Help;
