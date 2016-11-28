function varargout = HLNFit(varargin)
% HLNFIT MATLAB code for HLNFit.fig
%      HLNFIT, by itself, creates a new HLNFIT or raises the existing
%      singleton*.
%
%      H = HLNFIT returns the handle to a new HLNFIT or the handle to
%      the existing singleton*.
%
%      HLNFIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HLNFIT.M with the given input arguments.
%
%      HLNFIT('Property','Value',...) creates a new HLNFIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HLNFit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HLNFit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HLNFit

% Last Modified by GUIDE v2.5 17-Feb-2016 14:19:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HLNFit_OpeningFcn, ...
                   'gui_OutputFcn',  @HLNFit_OutputFcn, ...
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


% --- Executes just before HLNFit is made visible.
function HLNFit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HLNFit (see VARARGIN)

% Choose default command line output for HLNFit
handles.output = hObject;

% format for converting data from strings
handles.formatSpec = '%10.3f';
% number of data points for analytical fits
handles.numOfPoints = 1000;

%%%%%%%%%%%%%% INITIALIZING ALL FIELDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
B = 0.5;
set(handles.teBmaxLeft, 'String', num2str(B, handles.formatSpec));
set(handles.teBmaxRight, 'String', num2str(B, handles.formatSpec));

A = 0.3;
set(handles.teAlphaLeft, 'String', num2str(A, handles.formatSpec));
set(handles.teAlphaRight, 'String', num2str(A, handles.formatSpec));

B = 0.2;
valueLphi = lPhiFromBphi(B);
set(handles.teBphiLeft, 'String', num2str(B, handles.formatSpec));
set(handles.teLphiLeft,'String', num2str(valueLphi, handles.formatSpec));
set(handles.teBphiRight, 'String', num2str(B, handles.formatSpec));
set(handles.teLphiRight,'String', num2str(valueLphi, handles.formatSpec));

B = 0.1;
set(handles.teB1Left, 'String', num2str(B, handles.formatSpec));
set(handles.teB1Right, 'String', num2str(B, handles.formatSpec));
set(handles.teB2Left, 'String', num2str(B, handles.formatSpec));
set(handles.teB2Right, 'String', num2str(B, handles.formatSpec));
set(handles.teB3Left, 'String', num2str(B, handles.formatSpec));
set(handles.teB3Right, 'String', num2str(B, handles.formatSpec));
set(handles.teB4Left, 'String', num2str(B, handles.formatSpec));
set(handles.teB4Right, 'String', num2str(B, handles.formatSpec));

% Setting up a status line
set(handles.tlStatus, 'String', 'Ready');

% initializing default values for the Experimental Data
handles.bFieldData = ones(1, handles.numOfPoints/10);
handles.tData = ones(1, handles.numOfPoints/10);
handles.rData = ones(1, handles.numOfPoints/10);
handles.rHallData = ones(1, handles.numOfPoints/10); 
handles.angleData = ones(1, handles.numOfPoints/10);
handles.DGData = ones(1, handles.numOfPoints/10);

handles.negativeB = ones(1, handles.numOfPoints/10);
handles.negativeDG = ones(1, handles.numOfPoints/10);
handles.positiveB = ones(1, handles.numOfPoints/10);
handles.positiveDG = ones(1, handles.numOfPoints/10);

handles.Bmax = 0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HLNFit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HLNFit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnLoadData.
% The raw data is loaded and "adjusted" to remove some
% possible artefacts. Then the positive and negative B-fields
% parts are separated and fitted separately. Finally, the 
% fit results are plotted.
function btnLoadData_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Loading raw data from file. The files may contain measurements at 
% several temeperatures and/or angles of the rotator
[handles.bFieldData, handles.tData, ...
    handles.rData, handles.rHallData, handles.angleData] = loadData(handles);

% The smallest angle of the rotator is used for analysis
[handles.bFieldData, handles.tData, ...
    handles.rData, handles.rHallData, angle] = selectLowAngle(handles);
% setting the value of the smallest angle in the GUI
set(handles.tlRotatorAngleValue, 'String', num2str(angle, handles.formatSpec));

% The lowest temperature is used for analysis
[handles.bFieldData, temperature,...
    handles.rData, handles.rHallData] = selectLowTemperature(handles);
% setting the value of the lowest temperature in the GUI
set(handles.tlTemperatureValue, 'String', num2str(temperature, handles.formatSpec));
%-----------------------------------------------------------------------------------

%select low-field data for negative and positive field sweeps
% Processing positive data first
handles.Bmax = str2double(get(handles.teBmaxRight,'String'));
[lowFieldDataB, lowFieldDataDGxx, lowFieldDataDGxy] = getLowFieldData(handles);
[handles.positiveB, handles.positiveDG] = getPositiveData(lowFieldDataB, lowFieldDataDGxx);
% Performing fitting. Positive field first
fitSimpleHLN(handles, 'positive');

% Now fit the negative part
handles.Bmax = str2double(get(handles.teBmaxLeft,'String'));
[lowFieldDataB, lowFieldDataDGxx, lowFieldDataDGxy ] = getLowFieldData(handles);
[handles.negativeB, handles.negativeDG] = getNegativeData(lowFieldDataB, lowFieldDataDGxx);
% Fitting negative field part.
fitSimpleHLN(handles, 'negative');

% plotting the results
clearAxes(handles);
plotHLNTruncated(handles);
plotExperimental(handles);

% !!! Update handles structure !!!
guidata(hObject, handles);

function teAlphaLeft_Callback(hObject, eventdata, handles)
% hObject    handle to teAlphaLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teAlphaLeft as text
%        str2double(get(hObject,'String')) returns contents of teAlphaLeft as a double


% --- Executes during object creation, after setting all properties.
function teAlphaLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teAlphaLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teBphiLeft_Callback(hObject, eventdata, handles)
% hObject    handle to teBphiLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teBphiLeft as text
%        str2double(get(hObject,'String')) returns contents of teBphiLeft as a double
valueBphi = str2double(get(hObject,'String'));
valueLphi = lPhiFromBphi(valueBphi);
set(handles.teLphiLeft,'String', num2str(valueLphi, handles.formatSpec));





% --- Executes during object creation, after setting all properties.
function teBphiLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teBphiLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teLphiLeft_Callback(hObject, eventdata, handles)
% hObject    handle to teLphiLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teLphiLeft as text
%        str2double(get(hObject,'String')) returns contents of teLphiLeft as a double
valueLphi = str2double(get(hObject,'String'));
valueBphi = bPhiFromLphi(valueLphi);
set(handles.teBphiLeft,'String', num2str(valueBphi, handles.formatSpec));

% --- Executes during object creation, after setting all properties.
function teLphiLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teLphiLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB1Left_Callback(hObject, eventdata, handles)
% hObject    handle to teB1Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB1Left as text
%        str2double(get(hObject,'String')) returns contents of teB1Left as a double


% --- Executes during object creation, after setting all properties.
function teB1Left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB1Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB2Left_Callback(hObject, eventdata, handles)
% hObject    handle to teB2Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB2Left as text
%        str2double(get(hObject,'String')) returns contents of teB2Left as a double


% --- Executes during object creation, after setting all properties.
function teB2Left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB2Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB3Left_Callback(hObject, eventdata, handles)
% hObject    handle to teB3Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB3Left as text
%        str2double(get(hObject,'String')) returns contents of teB3Left as a double


% --- Executes during object creation, after setting all properties.
function teB3Left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB3Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB4Left_Callback(hObject, eventdata, handles)
% hObject    handle to teB4Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB4Left as text
%        str2double(get(hObject,'String')) returns contents of teB4Left as a double


% --- Executes during object creation, after setting all properties.
function teB4Left_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB4Left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teBmaxLeft_Callback(hObject, eventdata, handles)
% hObject    handle to teBmaxLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teBmaxLeft as text
%        str2double(get(hObject,'String')) returns contents of teBmaxLeft as a double


% --- Executes during object creation, after setting all properties.
function teBmaxLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teBmaxLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnReplot.
function btnReplot_Callback(hObject, eventdata, handles)
% hObject    handle to btnReplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% first clear all axes
clearAxes(handles);

% then plotting stuff again
% Analytical Curves: 1. Full HLN expression
plotHLNFull(handles);
% Analytical Curves: 2. Truncated HLN expression
plotHLNTruncated(handles);

% --- Executes on button press in btnFitFull.
function btnFitFull_Callback(hObject, eventdata, handles)
% hObject    handle to btnFitFull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
%Perform fit with a full expression in Hikami-Larkin-Nagaoka model
% Fitting Negative Field Data
B1 = str2double(get(handles.teB1Left,'String'));
B2 = str2double(get(handles.teB2Left,'String'));
B3 = str2double(get(handles.teB3Left,'String'));
B4 = str2double(get(handles.teB4Left,'String'));
x = handles.negativeB;
y = handles.negativeDG;
F = @(params, xdata) HLNFull(params(1), params(2), params(3), xdata);
[x,~,~,~,~] = lsqcurvefit(F, [B1 B2 B3], x, y);
B1 = x(1);
B2 = x(2);
B3 = x(3);
B4 = B3*(B1/B2)^2;
set(handles.teB1Left, 'String', num2str(B1, handles.formatSpec));
set(handles.teB2Left, 'String', num2str(B2, handles.formatSpec));
set(handles.teB3Left, 'String', num2str(B3, handles.formatSpec));
set(handles.teB4Left, 'String', num2str(B4, handles.formatSpec));
plotHLNFull(handles);
%[B1, B2, B3, B4] = fitFullHLN([B1 B2 B3 B4], x, y);


function teAlphaRight_Callback(hObject, eventdata, handles)
% hObject    handle to teAlphaRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teAlphaRight as text
%        str2double(get(hObject,'String')) returns contents of teAlphaRight as a double


% --- Executes during object creation, after setting all properties.
function teAlphaRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teAlphaRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teBphiRight_Callback(hObject, eventdata, handles)
% hObject    handle to teBphiRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teBphiRight as text
%        str2double(get(hObject,'String')) returns contents of teBphiRight as a double
valueBphi = str2double(get(hObject,'String'));
valueLphi = lPhiFromBphi(valueBphi);
set(handles.teLphiRight,'String', num2str(valueLphi, handles.formatSpec));

% --- Executes during object creation, after setting all properties.
function teBphiRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teBphiRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teLphiRight_Callback(hObject, eventdata, handles)
% hObject    handle to teLphiRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teLphiRight as text
%        str2double(get(hObject,'String')) returns contents of teLphiRight as a double
valueLphi = str2double(get(hObject,'String'));
valueBphi = bPhiFromLphi(valueLphi);
set(handles.teBphiRight,'String', num2str(valueBphi, handles.formatSpec));

% --- Executes during object creation, after setting all properties.
function teLphiRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teLphiRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teBmaxRight_Callback(hObject, eventdata, handles)
% hObject    handle to teBmaxRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teBmaxRight as text
%        str2double(get(hObject,'String')) returns contents of teBmaxRight as a double


% --- Executes during object creation, after setting all properties.
function teBmaxRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teBmaxRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB1Right_Callback(hObject, eventdata, handles)
% hObject    handle to teB1Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB1Right as text
%        str2double(get(hObject,'String')) returns contents of teB1Right as a double


% --- Executes during object creation, after setting all properties.
function teB1Right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB1Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB2Right_Callback(hObject, eventdata, handles)
% hObject    handle to teB2Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB2Right as text
%        str2double(get(hObject,'String')) returns contents of teB2Right as a double


% --- Executes during object creation, after setting all properties.
function teB2Right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB2Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB3Right_Callback(hObject, eventdata, handles)
% hObject    handle to teB3Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB3Right as text
%        str2double(get(hObject,'String')) returns contents of teB3Right as a double


% --- Executes during object creation, after setting all properties.
function teB3Right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB3Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function teB4Right_Callback(hObject, eventdata, handles)
% hObject    handle to teB4Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of teB4Right as text
%        str2double(get(hObject,'String')) returns contents of teB4Right as a double


% --- Executes during object creation, after setting all properties.
function teB4Right_CreateFcn(hObject, eventdata, handles)
% hObject    handle to teB4Right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over btnLoadData.
function btnLoadData_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to btnLoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function clearAxes(handles)
cla(handles.axFitLeft);
cla(handles.axFitRight);

function plotHLNFull(handles)
    % left graph
    B = str2double(get(handles.teBmaxLeft,'String'));
    x = linspace(-B, 0, handles.numOfPoints);
    B1 = str2double(get(handles.teB1Left,'String'));
    B2 = str2double(get(handles.teB2Left,'String'));
    B3 = str2double(get(handles.teB3Left,'String'));
    B4 = str2double(get(handles.teB4Left,'String'));
    y = HLNFull(B1, B2, B3, x);
    plot(handles.axFitLeft, x, y, 'color', 'blue');
    hold(handles.axFitLeft, 'on');
    % right graph
    B = str2double(get(handles.teBmaxRight,'String'));
    x = linspace(0, B, handles.numOfPoints);
    B1 = str2double(get(handles.teB1Right,'String'));
    B2 = str2double(get(handles.teB2Right,'String'));
    B3 = str2double(get(handles.teB3Right,'String'));
    B4 = str2double(get(handles.teB4Right,'String'));
    y = HLNFull(B1, B2, B3, x);
    plot(handles.axFitRight, x, y, 'color', 'blue');
    hold(handles.axFitRight, 'on');

function plotHLNTruncated(handles)
    % left graph
    lineWidth = 1.5;
    B = str2double(get(handles.teBmaxLeft,'String'));
    x = linspace(-B, 0, handles.numOfPoints);
    alpha = str2double(get(handles.teAlphaLeft,'String'));
    Bphi = str2double(get(handles.teBphiLeft,'String'));    
    y = HLNTruncated(alpha, Bphi, x);
    plot(handles.axFitLeft, x, y, 'color', 'red', 'linewidth', lineWidth);
    hold(handles.axFitLeft, 'on');
    % right graph
    B = str2double(get(handles.teBmaxRight,'String'));
    x = linspace(0, B, handles.numOfPoints);
    alpha = str2double(get(handles.teAlphaRight,'String'));
    Bphi = str2double(get(handles.teBphiRight,'String'));    
    y = HLNTruncated(alpha, Bphi, x);
    plot(handles.axFitRight, x, y, 'color', 'red', 'linewidth', lineWidth);
    set(handles.axFitRight, 'YAxisLocation', 'right');
    hold(handles.axFitRight, 'on');

function plotExperimental(handles)
    % positive B-field sweep
    x = handles.positiveB;
    y = handles.positiveDG;
    hold(handles.axFitRight, 'on');
    plot(handles.axFitRight, x, y, 'o', 'color', 'black');
    set(handles.axFitRight, 'YAxisLocation', 'right');
    % negative B-field sweep
    x = handles.negativeB;
    y = handles.negativeDG;
    hold(handles.axFitLeft, 'on');
    plot(handles.axFitLeft, x, y, 'o', 'color', 'black');
    % setting identical limits for both right and left axes
    y = max( [max(abs(handles.positiveDG)) max(abs(handles.negativeDG))]);
    if handles.positiveDG(end) < 0
        y = -y;
        ylim(handles.axFitRight, [y 0]);
        ylim(handles.axFitLeft, [y 0]);
    else
        ylim(handles.axFitRight, [0 y]);
        ylim(handles.axFitLeft, [0 y]);
    end
    

function plotMRCurve(handles)
figure;
plot(handles.bFieldData, handles.rData, 'bo');
xlabel('Field, Tesla');
ylabel('Resistance, Ohm');



   
    
% --- Executes on button press in btnRandomizeFull.
function btnRandomizeFull_Callback(hObject, eventdata, handles)
% hObject    handle to btnRandomizeFull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% randomizing left-side values
B = str2double(get(handles.teBmaxLeft,'String'));
B1 = random('unif', 0, B);
set(handles.teB1Left, 'String', num2str(B1, handles.formatSpec));
B2 = random('unif', 0, B);
set(handles.teB2Left, 'String', num2str(B2, handles.formatSpec));
B3 = random('unif', 0, B);
set(handles.teB3Left, 'String', num2str(B3, handles.formatSpec));
B4 = B1^2*B3/B2^2;
set(handles.teB4Left, 'String', num2str(B4, handles.formatSpec));
% randomizing right-side values
B = str2double(get(handles.teBmaxRight,'String'));
B1 = random('unif', 0, B);
set(handles.teB1Right, 'String', num2str(B1, handles.formatSpec));
B2 = random('unif', 0, B);
set(handles.teB2Right, 'String', num2str(B2, handles.formatSpec));
B3 = random('unif', 0, B);
set(handles.teB3Right, 'String', num2str(B3, handles.formatSpec));
B4 = B1^2*B3/B2^2;
set(handles.teB4Right, 'String', num2str(B4, handles.formatSpec));


% --- Executes on button press in btnSimpleReplot.
function btnSimpleReplot_Callback(hObject, eventdata, handles)
% hObject    handle to btnSimpleReplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% then plotting stuff again
% Analytical Curve: Truncated HLN expression
clearAxes(handles);
plotHLNTruncated(handles);
plotExperimental(handles);


% --- Executes on button press in btnShowMRCurve.
function btnShowMRCurve_Callback(hObject, eventdata, handles)
% hObject    handle to btnShowMRCurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotMRCurve(handles);


% --- Executes on button press in btnRefitSimple.
function btnRefitSimple_Callback(hObject, eventdata, handles)
% hObject    handle to btnRefitSimple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Start fitting over, but use the current values of the paramters as
% starting points 