% CURRENTLY WORKING ON
%       -Horizontal check in ComputerAI()


function varargout = ConnectFourCode(varargin)
% CONNECTFOURCODE MATLAB code for ConnectFourCode.fig
%      CONNECTFOURCODE, by itself, creates a new CONNECTFOURCODE or raises the existing
%      singleton*.
%
%      H = CONNECTFOURCODE returns the handle to a new CONNECTFOURCODE or the handle to
%      the existing singleton*.
%
%      CONNECTFOURCODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONNECTFOURCODE.M with the given input arguments.
%
%      CONNECTFOURCODE('Property','Value',...) creates a new CONNECTFOURCODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConnectFourCode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConnectFourCode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConnectFourCode

% Last Modified by GUIDE v2.5 07-May-2016 11:22:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConnectFourCode_OpeningFcn, ...
                   'gui_OutputFcn',  @ConnectFourCode_OutputFcn, ...
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


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes just before ConnectFourCode is made visible.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ConnectFourCode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConnectFourCode (see VARARGIN)

% Choose default command line output for ConnectFourCode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConnectFourCode wait for user response (see UIRESUME)
% uiwait(handles.Background);

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This is the picture of the gameboard.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
axes(handles.axes1)
matlabImage = imread('gameboard-Model#3-CROP.png');
image(matlabImage)
axis off
axis image
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% creates the PlayerOneWin handle first '0' is matlab workspace i think
% second '0' is the value stored, here as the local variable PlayerOneWin.
handles = guidata(hObject);
handles.PlayerOneWin = 0;
PlayerOneWin = handles.PlayerOneWin;
guidata(hObject, handles);
setappdata(0,'PlayerOneWin', PlayerOneWin)

% creates the PlayerTwoWin handle first '0' is matlab workspace i think
% second '0' is the value stored, here as the local variable PlayerOneWin.
handles = guidata(hObject);
handles.PlayerTwoWin = 0;
PlayerTwoWin = handles.PlayerTwoWin;
guidata(hObject, handles);
setappdata(0,'PlayerTwoWin', PlayerTwoWin)

handles = guidata(hObject);
handles.HowTheyWon = 0;
HowTheyWon = handles.HowTheyWon;
guidata(hObject, handles);
setappdata(0,'HowTheyWon', HowTheyWon)

handles = guidata(hObject);
handles.PositionOnBoard = '0';
guidata(hObject, handles);


handles = guidata(hObject);
[handles.y1,handles.Fs1] = audioread('Click3.wav');
guidata(hObject, handles);


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This is the 6x7 matrix of the gameboard. Everything is '0' unless a puck 
% is there, in which case it is a '1' in that position for player1 and a 
% '2' in that position for player2.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
handles = guidata(hObject);
handles.gameboard = zeros(6,7);
guidata(hObject, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% set the intitial game speed to be just right. oohh yeah.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set(handles.GameSpeed,'Value',.10)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Set Gameboard - Sets the game board to be the empty pucks initially
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for currentRowNumber=1:6
    for currentColumnNumber=1:7
        RowAsString = strcat('R',num2str(currentRowNumber));
        ColAsString = strcat('C',num2str(currentColumnNumber));
        currentPosition = strcat(ColAsString,RowAsString);
        axes(handles.(currentPosition))
        matlabImage = imread('gameboard-Model-empty-puck#3-CROP.png');
        image(matlabImage)
        axis off
        axis image
    end
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% gets the data stored in the root of matlab directory called "0"
% specifically the string 'isPlayerTwoComputer'
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
handles.isPlayerTwoComputer = getappdata(0, 'isPlayerTwoComputer');
disp('Is player two a computer?: 1 for yes 0 for no')
disp(handles.isPlayerTwoComputer)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% playerOneMove - This is used to determine whose turn it is.
%               playerOneMove == 'true'   -> playerOne's turn.
%               playerOneMove == 'false'   -> playerTwo's turn.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
handles = guidata(hObject);
handles.playerOneMove = true;
guidata(hObject, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% analyzeGameBoard - Determines if there is a winner.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function analyzeGameBoard( hObject, eventdata, handles )
    handles = guidata(hObject);
    handles.gameboard;
    guidata(hObject, handles);
    
    % places the handle of gameboard into local variable "gameboard"
    gameboard = handles.gameboard;
    horizontalCountPlayerOne = 0;
    horizontalCountPlayerTwo = 0;
    
    verticalCountPlayerOne = 0;
    verticalCountPlayerTwo = 0;
    
    Diagnal1CountPlayerOne = 0;
    Diagnal1CountPlayerTwo = 0;
    
    Diagnal2CountPlayerOne = 0;
    Diagnal2CountPlayerTwo = 0;    
    
    % VERTICAL CHECK - checking for four-in-a-row
    for c=1:7
        for r=1:6 
            % Check current cell that we are in if there is a '1' or a '2'
            if gameboard(r,c) == 1
                % if we get here then that means that there is player 1's
                % puck in the way of player 2. I.E.: 2221                
                verticalCountPlayerOne = verticalCountPlayerOne + 1;
                verticalCountPlayerTwo = 0;
                % if this count variable == 4, then playerOne won.
                if verticalCountPlayerOne >= 4
                    disp('PlayerOne wins! - vertical')
                    handles.PlayerOneWin = 1;
                    PlayerOneWin = handles.PlayerOneWin;
                    setappdata(0,'PlayerOneWin', PlayerOneWin)
                    
                    % Vertical win = 1
                    handles.HowTheyWon = 1;
                    HowTheyWon = handles.HowTheyWon;
                    setappdata(0,'HowTheyWon', HowTheyWon)
                end
            end
            if gameboard(r,c) == 2
                verticalCountPlayerTwo = verticalCountPlayerTwo + 1;
                % if we get here then that means that there is player 2's
                % puck in the way of player 1. I.E.: 1112
                verticalCountPlayerOne = 0;
                % if this count variable == 4, then playerTwo won.
                if verticalCountPlayerTwo >= 4
                    disp('PlayerTwo wins! - vertical')
                    handles.PlayerTwoWin = 1;
                    PlayerTwoWin = handles.PlayerTwoWin;
                    setappdata(0,'PlayerTwoWin', PlayerTwoWin)
                    
                    % Vertical win = 1
                    handles.HowTheyWon = 1;
                    HowTheyWon = handles.HowTheyWon;
                    setappdata(0,'HowTheyWon', HowTheyWon)                    
                end
            end
        end
        verticalCountPlayerOne = 0;
        verticalCountPlayerTwo = 0;
    end

    % HORIZONTAL CHECK - checking for four-in-a-row
    for r=1:6
        for c=1:7
            % Check current cell that we are in if there is a '1' or a '2'
            if gameboard(r,c) == 1
                horizontalCountPlayerOne = horizontalCountPlayerOne + 1;
                horizontalCountPlayerTwo = 0;
                % if this count variable == 4, then playerOne won.
                if horizontalCountPlayerOne >= 4
                    disp('PlayerOne wins! - horizontal')
                    handles.PlayerOneWin = 1;
                    PlayerOneWin = handles.PlayerOneWin;
                    setappdata(0,'PlayerOneWin', PlayerOneWin)
                    
                    % Horizontal win = 2
                    handles.HowTheyWon = 2;
                    HowTheyWon = handles.HowTheyWon;
                    setappdata(0,'HowTheyWon', HowTheyWon)                    
                end
            elseif gameboard(r,c) == 2
                horizontalCountPlayerTwo = horizontalCountPlayerTwo + 1;
                horizontalCountPlayerOne = 0;
                % if this count variable == 4, then playerTwo won.
                if horizontalCountPlayerTwo >= 4
                    disp('PlayerTwo wins! - horizontal')
                    handles.PlayerTwoWin = 1;
                    PlayerTwoWin = handles.PlayerTwoWin;
                    setappdata(0,'PlayerTwoWin', PlayerTwoWin)
                    
                    % Horizontal win = 2
                    handles.HowTheyWon = 2;
                    HowTheyWon = handles.HowTheyWon;
                    setappdata(0,'HowTheyWon', HowTheyWon)    
                end
            elseif gameboard(r,c) == 0
                horizontalCountPlayerOne = 0;
                horizontalCountPlayerTwo = 0;
            end
        end
        horizontalCountPlayerOne = 0;
        horizontalCountPlayerTwo = 0;
    end

    % DIAGONAL CHECK Left to Right Down- checking for four-in-a-row
    Column_Matrix_Of_Diagnals1 = spdiags(gameboard);
    [Cm,Cn] = size(Column_Matrix_Of_Diagnals1);
        for n = 1:Cn %IE five times left and right
            for m = 1:Cm % IE six times up and down first
                if Column_Matrix_Of_Diagnals1(m,n) == 1
                    Diagnal1CountPlayerOne = Diagnal1CountPlayerOne + 1;
                    Diagnal1CountPlayerTwo = 0;
                    % if this count variable == 4, then playerOne won.
                    if Diagnal1CountPlayerOne >= 4
                        disp('PlayerOne wins! - diagnal left down')
                        handles.PlayerOneWin = 1;
                        PlayerOneWin = handles.PlayerOneWin;
                        setappdata(0,'PlayerOneWin', PlayerOneWin)
                        
                        % Diagnal left down win = 3
                        handles.HowTheyWon = 3;
                        HowTheyWon = handles.HowTheyWon;
                        setappdata(0,'HowTheyWon', HowTheyWon)    
                    end
                end
                if Column_Matrix_Of_Diagnals1(m,n) == 2
                    Diagnal1CountPlayerTwo = Diagnal1CountPlayerTwo + 1;
                    Diagnal1CountPlayerOne = 0;
                    % if this count variable == 4, then playerOne won.
                    if Diagnal1CountPlayerTwo >= 4
                        disp('PlayerTwo wins! - diagnal left down')
                        handles.PlayerTwoWin = 1;
                        PlayerTwoWin = handles.PlayerTwoWin;
                        setappdata(0,'PlayerTwoWin', PlayerTwoWin)
                        
                        % Diagnal left down win = 3
                        handles.HowTheyWon = 3;
                        HowTheyWon = handles.HowTheyWon;
                        setappdata(0,'HowTheyWon', HowTheyWon)                          
                    end
                end
            end
            Diagnal1CountPlayerOne = 0;
            Diagnal1CountPlayerTwo = 0;
        end
        
    % DIAGONAL CHECK Left to Right Up- checking for four-in-a-row
    Column_Matrix_Of_Diagnals2 = spdiags(fliplr(gameboard));
    [Dm,Dn] = size(Column_Matrix_Of_Diagnals2);
        for n = 1:Dn %IE five times left and right
            for m = 1:Dm % IE six times up and down first
                if Column_Matrix_Of_Diagnals2(m,n) == 1
                    Diagnal2CountPlayerOne = Diagnal2CountPlayerOne + 1;
                    Diagnal2CountPlayerTwo = 0;
                    % if this count variable == 4, then playerOne won.
                    if Diagnal2CountPlayerOne >= 4
                        disp('PlayerOne wins! - diagnal left up')
                        handles.PlayerOneWin = 1;
                        PlayerOneWin = handles.PlayerOneWin;
                        setappdata(0,'PlayerOneWin', PlayerOneWin)
                        
                        % Diagnal left up win = 4
                        handles.HowTheyWon = 4;
                        HowTheyWon = handles.HowTheyWon;
                        setappdata(0,'HowTheyWon', HowTheyWon)
                    end
                end
                if Column_Matrix_Of_Diagnals2(m,n) == 2
                    Diagnal2CountPlayerTwo = Diagnal2CountPlayerTwo + 1;
                    Diagnal2CountPlayerOne = 0;
                    % if this count variable == 4, then playerOne won.
                    if Diagnal2CountPlayerTwo >= 4
                        disp('PlayerTwo wins! - diagnal left up')
                        handles.PlayerTwoWin = 1;
                        PlayerTwoWin = handles.PlayerTwoWin;
                        setappdata(0,'PlayerTwoWin', PlayerTwoWin)
                        
                        % Diagnal left up win = 4
                        handles.HowTheyWon = 4;
                        HowTheyWon = handles.HowTheyWon;
                        setappdata(0,'HowTheyWon', HowTheyWon)
                    end
                end
            end
            Diagnal2CountPlayerOne = 0;
            Diagnal2CountPlayerTwo = 0;
        end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% findLowestRow() - Finds the lowest row that isn't '0'.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles )
    handles = guidata(hObject);
    handles.gameboard;
    guidata(hObject, handles);
    
    currentRow = 6;
    % does the check to make sure we are not in spot above the placement of
    % the puck. If so then we place an error message.
    while currentColumn(currentRow,1) ~= 0
        currentRow = currentRow - 1;
        % This brings up the dialog box and waits for the user to answer
        % the question. "modal" pauses the screen and makes sure that the
        % "ok" is pressed before continuing.
        if currentRow < 1
            [cdata,map] = imread('meh-face-emoticon.jpg');
            uiwait(msgbox('Choose a different column please',...
            'Error','custom',cdata,map,'modal'));
            % finnally a code to get out of the while loop YAY BREAK!
            break
        end
    end
    lowestRow = currentRow;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% DisplayPuck() - Names the row and column and specifically names it.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function PositionOnBoard = DisplayPuck(currentColumnNumber, lowestRow,...
    hObject, eventdata, handles )
    % Get the data from the game board
    handles = guidata(hObject);
    handles.gameboard;
    guidata(hObject, handles);
    
    % Concatinate "R" and "C" in front of the row and column to correspond
    % to the specifically names puck places.
    RowAsString = strcat('R',num2str(lowestRow));
    ColAsString = strcat('C',num2str(currentColumnNumber));
    PositionOnBoard = strcat(ColAsString,RowAsString);
    handles.PositionOnBoard = PositionOnBoard;
    guidata(hObject, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% PlacePuck() - Places the puck in the coresponding location.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function PlacePuck(hObject, eventdata, handles )
    % Get the data from the game board
    handles = guidata(hObject);
    handles.gameboard;
    guidata(hObject, handles);
    
    handles.PositionOnBoard;
    guidata(hObject, handles);    
    
    % Display the puck when the player places the puck
    % becomes handles.'C1R1' which is the given tag of the axes.
    if handles.playerOneMove == false
        axes(handles.(handles.PositionOnBoard));
        RedPuck_in_Matlab = imread('gameboard-Model-red-puck-CROP.png');
        image(RedPuck_in_Matlab);
        axis equal
        axis off
    elseif handles.playerOneMove == true
        axes(handles.(handles.PositionOnBoard));
        BlackPuck_in_Matlab = imread('gameboard-Model-black-puck-CROP.png');
        image(BlackPuck_in_Matlab);
        axis equal
        axis off
    end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% PlacePuck() - Places the puck in the coresponding location.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Animation(currentColumnNumber, lowestRow, hObject, eventdata,...
    handles )
    % so user cant click button while animation is going
    ButtonsOnOrOff(hObject, eventdata, handles, 0)

    % Get the data from the game board
    handles = guidata(hObject);
    handles.gameboard;
    guidata(hObject, handles);
    
    handles.PositionOnBoard;
    guidata(hObject, handles);  
    
    for i = 1:(lowestRow-1) % Counting down to the lowest row
        % Place a counter of 1 in the spot of the where we want the puck
        handles.gameboard(i,currentColumnNumber) = 1;
        guidata(hObject, handles);
        
        % i is not the lowest row but the next lowest.
        AnimationPosition = DisplayPuck(currentColumnNumber, i, hObject,...
            eventdata, handles );
        handles.PositionOnBoard = AnimationPosition;
        guidata(hObject, handles);
        
        % Because of the placement the Row and Column place a column
        PlacePuck(hObject, eventdata, handles )
        
        % place a character zero in the spot right before the character 1
        handles = guidata(hObject);
        handles.gameboard(i,currentColumnNumber) = 0;
        guidata(hObject, handles);  
        
        % use the game slider to slow or speed up the  game
        GameSpeed_Callback(hObject, eventdata, handles);
        
        % Places a "zero" puck in the spot before the character 1
        axes(handles.(handles.PositionOnBoard))
        matlabImage = imread('gameboard-Model-empty-puck#3-CROP.png');
        image(matlabImage)
        axis off
        axis image
    end
    
    % Turn visibility of button on.
    ButtonsOnOrOff(hObject, eventdata, handles, 1)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Outputs from this function are returned to the command line.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function varargout = ConnectFourCode_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnOne Has Copius Comments.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnOne_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to ColumnOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load the data of the gameboard into the button press
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);

handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');

currentColumnNumber = 1;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnThree.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnThree_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);

handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
currentColumnNumber = 3;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnTwo.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnTwo_Callback(hObject, eventdata, handles) %#ok<DEFNU>
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);
handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
currentColumnNumber = 2;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    analyzeGameBoard( hObject, eventdata, handles );
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnFour.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnFour_Callback(hObject, eventdata, handles) %#ok<DEFNU>
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);
handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
currentColumnNumber = 4;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    analyzeGameBoard( hObject, eventdata, handles );
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnFive.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnFive_Callback(hObject, eventdata, handles) %#ok<DEFNU>
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);
handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
currentColumnNumber = 5;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    analyzeGameBoard( hObject, eventdata, handles );
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnSix.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnSix_Callback(hObject, eventdata, handles) %#ok<DEFNU>
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);
handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
currentColumnNumber = 6;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    analyzeGameBoard( hObject, eventdata, handles );
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in ColumnSeven.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ColumnSeven_Callback(hObject, eventdata, handles) %#ok<DEFNU>
handles = guidata(hObject);
handles.gameboard;
guidata(hObject, handles);
handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
currentColumnNumber = 7;
currentColumn = handles.gameboard(:,currentColumnNumber);
lowestRow = findLowestRow( currentColumn, hObject, eventdata, handles );

if handles.playerOneMove == true
    if lowestRow < 1    
        return          
    else
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 1;
        handles.playerOneMove = false;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
elseif handles.playerOneMove == false
    if lowestRow < 1    
        return    
    end
    if handles.isPlayerTwoComputer == false
        sound(handles.y1,handles.Fs1); 
        guidata(hObject, handles); 
        analyzeGameBoard( hObject, eventdata, handles );
        Animation(currentColumnNumber, lowestRow, hObject, eventdata, handles );
        DisplayPuck( currentColumnNumber, lowestRow, hObject, eventdata, handles );
        PlacePuck( hObject, eventdata, handles );
        handles.gameboard(lowestRow,currentColumnNumber) = 2;
        handles.playerOneMove = true;
        analyzeGameBoard( hObject, eventdata, handles );
        Winner( hObject, eventdata, handles);
    end
end
guidata(hObject, handles);

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);

if handles.isPlayerTwoComputer == true
    pause(0.5+1.5*rand);
    sound(handles.y1,handles.Fs1);
    gameboard = ComputerAI(hObject, eventdata, handles);
    handles.playerOneMove = true;
    handles.gameboard = gameboard;
    guidata(hObject, handles);
    analyzeGameBoard( hObject, eventdata, handles );
    Winner( hObject, eventdata, handles);
end

analyzeGameBoard( hObject, eventdata, handles );
Winner( hObject, eventdata, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Background_CreateFcn(hObject, eventdata, handles)
% Function Background.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on slider movement for GameSpeed.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function GameSpeed_Callback(hObject, eventdata, handles)
% values here are purely for color
LowRange = .10;
HighRange = .35;
guidata(hObject, handles);
localcolor = (get(handles.GameSpeed,'Value'));
if (localcolor <= LowRange)
    set(handles.GameSpeed, 'backgroundcolor' , [1 0 0]);
elseif ((handles.GameSpeed > LowRange) && (handles.GameSpeed < HighRange))
    set(get(handles.GameSpeed,'Value'), 'backgroundcolor' , [0 1 0])
elseif (handles.GameSpeed  >= HighRange)
    set(handles.GameSpeed , 'backgroundcolor' , [0 1 0])
end
% this is the main point of this function pausing the animation the amount
% of time given the slider location
pause(get(handles.GameSpeed,'Value'));
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes during object creation, after setting all properties.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function GameSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GameSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- turn on or off the place puck buttons
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ButtonsOnOrOff(hObject, eventdata, handles, ON)
    if ON == 0
        set(handles.ColumnOne, 'Enable', 'Off');
        set(handles.ColumnTwo, 'Enable', 'Off');
        set(handles.ColumnThree, 'Enable', 'Off');
        set(handles.ColumnFour, 'Enable', 'Off');
        set(handles.ColumnFive, 'Enable', 'Off');
        set(handles.ColumnSix, 'Enable', 'Off');
        set(handles.ColumnSeven, 'Enable', 'Off');
    elseif ON == 1
        set(handles.ColumnOne, 'Enable', 'On');
        set(handles.ColumnTwo, 'Enable', 'On');
        set(handles.ColumnThree, 'Enable', 'On');
        set(handles.ColumnFour, 'Enable', 'On');
        set(handles.ColumnFive, 'Enable', 'On');
        set(handles.ColumnSix, 'Enable', 'On');
        set(handles.ColumnSeven, 'Enable', 'On');
    end
    guidata(hObject, handles);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- displays the win screen
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Winner(hObject, eventdata, handles)
    handles.PlayerOneWin = getappdata(0, 'PlayerOneWin');
    handles.PlayerTwoWin = getappdata(0, 'PlayerTwoWin');
    handles.HowTheyWon = getappdata(0, 'HowTheyWon');  
    handles.isPlayerTwoComputer = getappdata(0,'isPlayerTwoComputer');
    % Player 1 wins the game
    if handles.PlayerOneWin == 1 && handles.PlayerTwoWin == 0
        % turn off the buttons
        ButtonsOnOrOff(hObject, eventdata, handles, 0)
        switch handles.HowTheyWon
            case 1
                ToBeDispayed = 'Vertical Win for Player One';
                setappdata(0, 'PlayerWinText', ToBeDispayed);
            case 2
                ToBeDispayed = 'Horizontal Win for Player One';
                setappdata(0, 'PlayerWinText', ToBeDispayed);
            case 3
                ToBeDispayed = 'Diagnal Left Down Win for Player One';
                setappdata(0, 'PlayerWinText', ToBeDispayed);                
            case 4
                ToBeDispayed = 'Diagnal Left Up Win for Player One';
                setappdata(0, 'PlayerWinText', ToBeDispayed); 
        end
        % run the code to play the PlayAgain
    elseif handles.PlayerOneWin == 0 && handles.PlayerTwoWin == 1
        % turn off the buttons
        ButtonsOnOrOff(hObject, eventdata, handles, 0)
        switch handles.HowTheyWon
            case 1
                ToBeDispayed = 'Vertical Win for Player Two';
                setappdata(0, 'PlayerWinText', ToBeDispayed);
            case 2
                ToBeDispayed = 'Horizontal Win for Player Two';
                setappdata(0, 'PlayerWinText', ToBeDispayed);
            case 3
                ToBeDispayed = 'Diagnal Left Down Win for Player Two';
                setappdata(0, 'PlayerWinText', ToBeDispayed);                
            case 4
                ToBeDispayed = 'Diagnal Left Up Win for Player Two';
                setappdata(0, 'PlayerWinText', ToBeDispayed); 
        end
    end
    if (handles.PlayerOneWin == 1 && handles.PlayerTwoWin == 0) || ...
       (handles.PlayerOneWin == 0 && handles.PlayerTwoWin == 1) 
       run YOUWON;
    end
    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
% SKYNET IS TAKING OVER - GET TO THE CHOPPAH    
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function gameboardAfterComputerMoves = ComputerAI( hObject, eventdata, handles ); 

analyzeGameBoard( hObject, eventdata, handles );
handles.gameboard;

horizontalCountPlayerOne = 0;
horizontalCountPlayerTwo = 0;
horizontalPriorityPlayerOne = 0;
horizontalPriorityPlayerTwo = 0;

verticalCountPlayerOne = 0;
verticalCountPlayerTwo = 0;
verticalPriorityPlayerOne = 0;
verticalPriorityPlayerTwo = 0;


% VERTICAL CHECK 
for c=1:7
    for r=6:-1:1
        % Checking from the bottom of the column up to the top
        if handles.gameboard(r,c) == 1
            verticalCountPlayerOne = verticalCountPlayerOne + 1;
            verticalCountPlayerTwo = 0;
        end
        if handles.gameboard(r,c) == 2
            verticalCountPlayerTwo = verticalCountPlayerTwo + 1;
            verticalCountPlayerOne = 0;
        end
    end
    % At this point, we have gone through the whole column and need to
    % store if we have some Priority before we move to the next column
    if verticalCountPlayerTwo >= verticalPriorityPlayerTwo
        verticalPriorityPlayerTwo = verticalCountPlayerTwo;
        columnWithHighestPlayerTwoPriority = c;
    end
    if verticalCountPlayerOne >= verticalPriorityPlayerOne
        verticalPriorityPlayerOne = verticalCountPlayerOne;
        columnWithHighestPlayerOnePriority = c;
    end
    verticalCountPlayerOne = 0;
    verticalCountPlayerTwo = 0;
end

% HORIZONTAL CHECK
for r=6:-1:1
    for c=1:7
        if handles.gameboard(r,c) == 1
            horizontalCountPlayerOne = horizontalCountPlayerOne + 1;
            horizontalCountPlayerTwo = 0;
        elseif handles.gameboard(r,c) == 2
            horizontalCountPlayerTwo = horizontalCountPlayerTwo + 1;
            horizontalCountPlayerOne = 0;
        end
        % Get Priorities
        if horizontalCountPlayerTwo >= horizontalPriorityPlayerTwo
            horizontalPriorityPlayerTwo = horizontalCountPlayerTwo;
            rowWithHighestPlayerTwoPriority = r;
        end
        if horizontalCountPlayerOne >= horizontalPriorityPlayerOne
           horizontalPriorityPlayerOne = horizontalCountPlayerOne;
            rowWithHighestPlayerOnePriority = r;
        end
    end
    rowPlayerTwoToBeAnalyzed = handles.gameboard(rowWithHighestPlayerTwoPriority,:);
    rowPlayerOneToBeAnalyzed = handles.gameboard(rowWithHighestPlayerOnePriority,:);
    columnToUseForHorizontalPriorityPlayerTwo = analyzeHorizontal( rowPlayerTwoToBeAnalyzed, 2, hObject, eventdata, handles );
    columnToUseForHorizontalPriorityPlayerOne = analyzeHorizontal( rowPlayerOneToBeAnalyzed, 1, hObject, eventdata, handles );
    horizontalCountPlayerOne = 0;
    horizontalCountPlayerTwo = 0;
end

columnToUseForHorizontalPriorityPlayerOne
horizontalPriorityPlayerOne

% 1st Priority - If Computer can win, doggone it just win alreadY
%   VERTICAL WIN for Computer
if verticalPriorityPlayerTwo == 3
    currentColumn = handles.gameboard(:,columnWithHighestPlayerTwoPriority);
    lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
    Animation(columnWithHighestPlayerTwoPriority, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = DisplayPuck( columnWithHighestPlayerTwoPriority, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = str2num(PositionOnBoard(1,end));
    while PositionOnBoard == 0
        columnWithHighestPlayerTwoPriority = randi(7);
        currentColumn = handles.gameboard(:,columnWithHighestPlayerTwoPriority);
        lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
        Animation(columnWithHighestPlayerTwoPriority, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = DisplayPuck( columnWithHighestPlayerTwoPriority, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = str2num(PositionOnBoard(1,end));
    end
    PlacePuck( hObject, eventdata, handles );
    handles.gameboard(lowestRow,columnWithHighestPlayerTwoPriority) = 2;
    guidata(hObject, handles);
    gameboardAfterComputerMoves = handles.gameboard;
    return
end

% 2nd Priority - If Computer can win, doggone it just win already
%   HORIZONTAL WIN for Computer
if horizontalPriorityPlayerTwo == 3
    currentColumn = handles.gameboard(:,columnToUseForHorizontalPriorityPlayerTwo);
    lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
    Animation(columnToUseForHorizontalPriorityPlayerTwo, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = DisplayPuck( columnToUseForHorizontalPriorityPlayerTwo, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = str2num(PositionOnBoard(1,end));
    while PositionOnBoard == 0
        columnToUseForHorizontalPriorityPlayerTwo = randi(7);
        currentColumn = handles.gameboard(:,columnToUseForHorizontalPriorityPlayerTwo);
        lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
        Animation(columnToUseForHorizontalPriorityPlayerTwo, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = DisplayPuck( columnToUseForHorizontalPriorityPlayerTwo, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = str2num(PositionOnBoard(1,end));
    end
    PlacePuck( hObject, eventdata, handles );
    handles.gameboard(lowestRow,columnToUseForHorizontalPriorityPlayerTwo) = 2;
    guidata(hObject, handles);
    gameboardAfterComputerMoves = handles.gameboard;
    return
end

% 3rd Priority - If Computer can block human when human is at 3-in-a-row,
% doggone it just do it already.
%   VERTICAL BLOCK 
if verticalPriorityPlayerOne == 3
    currentColumn = handles.gameboard(:,columnWithHighestPlayerOnePriority);
    lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
    Animation(columnWithHighestPlayerOnePriority, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = DisplayPuck( columnWithHighestPlayerOnePriority, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = str2num(PositionOnBoard(1,end));
    while PositionOnBoard == 0
        columnWithHighestPlayerOnePriority = randi(7);
        currentColumn = handles.gameboard(:,columnWithHighestPlayerOnePriority);
        lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
        Animation(columnWithHighestPlayerOnePriority, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = DisplayPuck( columnWithHighestPlayerOnePriority, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = str2num(PositionOnBoard(1,end));
    end
    PlacePuck( hObject, eventdata, handles );
    handles.gameboard(lowestRow,columnWithHighestPlayerOnePriority) = 2;
    guidata(hObject, handles);
    gameboardAfterComputerMoves = handles.gameboard;
    return
end


% 4th Priority - If Computer can block human when human is at 3-in-a-row,
% doggone it just do it already.
%   HORIZONTAL BLOCK 
if horizontalPriorityPlayerOne == 3
    disp('inside horizontalPriorityPlayerOne == 3')
    currentColumn = handles.gameboard(:,columnToUseForHorizontalPriorityPlayerOne);
    lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
    Animation(columnToUseForHorizontalPriorityPlayerOne, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = DisplayPuck( columnToUseForHorizontalPriorityPlayerOne, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = str2num(PositionOnBoard(1,end));
    while PositionOnBoard == 0
        columnToUseForHorizontalPriorityPlayerOne = randi(7);
        currentColumn = handles.gameboard(:,columnToUseForHorizontalPriorityPlayerOne);
        lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
        Animation(columnToUseForHorizontalPriorityPlayerOne, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = DisplayPuck( columnToUseForHorizontalPriorityPlayerOne, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = str2num(PositionOnBoard(1,end));
    end
    PlacePuck( hObject, eventdata, handles );
    handles.gameboard(lowestRow,columnToUseForHorizontalPriorityPlayerOne) = 2;
    guidata(hObject, handles);
    gameboardAfterComputerMoves = handles.gameboard;
    return
end

% Last Priority - Random move
if 1
    c = randi(7);
    currentColumn = handles.gameboard(:,c);
    lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
    Animation(c, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = DisplayPuck( c, lowestRow, hObject, eventdata, handles );
    PositionOnBoard = str2num(PositionOnBoard(1,end));
    while PositionOnBoard == 0
        c = randi(7);
        currentColumn = handles.gameboard(:,c);
        lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles );
        Animation(c, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = DisplayPuck( c, lowestRow, hObject, eventdata, handles );
        PositionOnBoard = str2num(PositionOnBoard(1,end));
    end
    PlacePuck( hObject, eventdata, handles );
    handles.gameboard(lowestRow,c) = 2;
    guidata(hObject, handles);
    gameboardAfterComputerMoves = handles.gameboard;
end

analyzeGameBoard( hObject, eventdata, handles );

handles.playerOneMove = true;
guidata(hObject, handles);
gameboardAfterComputerMoves = handles.gameboard;



function lowestRow = findLowestRowComputer( currentColumn, hObject, eventdata, handles )
    handles = guidata(hObject);
    handles.gameboard;
    guidata(hObject, handles);
    
    currentRow = 6;
    while currentColumn(currentRow,1) ~= 0
        currentRow = currentRow - 1;
        % This brings up the dialog box and waits for the user to answer
        % the question. "modal" pauses the screen and makes sure that the
        % "ok" is pressed before continuing.
        if currentRow < 1
            break
        end
    end
    lowestRow = currentRow;
    
function columnToUseForHorizontalPriority = analyzeHorizontal ( rowToBeAnalyzed, player, hObject, eventdata, handles )
lastSpot=0;
columnToUseForHorizontalPriority=0;
playerCount=0;

if player == 2
    for c=1:7
        if rowToBeAnalyzed(1,c) == 2
            playerCount = playerCount + 1;
            lastSpot=2;
        elseif rowToBeAnalyzed(1,c) == 1
            lastSpot=1;
        elseif rowToBeAnalyzed(1,c) == 0
            if lastSpot==2 && playerCount > 2
                columnToUseForHorizontalPriority = c;
            end
            lastSpot=0;
        end
    end
    playerCount=0;
    for c=7:-1:1
        if rowToBeAnalyzed(1,c) == 2
            playerCount = playerCount + 1;
            lastSpot=2;
        elseif rowToBeAnalyzed(1,c) == 1
            lastSpot=1;
        elseif rowToBeAnalyzed(1,c) == 0
            if lastSpot==2 && playerCount > 2
                columnToUseForHorizontalPriority = c;
            end
            lastSpot=0;
        end
    end
elseif player == 1
    for c=1:7
        if rowToBeAnalyzed(1,c) == 2
            lastSpot=2;
        elseif rowToBeAnalyzed(1,c) == 1
            playerCount = playerCount + 1;
            lastSpot=1;
        elseif rowToBeAnalyzed(1,c) == 0
            if lastSpot==1 && playerCount > 2
                columnToUseForHorizontalPriority = c;
            end
            lastSpot=0;
        end
    end
    playerCount=0;
    for c=7:-1:1
        if rowToBeAnalyzed(1,c) == 2
            lastSpot=2;
        elseif rowToBeAnalyzed(1,c) == 1
            playerCount = playerCount + 1;
            lastSpot=1;
        elseif rowToBeAnalyzed(1,c) == 0
            if lastSpot==1 && playerCount > 2
                columnToUseForHorizontalPriority = c;
            end
            lastSpot=0;
        end
    end
end

if columnToUseForHorizontalPriority == 0
    columnToUseForHorizontalPriority = randi(7);
end

