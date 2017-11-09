function varargout = ConnectFourCode_Start(varargin)
% CONNECTFOURCODE_START MATLAB code for ConnectFourCode_Start.fig
%      CONNECTFOURCODE_START, by itself, creates a new CONNECTFOURCODE_START or raises the existing
%      singleton*.
%
%      H = CONNECTFOURCODE_START returns the handle to a new CONNECTFOURCODE_START or the handle to
%      the existing singleton*.
%
%      CONNECTFOURCODE_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONNECTFOURCODE_START.M with the given input arguments.
%
%      CONNECTFOURCODE_START('Property','Value',...) creates a new CONNECTFOURCODE_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConnectFourCode_Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConnectFourCode_Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConnectFourCode_Start

% Last Modified by GUIDE v2.5 06-May-2016 19:06:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConnectFourCode_Start_OpeningFcn, ...
                   'gui_OutputFcn',  @ConnectFourCode_Start_OutputFcn, ...
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


% --- Executes just before ConnectFourCode_Start is made visible.
function ConnectFourCode_Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConnectFourCode_Start (see VARARGIN)

% Choose default command line output for ConnectFourCode_Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set the initial condition of button selection to be nothing! NOTHING!!!!!
set(handles.isPlayerTwoComputer,'Value',0)

% --- Outputs from this function are returned to the command line.
function varargout = ConnectFourCode_Start_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in RunGame.
function handles = RunGame_Callback(hObject, eventdata, handles)

% get the value of the specific button pushed
isPlayerTwoComputer = get(handles.isPlayerTwoComputer, 'Value');

% Set the root "0" workspace in matlab to be the value of isPlayerTwoComputer
% The string: 'isPlayerTwoComputer' is the new name of the value inputed
setappdata(0, 'isPlayerTwoComputer', isPlayerTwoComputer);

% open the m file containg the awsome code
run ConnectFourCode

% Closes the code for the opening window
close('ConnectFourCode_Start')
