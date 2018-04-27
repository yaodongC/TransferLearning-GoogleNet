%% GUI for image classification demo
%% yaodong cui
function varargout = ImageClassification(varargin)
% IMAGECLASSIFICATION MATLAB code for ImageClassification.fig
%      IMAGECLASSIFICATION, by itself, creates a new IMAGECLASSIFICATION or raises the existing
%      singleton*.
%
%      H = IMAGECLASSIFICATION returns the handle to a new IMAGECLASSIFICATION or the handle to
%      the existing singleton*.
%
%      IMAGECLASSIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGECLASSIFICATION.M with the given input arguments.
%
%      IMAGECLASSIFICATION('Property','Value',...) creates a new IMAGECLASSIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageClassification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageClassification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageClassification

% Last Modified by GUIDE v2.5 14-Dec-2017 09:18:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageClassification_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageClassification_OutputFcn, ...
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


% --- Executes just before ImageClassification is made visible.
function ImageClassification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageClassification (see VARARGIN)
global net;
global Factor;
global netTransfer
PreNet = fullfile('models', 'googLeNet003.mat');  %load pretrained CNN
load(PreNet);
PreFac = fullfile('models', 'Tiny.mat');  %load pretrained classifier
load(PreFac);
PreNet = fullfile('models', 'AlexNet002.mat');  %load pretrained CNN
load(PreNet);
%PreBag = fullfile('models', 'BOW.mat');  
%load(PreBag);
%PreCet = fullfile('models', 'Center.mat');  
%load(PreCet);
% run('vlfeat/toolbox/vl_setup');

% Choose default command line output for ImageClassification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageClassification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageClassification_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image1;
global net;
global netTransfer
global Factor;
global classifer;
global Cent;

 a=get(handles.listbox1,'Value') % get listbox value
  if (a==1) % if it is tiny image classifier
     predict=TinyPredict(Factor,image1);% label image 
     set(handles.text2,'String',predict);% show label in GUI 
  elseif (a==2) % if it is BOW classifier
     predict=BOWP(Cent,classifer,image1);% label image 
     set(handles.text2,'String',predict);% show label in GUI 
  elseif (a==3) % if it is CNN Alex classifier
     predict=AlexPredict(netTransfer,image1);% label image 
     set(handles.text2,'String',predict);% show label in GUI 
  elseif (a==4) % if it is CNN googlenet classifier
     predict=GoogLePredict(net,image1);% label image 
     set(handles.text2,'String',predict);% show label in GUI 
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image1;
global imagePath;
[filename,pathname]=uigetfile({'*.*';'*.bmp';'*.jpg';'*.tif';'*.jpg'},'Choose Your Image');% choose file and get file path
if isequal(filename,0)||isequal(pathname,0)      % if no choose, give a warning
  errordlg('You Must Choose A Image','WARNING'); 
  return;
else
    imagePath=[pathname,filename]; %image filepath
    image1=imread(imagePath); %read image
    set(handles.axes1,'HandleVisibility','ON');
    axes(handles.axes1);
    imshow(image1); %show image
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
