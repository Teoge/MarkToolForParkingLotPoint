function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 13-Jul-2019 10:34:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

handles.readSuccess = 0;
set(gcf, 'WindowButtonDownFcn', @mouseClicked);
set(gcf, 'WindowButtonUpFcn', @mouseReleased);
set(gcf, 'WindowKeyPressFcn', @hotkeyPressed);
set(gcf, 'WindowScrollWheelFcn', @scrollWhellFunction);
set(gcf, 'WindowButtonMotionFcn', @updateCursor);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ReadImage.
function ReadImage_Callback(hObject, ~, handles)
% hObject    handle to ReadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = get(handles.FolderPath, 'String');
if ~exist(path, 'dir')
    set(handles.ReadResult, 'String', 'The path is not valid!');
    return;
end
formats = get(handles.ImageFormat, 'String');
dirs = dir([path,'\*.',formats{get(handles.ImageFormat, 'Value')}]);
if isempty(dirs)
    set(handles.ReadResult, 'String', 'There is no image under this path!');
    return;
end
set(handles.ReadResult, 'String', [num2str(size(dirs, 1)), ' images read!']);
handles.readSuccess = 1;
handles.imagePath = [path, '\'];
handles.images = dirs;
handles.imageIndex = 1;
handles.slotList = SlotList(handles.SlotTable, handles.TableInfo);
loadImageAndMarks(hObject, handles);


% --- Executes on button press in SaveMark.
function SaveMark_Callback(hObject, ~, handles)
% hObject    handle to SaveMark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.readSuccess
    set(handles.LoadResult, 'String', 'Select folder first!');
    return;
end
name = [handles.imagePath, handles.images(handles.imageIndex).name];
name(end - 2 : end) = 'mat';
set(handles.LoadResult, 'String', 'Save Failed!');
data.marks = handles.pointList.ToVector();
data.slots = handles.slotList.slots;
save(name, '-struct', 'data', 'marks', 'slots');
set(handles.LoadResult, 'String', 'Save Success!');
handles.slotList.Replot(handles.pointList.points, handles.imageSize);
guidata(hObject, handles);


% --- Executes on button press in LoadLastImage.
function LoadLastImage_Callback(hObject, ~, handles)
% hObject    handle to LoadLastImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.readSuccess
    set(handles.LoadResult, 'String', 'Select folder first!');
    return;
end
if handles.imageIndex == 1
    set(handles.LoadResult, 'String', 'It is the first image!');
    return;
end
handles.imageIndex = handles.imageIndex - 1;
loadImageAndMarks(hObject, handles);


% --- Executes on button press in LoadNextImage.
function LoadNextImage_Callback(hObject, ~, handles)
% hObject    handle to LoadNextImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.readSuccess
    set(handles.LoadResult, 'String', 'Select folder first!');
    return;
end
if handles.imageIndex == size(handles.images, 1)
    set(handles.LoadResult, 'String', 'It is the last image!');
    return;
end
handles.imageIndex = handles.imageIndex + 1;
loadImageAndMarks(hObject, handles);


% --- Executes on button press in ChooseFolder.
function ChooseFolder_Callback(~, ~, handles)
% hObject    handle to ChooseFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dname = uigetdir(get(handles.FolderPath, 'String'));
if dname ~= 0
    set(handles.FolderPath, 'String', dname);
end


% --- Executes on button press in TurnToPage.
function TurnToPage_Callback(hObject, ~, handles)
% hObject    handle to TurnToPage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.readSuccess
    set(handles.LoadResult, 'String', 'Select folder first!');
    return;
end
page = str2double(get(handles.PageToTurn, 'String'));
page = page(1);
if page == fix(page) && page > 0 && page <= size(handles.images, 1)
    handles.imageIndex = page;
    loadImageAndMarks(hObject, handles);
else
    set(handles.LoadResult, 'String', 'Invaid Index!');
end


% --- Executes when entered data in editable cell(s) in SlotTable.
function SlotTable_CellEditCallback(hObject, ~, handles)
% hObject    handle to SlotTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
handles.slotList.UpdateSlotsFromTable();
handles.slotList.Replot(handles.pointList.points, handles.imageSize);
guidata(hObject, handles);


function loadImageAndMarks(hObject, handles)
name = [handles.imagePath, handles.images(handles.imageIndex).name];
if ~exist(name, 'file')
    set(handles.LoadResult, 'String', 'The image does not exist');
else
    hold off;
    image = imread(name);
    imshow(image);
    [imageHeight, imageWidth, ~] = size(image);
    if imageHeight ~= imageWidth
        set(handles.LoadResult, 'String', 'Incorrect image ratio');
        return
    else
        handles.imageSize = imageHeight;
    end
    hold on;
    set(handles.ImageFileName, 'String', ...
        ['No.', num2str(handles.imageIndex),': ', handles.images(handles.imageIndex).name]);
    handles.pointList = [];
    name(end - 2 : end) = 'mat';
    if exist(name, 'file')
        data = load(name);
        if ~isfield(data,'slots')
            data.slots = [];
        end
        if isfield(data,'marks')
            handles.pointList = PointList(data.marks, handles.SelectedMark);
        else
            handles.pointList = PointList([], handles.SelectedMark);
        end
        handles.slotList.Initialize(data.slots, handles.pointList.points, handles.imageSize);
    else
        handles.pointList = PointList([], handles.SelectedMark);
        handles.slotList.Initialize([], handles.pointList.points, handles.imageSize);
    end
    handles.manification = 1;
    % For moving point with mouse
    handles.movingPoint = false;
    handles.pointMovingOffset = [0, 0];
    % For moving axes with mouse
    handles.movingAxes = false;
    handles.axesMovingStart = [0, 0];
    handles.originalXLimits = [0, 0];
    handles.originalYLimits = [0, 0];
    set(handles.LoadResult, 'String', 'Load Success!');
    guidata(hObject, handles);
end


function scrollWhellFunction(hObject, eventdata)
handles = guidata(hObject);
if ~handles.readSuccess || handles.movingAxes
    return;
end
cursorPoint = get(handles.AxesImage, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);
xLimits = get(handles.AxesImage, 'xlim');
yLimits = get(handles.AxesImage, 'ylim');
axesSizes = [handles.imageSize, 0.4*handles.imageSize, 0.1*handles.imageSize];
if ~(curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
    return
end
if eventdata.VerticalScrollCount > 0
    if handles.manification <= 1
        handles.manification = 1;
        return;
    end
    if handles.manification == 2
        set(handles.ReferenceAxes, 'xlim', [0.5,handles.imageSize+0.5], ...
            'ylim', [0.5,handles.imageSize+0.5]);
        set(handles.AxesImage, 'xlim', [0.5,handles.imageSize+0.5], ...
            'ylim', [0.5,handles.imageSize+0.5]);
    elseif handles.manification == 3
        m = handles.manification;
        x1 = curX - axesSizes(m-1) / axesSizes(m) * (curX-xLimits(1));
        y1 = curY - axesSizes(m-1) / axesSizes(m) * (curY-yLimits(1));
        x2 = curX + axesSizes(m-1) / axesSizes(m) * (xLimits(2)-curX);
        y2 = curY + axesSizes(m-1) / axesSizes(m) * (yLimits(2)-curY);
        set(handles.ReferenceAxes, 'xlim', [x1, x2], 'ylim', [y1, y2]);
        set(handles.AxesImage, 'xlim', [x1, x2], 'ylim', [y1, y2]);
    end
    handles.manification = handles.manification - 1;
    guidata(hObject, handles);
elseif eventdata.VerticalScrollCount < 0
    if handles.manification >= 3
        handles.manification = 3;
        return
    end
    m = handles.manification;
    x1 = curX - axesSizes(m+1) / axesSizes(m) * (curX-xLimits(1));
    y1 = curY - axesSizes(m+1) / axesSizes(m) * (curY-yLimits(1));
    x2 = curX + axesSizes(m+1) / axesSizes(m) * (xLimits(2)-curX);
    y2 = curY + axesSizes(m+1) / axesSizes(m) * (yLimits(2)-curY);
    set(handles.ReferenceAxes, 'xlim', [x1, x2], 'ylim', [y1, y2]);
    set(handles.AxesImage, 'xlim', [x1, x2], 'ylim', [y1, y2]);
    handles.manification = handles.manification + 1;
    handles.pointList.DeselectIfNotInRange(x1, y1, x2, y2);
    guidata(hObject, handles);
end


function mouseClicked( hObject, ~ )

handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
cursorPoint = get(handles.AxesImage, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);

xLimits = get(handles.AxesImage, 'xlim');
yLimits = get(handles.AxesImage, 'ylim');
if curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits)...
        && curX > 0.5 && curX < handles.imageSize + 0.5 && curY > 0.5 && curY < handles.imageSize + 0.5
    if strcmp(get(gcf,'selectionType'), 'normal')
        if handles.manification == 2 || handles.manification == 3
            if handles.pointList.FindPointInRange(curX, curY)
                [px, py] = handles.pointList.GetSelectedPostion();
                handles.pointMovingOffset = [px, py] - [curX, curY];
                handles.movingPoint = true;
                handles.slotList.Replot(handles.pointList.points, handles.imageSize);
            else
                handles.axesMovingStart = get(handles.ReferenceAxes, 'CurrentPoint');
                handles.originalXLimits = xLimits;
                handles.originalYLimits = yLimits;
                handles.movingAxes = true;
            end
        else
            if ~handles.pointList.FindPointInRange(curX, curY)
                handles.pointList.AddPoint(curX, curY);
            end
            [px, py] = handles.pointList.GetSelectedPostion();
            handles.pointMovingOffset = [px, py] - [curX, curY];
            handles.movingPoint = true;
            handles.slotList.Replot(handles.pointList.points, handles.imageSize);
        end
    elseif strcmp(get(gcf,'selectionType'), 'alt')
        if handles.pointList.FindPointInRange(curX, curY)
            handles.pointList.DeletePoint();
            if handles.movingPoint
                handles.movingPoint = false;
            end
        end
        handles.slotList.Replot(handles.pointList.points, handles.imageSize);
    end
    guidata(hObject, handles);
end


function mouseReleased(hObject, ~)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
% disp(get(gcf,'selectionType'));
if handles.movingPoint
    if strcmp(get(gcf,'selectionType'), 'normal')
        handles.movingPoint = false;
    end
elseif handles.movingAxes
    if strcmp(get(gcf,'selectionType'), 'normal') || strcmp(get(gcf,'selectionType'), 'alt')
        handles.movingAxes = false;
    end
end
guidata(hObject, handles);

function updateCursor(hObject, ~)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
cursorPoint = get(handles.AxesImage, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);
set(handles.CurrentPoint, 'String', ['(',num2str(curX,'%.2f'),',',num2str(curY,'%.2f'),')']);
xLimits = get(handles.AxesImage, 'xlim');
yLimits = get(handles.AxesImage, 'ylim');
if curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits)...
        && curX > 0.5 && curX < handles.imageSize + 0.5 && curY > 0.5 && curY < handles.imageSize + 0.5
    if handles.movingPoint
        handles.pointList.SetPointPosition(curX + handles.pointMovingOffset(1), curY + handles.pointMovingOffset(2));
        handles.slotList.Replot(handles.pointList.points, handles.imageSize);
    elseif handles.movingAxes
        movingVector = handles.axesMovingStart - get(handles.ReferenceAxes, 'CurrentPoint');
        set(handles.AxesImage, 'xlim', handles.originalXLimits + movingVector(1, 1), 'ylim', handles.originalYLimits + movingVector(1, 2));
    end
    guidata(hObject, handles);
end

function hotkeyPressed( hObject, eventdata )
%HOTKEYPRESSED Respond the keyboard press event
%   Detailed explanation goes here
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
if handles.manification == 1
    step = 1;
elseif handles.manification == 2
    step = 0.3;
elseif handles.manification == 3
    step = 0.1;
end
if strcmp(get(gcf, 'CurrentCharacter'),'w') && ~handles.movingPoint
    handles.pointList.ShiftPointPosition(0, -step);
    handles.slotList.Replot(handles.pointList.points, handles.imageSize);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'a') && ~handles.movingPoint
    handles.pointList.ShiftPointPosition(-step, 0);
    handles.slotList.Replot(handles.pointList.points, handles.imageSize);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'s') && ~handles.movingPoint
    handles.pointList.ShiftPointPosition(0, step);
    handles.slotList.Replot(handles.pointList.points, handles.imageSize);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'d') && ~handles.movingPoint
    handles.pointList.ShiftPointPosition(step, 0);
    handles.slotList.Replot(handles.pointList.points, handles.imageSize);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'f')
    main('SaveMark_Callback', handles.SaveMark, eventdata, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'q')
    main('SaveMark_Callback', handles.SaveMark, eventdata, handles);
    main('LoadLastImage_Callback', hObject, eventdata, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'e')
    main('SaveMark_Callback', handles.SaveMark, eventdata, handles);
    main('LoadNextImage_Callback', hObject, eventdata, handles);
elseif double(get(gcf, 'CurrentCharacter'))==29
    main('LoadNextImage_Callback', hObject, eventdata, handles);
elseif double(get(gcf, 'CurrentCharacter'))==28
    main('LoadLastImage_Callback', hObject, eventdata, handles);
end
