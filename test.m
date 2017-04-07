function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 06-Apr-2017 19:26:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% Choose default command line output for test
handles.output = hObject;

handles.readSuccess = 0;
set(gcf, 'WindowButtonDownFcn', @getMousePositionOnImage);
set(gcf, 'WindowKeyReleaseFcn', @hotkeyPressed);
set(gcf, 'WindowScrollWheelFcn', @zoomInOrOut);
set(gcf, 'WindowButtonMotionFcn', @updateCursor);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function FolderPath_Callback(hObject, eventdata, handles)
% hObject    handle to FolderPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FolderPath as text
%        str2double(get(hObject,'String')) returns contents of FolderPath as a double


% --- Executes during object creation, after setting all properties.
function FolderPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FolderPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ReadImage.
function ReadImage_Callback(hObject, eventdata, handles)
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
%imshow([path,'\',dirs(1).name]);
set(handles.ReadResult, 'String', [num2str(size(dirs, 1)), ' images read!']);
handles.readSuccess = 1;
handles.imagePath = [path, '\'];
handles.images = dirs;
handles.imageIndex = 1;
loadImageAndMarks(hObject, handles);

% --- Executes on button press in SaveMark.
function SaveMark_Callback(hObject, eventdata, handles)
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
for i = 1:size(SlotTable,1)
	if SlotTable(i,1)>size(data.marks,1)||SlotTable(i,2)>size(data.marks,1)
        set(handles.TableInfo, 'String', 'Invalid Point in Table');
        continue;
    end
	x1 = data.marks(SlotTable(i,1),1);
	y1 = data.marks(SlotTable(i,1),2);
	x2 = data.marks(SlotTable(i,2),1);
	y2 = data.marks(SlotTable(i,2),2);
    distance = (x1-x2)^2 + (y1-y2)^2;
    if distance>17768.89&&distance<39006.25%slotType = 1;
        sideLength = 280;
    elseif distance>129600&&distance<157609%slotType = 2;
        sideLength = 135;
    elseif distance>72900&&distance<119025%slotType = 3;
        sideLength = 150;
    else
        set(handles.TableInfo, 'String', 'Invalid Slot in Table');
        continue;
    end
    switch SlotTable(i, 3)
        case 1
            vec = [x2-x1, y2-y1]*[0, -1; 1, 0];
            vec = vec / norm(vec);
        case 2
            vec = [x2-x1, y2-y1]*[0.3907, -0.9205; 0.9205, 0.3907];
            vec = vec / norm(vec);
            sideLength = sideLength / 0.9205;
        case 3
            vec = [x2-x1, y2-y1]*[-0.3907, -0.9205; 0.9205, -0.3907];
            vec = vec / norm(vec);
            sideLength = sideLength / 0.9205;
        otherwise
            set(handles.TableInfo, 'String', 'Invalid Slot Type in Table');
            continue;
    end
	%a = plot([x1, x2],[y1, y2], 'k','LineWidth', 1);
	%b = plot([x2, x2+(x1-x2-y1+y2)/20],[y2, y2+(x1-x2+y1-y2)/20], 'k','LineWidth', 1);
	%c = plot([x2, x2+(x1-x2+y1-y2)/20],[y2, y2+(-x1+x2+y1-y2)/20], 'k','LineWidth', 1);
	handles.markLines = [handles.markLines; plot([x1+vec(1)*sideLength,x1,x2,x2+vec(1)*sideLength],[y1+vec(2)*sideLength,y1,y2,y2+vec(2)*sideLength], 'k','LineWidth', 1)];
	set(handles.TableInfo, 'String', '');
end
guidata(hObject, handles);
set(handles.LoadResult, 'String', 'Save Success!');

% --- Executes on button press in LodeLastImage.
function LodeLastImage_Callback(hObject, eventdata, handles)
% hObject    handle to LodeLastImage (see GCBO)
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
guidata(hObject, handles);
loadImageAndMarks(hObject, handles);

% --- Executes on button press in LoadNextImage.
function LoadNextImage_Callback(hObject, eventdata, handles)
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
guidata(hObject, handles);
loadImageAndMarks(hObject, handles);

% --- Executes on button press in ChooseFolder.
function ChooseFolder_Callback(hObject, eventdata, handles)
% hObject    handle to ChooseFolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dname = uigetdir();
if dname ~= 0
    set(handles.FolderPath, 'String', dname);
end

% --- Executes on mouse press over axes background.
function AxesImage_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to AxesImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function loadImageAndMarks(hObject, handles)
name = [handles.imagePath, handles.images(handles.imageIndex).name];
if ~exist(name, 'file')
    set(handles.LoadResult, 'String', 'The image does not exist');
else
    hold off;
    imshow(name);
    set(handles.ImageFileName, 'String', ['No.', num2str(handles.imageIndex),': ', handles.images(handles.imageIndex).name]);
    name(end - 2 : end) = 'mat';
    if exist(name, 'file')
        load(name);
        if ~exist('marks','var')
            marks = [];
        end
        if ~isempty(marks)
            handles.marks = marks(:,1:2);
        else
            handles.marks = [];
        end
        if ~exist('slots','var')
            slots = [];
        end
        slotsCell = num2cell(slots);
        slotsCell{16,4} = [];
        %slotsCell(:,3) = {1};
    	set(handles.SlotTable, 'data', slotsCell(1:15,1:3));
        handles.markPlots = [];
        handles.markLines = [];
        hold on;
        for i = 1:size(slots,1)
            if slots(i,1)>size(marks,1)||slots(i,2)>size(marks,1)
                set(handles.TableInfo, 'String', 'Invalid Point in Table');
                continue;
            end
            x1 = marks(slots(i,1),1);
            y1 = marks(slots(i,1),2);
            x2 = marks(slots(i,2),1);
            y2 = marks(slots(i,2),2);
            distance = (x1-x2)^2 + (y1-y2)^2;
            if distance>17768.89&&distance<39006.25%slotType = 1;
                sideLength = 280;
            elseif distance>129600&&distance<157609%slotType = 2;
                sideLength = 135;
            elseif distance>72900&&distance<119025%slotType = 3;
                sideLength = 150;
            else
                set(handles.TableInfo, 'String', 'Invalid Slot in Table');
                continue;
            end
            %radian = 1.16937 angle = 67
            switch slots(i, 3)
                case 1
                    vec = [x2-x1, y2-y1]*[0, -1; 1, 0];
                    vec = vec / norm(vec);
                case 2
                    vec = [x2-x1, y2-y1]*[0.3907, -0.9205; 0.9205, 0.3907];
                    vec = vec / norm(vec);
                    sideLength = sideLength / 0.9205;
                case 3
                    vec = [x2-x1, y2-y1]*[-0.3907, -0.9205; 0.9205, -0.3907];
                    vec = vec / norm(vec);
                    sideLength = sideLength / 0.9205;
                otherwise
                    set(handles.TableInfo, 'String', 'Invalid Slot Type in Table');
                    continue;
            end
            handles.markLines = [handles.markLines; plot([x1+vec(1)*sideLength,x1,x2,x2+vec(1)*sideLength],[y1+vec(2)*sideLength,y1,y2,y2+vec(2)*sideLength], 'k','LineWidth', 1)];
            set(handles.TableInfo, 'String', '');
        end
        for i = 1:size(handles.marks, 1)
            theta = linspace(0,2*pi);
            x1 = 10*cos(theta) + handles.marks(i, 1);
            y1 = 10*sin(theta) + handles.marks(i, 2);
            handles.markPlots = [handles.markPlots; [text(handles.marks(i, 1)+10,handles.marks(i, 2)+10,num2str(i),'Color','blue'), plot([handles.marks(i, 1)-20,handles.marks(i, 1)+20], [handles.marks(i, 2),handles.marks(i, 2)], 'b'), plot([handles.marks(i, 1),handles.marks(i, 1)], [handles.marks(i, 2)-20,handles.marks(i, 2)+20], 'b'), plot(x1,y1,'r','LineWidth',1)]];
        end
    else
        handles.marks = [];
        handles.markPlots = [];
        handles.markLines = [];
        set(handles.SlotTable, 'data', cell(size(get(handles.SlotTable,'data'))));
    end
    set(handles.LoadResult, 'String', 'Load Success!');
    guidata(hObject, handles);
end



function PageToTurn_Callback(hObject, eventdata, handles)
% hObject    handle to PageToTurn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PageToTurn as text
%        str2double(get(hObject,'String')) returns contents of PageToTurn as a double


% --- Executes during object creation, after setting all properties.
function PageToTurn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PageToTurn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in TurnToPage.
function TurnToPage_Callback(hObject, eventdata, handles)
% hObject    handle to TurnToPage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.readSuccess
    set(handles.LoadResult, 'String', 'Select folder first!');
    return;
end
page = str2num(get(handles.PageToTurn, 'String'));
page = page(1);
if page == fix(page) && page > 0 && page <= size(handles.images, 1)
    handles.imageIndex = page;
    loadImageAndMarks(hObject, handles);
else
    set(handles.LoadResult, 'String', 'Invaid Index!');
end


% --- Executes on selection change in ImageFormat.
function ImageFormat_Callback(hObject, eventdata, handles)
% hObject    handle to ImageFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImageFormat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageFormat


% --- Executes during object creation, after setting all properties.
function ImageFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function TurnToPage_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to TurnToPage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function hotkeyPressed(hObject, eventdata)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
xLimits = get(handles.AxesImage, 'xlim');
if xLimits(2)-xLimits(1) == 600
    focusMode = false;
    step = 1;
else
    focusMode = true;
    step = 0.3;
end
if strcmp(get(gcf, 'CurrentCharacter'),'f')
    cursorPoint = get(handles.AxesImage, 'CurrentPoint');
    curX = cursorPoint(1,1);
    curY = cursorPoint(1,2);
    yLimits = get(handles.AxesImage, 'ylim');
    if ~focusMode && (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
        set(handles.AxesImage, 'xlim', [curX-40 curX+40], 'ylim', [curY-40 curY+40]);
    else
        set(handles.AxesImage, 'xlim', [0 600], 'ylim', [0 600]);
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'w')
    if ~isempty(handles.marks)
        handles.marks(end, 2) = handles.marks(end, 2) - step;
        curX = handles.marks(end, 1);
        curY = handles.marks(end, 2);
        delete(handles.markPlots(end, :));
        theta = linspace(0,2*pi);
        x = 10*cos(theta) + curX;
        y = 10*sin(theta) + curY;
        handles.markPlots(end, :) = [text(curX+10,curY+10,num2str(size(handles.marks,1)),'Color','blue'), plot([curX-20,curX+20], [curY,curY], 'b'), plot([curX,curX], [curY-20,curY+20], 'b'), plot(x,y,'r','LineWidth',1)];
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'a')
    if ~isempty(handles.marks)
        handles.marks(end, 1) = handles.marks(end, 1) - step;
        curX = handles.marks(end, 1);
        curY = handles.marks(end, 2);
        delete(handles.markPlots(end, :));
        theta = linspace(0,2*pi);
        x = 10*cos(theta) + curX;
        y = 10*sin(theta) + curY;
        handles.markPlots(end, :) = [text(curX+10,curY+10,num2str(size(handles.marks,1)),'Color','blue'), plot([curX-20,curX+20], [curY,curY], 'b'), plot([curX,curX], [curY-20,curY+20], 'b'), plot(x,y,'r','LineWidth',1)];
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'s')
    if ~isempty(handles.marks)
        handles.marks(end, 2) = handles.marks(end, 2) + step;
        curX = handles.marks(end, 1);
        curY = handles.marks(end, 2);
        delete(handles.markPlots(end, :));
        theta = linspace(0,2*pi);
        x = 10*cos(theta) + curX;
        y = 10*sin(theta) + curY;
        handles.markPlots(end, :) = [text(curX+10,curY+10,num2str(size(handles.marks,1)),'Color','blue'), plot([curX-20,curX+20], [curY,curY], 'b'), plot([curX,curX], [curY-20,curY+20], 'b'), plot(x,y,'r','LineWidth',1)];
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'d')
    if ~isempty(handles.marks)
        handles.marks(end, 1) = handles.marks(end, 1) + step;
        curX = handles.marks(end, 1);
        curY = handles.marks(end, 2);
        delete(handles.markPlots(end, :));
        theta = linspace(0,2*pi);
        x = 10*cos(theta) + curX;
        y = 10*sin(theta) + curY;
        handles.markPlots(end, :) = [text(curX+10,curY+10,num2str(size(handles.marks,1)),'Color','blue'), plot([curX-20,curX+20], [curY,curY], 'b'), plot([curX,curX], [curY-20,curY+20], 'b'), plot(x,y,'r','LineWidth',1)];
    end
end
guidata(hObject, handles);

function zoomInOrOut(hObject, eventdata)
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
if eventdata.VerticalScrollCount > 0
    SaveMark_Callback(handles.SaveMark, eventdata, handles);
    LoadNextImage_Callback(handles.LoadNextImage, eventdata, handles);
elseif eventdata.VerticalScrollCount < 0
    SaveMark_Callback(handles.SaveMark, eventdata, handles);
    LodeLastImage_Callback(handles.LoadNextImage, eventdata, handles);
end

function updateCursor(hObject, eventdata)
handles = guidata(hObject);

% --------------------------------------------------------------------
function uitoggletool1_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
