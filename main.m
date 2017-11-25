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

% Last Modified by GUIDE v2.5 10-Apr-2017 22:21:55

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

data.marks = handles.marks;
SlotTable = get(handles.SlotTable,'data');
SlotTable(any(cellfun(@isempty, SlotTable),2),:) = [];
SlotTable(any(cellfun(@isnan, SlotTable),2),:) = [];
SlotTable = cell2mat(SlotTable);
%SlotTable(all(arrayfun(@(x) isempty(x)|isnan(x), SlotTable),2),:) = [];
data.slots = SlotTable;
save(name, '-struct', 'data', 'marks', 'slots');

if ~isempty(handles.markLines)
    delete(handles.markLines(:));
    handles.markLines(:) = [];
end
if strcmp(get(hObject,'tag'),'SaveMark')
    handles = drawSlots(handles, data.slots, handles.marks);
    set(handles.LoadResult, 'String', 'Save Success!');
end

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


function loadImageAndMarks(hObject, handles)
name = [handles.imagePath, handles.images(handles.imageIndex).name];
if ~exist(name, 'file')
    set(handles.LoadResult, 'String', 'The image does not exist');
else
    hold off;
    image = imread(name);
    imshow(image);
    [handles.imageHeight, handles.imageWidth, ~] = size(image);
    hold on;
    set(handles.ImageFileName, 'String', ...
        ['No.', num2str(handles.imageIndex),': ', handles.images(handles.imageIndex).name]);
    handles.marks = [];
    handles.markPlots = [];
    handles.markLines = [];
    name(end - 2 : end) = 'mat';
    if exist(name, 'file')
        data = load(name);
        if isfield(data,'marks')
            if ~isempty(data.marks)
                handles.marks = data.marks(:,1:2);
            end
        end
        if ~isfield(data,'slots')
            data.slots = [];
        end
        slotsCell = num2cell(data.slots);
        slotsCell{16,5} = [];
        %slotsCell(:,3) = {1};
        %slotsCell(:,4) = {90};
    	set(handles.SlotTable, 'data', slotsCell(1:15,1:4));
        handles = drawSlots(handles, data.slots, handles.marks);
        for i = 1:size(handles.marks, 1)
            handles = plotMarks(handles, i);
        end
    else
        set(handles.SlotTable, 'data', cell(size(get(handles.SlotTable,'data'))));
    end
    handles.focusMode = false;
    handles.selected = 0;
    set(handles.SelectedMark, 'String', '0');
    handles.moving = 0;
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
if handles.moving ~= 0 && curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits)...
        && curX > 0.5 && curX < handles.imageWidth + 0.5 && curY > 0.5 && curY < handles.imageHeight + 0.5
    handles.marks(handles.moving, :) = [curX, curY] + handles.movingOffset;
    if all(ishandle(handles.markPlots(handles.moving, :)))
        delete(handles.markPlots(handles.moving, :));
        handles = plotMarks(handles, handles.moving);
        SlotTable = get(handles.SlotTable,'data');
        SlotTable(any(cellfun(@isempty, SlotTable),2),:) = [];
        SlotTable(any(cellfun(@isnan, SlotTable),2),:) = [];
        SlotTable = cell2mat(SlotTable);
        if ~isempty(handles.markLines)
            delete(handles.markLines(:));
            handles.markLines(:) = [];
        end
        handles = drawSlots(handles, SlotTable, handles.marks);
    end
    guidata(hObject, handles);
end


function mouseReleased(hObject, ~)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
if strcmp(get(gcf,'selectionType'), 'normal') && handles.moving ~= 0
    handles.moving = 0;
    guidata(hObject, handles);
end
