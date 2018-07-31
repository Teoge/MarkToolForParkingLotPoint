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

% Last Modified by GUIDE v2.5 31-Jul-2018 13:15:09

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
set(gcf, 'WindowButtonMotionFcn', @updateCursor);
set(gcf, 'WindowKeyPressFcn', @hotkeyPressed);
set(gcf, 'WindowScrollWheelFcn', @scrollWhellFunction);

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
set(handles.ReadResult, 'String', [num2str(size(dirs, 1)), ' images found!']);
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
data.marks = handles.markingPointList.ToVector();
data.slots = handles.slotList.slots;
save(name, '-struct', 'data', 'marks', 'slots');
set(handles.LoadResult, 'String', 'Save Success!');
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


% --- Executes on button press in ShowSlots.
function ShowSlots_Callback(hObject, ~, handles)
% hObject    handle to ShowSlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.ShowSlots, 'Value') == 0
    handles.slotList.HidePlot();
else
    handles.slotList.ShowPlot(handles.markingPointList.markingPoints, handles.imageWidth);
end
guidata(hObject, handles);


% --- Executes on selection change in PointType.
function PointType_Callback(hObject, ~, handles)
% hObject    handle to PointType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
type = get(handles.PointType, 'Value') - 1;
handles.markingPointList.SetMarkingPointType(type);
guidata(hObject, handles);


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
guidata(hObject, handles);


function loadImageAndMarks(hObject, handles)
name = [handles.imagePath, handles.images(handles.imageIndex).name];
if ~exist(name, 'file')
    set(handles.LoadResult, 'String', 'The image does not exist');
else
    hold off;
    image = imread(name);
    imshow(image);
    hold on;
    [handles.imageHeight, handles.imageWidth, ~] = size(image);
    set(handles.ImageFileName, 'String', ...
        ['No.', num2str(handles.imageIndex),': ', handles.images(handles.imageIndex).name]);
    handles.markingPointList = [];
    name(end - 2 : end) = 'mat';
    if exist(name, 'file')
        data = load(name);
        if isfield(data,'marks')
            handles.markingPointList = MarkingPointList(data.marks);
        end
        if ~isfield(data,'slots')
            data.slots = [];
        end
        handles.slotList.Initialize(data.slots, handles.markingPointList.markingPoints, handles.imageHeight);
    else
        set(handles.SlotTable, 'data', cell(size(get(handles.SlotTable, 'data'))));
    end
    handles.focusMode = false;
    handles.mouseReleased = true;
    handles.movingOffset = [0, 0];
    handles.creatingPoint = false;
    set(handles.LoadResult, 'String', 'Load Success!');
    guidata(hObject, handles);
end


function scrollWhellFunction(hObject, eventdata)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
if eventdata.VerticalScrollCount > 0
    SaveMark_Callback(hObject, eventdata, handles);
    LoadNextImage_Callback(hObject, eventdata, handles);
elseif eventdata.VerticalScrollCount < 0
    SaveMark_Callback(hObject, eventdata, handles);
    LoadLastImage_Callback(hObject, eventdata, handles);
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
        && curX > 0.5 && curX < handles.imageWidth + 0.5 && curY > 0.5 && curY < handles.imageHeight + 0.5
    if strcmp(get(gcf,'selectionType'), 'normal')
        if ~handles.creatingPoint
            [x, y, handles.creatingPoint] = handles.markingPointList.FindPointInRangeOrCreate(curX, curY);
            handles.movingOffset = [x, y] - [curX, curY];
            handles.mouseReleased = false;
        else
            handles.markingPointList.AddMarkingPoint();
            handles.movingOffset = [0, 0];
            handles.creatingPoint = false;
            handles.mouseReleased = false;
        end
    elseif strcmp(get(gcf,'selectionType'), 'alt')
        handles.markingPointList.FindPointInRangeAndDelete(curX, curY);
        handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
    elseif strcmp(get(gcf,'selectionType'), 'extend')
        % When moving a marking point, click mouse right button to delete
        % the marking point.
        if ~handles.mouseReleased
            handles.markingPointList.DeleteMarkingPoint();
            handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
        end
    end
    guidata(hObject, handles);
end


function mouseReleased(hObject, ~)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
cursorPoint = get(handles.AxesImage, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);
if strcmp(get(gcf,'selectionType'), 'normal')
    if handles.creatingPoint
        handles.markingPointList.CreatingSecondPoint(curX, curY)
    end
    handles.mouseReleased = true;
    guidata(hObject, handles);
end


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
        && curX > 0.5 && curX < handles.imageWidth + 0.5 && curY > 0.5 && curY < handles.imageHeight + 0.5
    if ~handles.mouseReleased || handles.creatingPoint
        handles.markingPointList.SetPointPosition(curX + handles.movingOffset(1), curY + handles.movingOffset(2));
        handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
    end
    guidata(hObject, handles);
end
