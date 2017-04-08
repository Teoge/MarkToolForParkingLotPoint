function hotkeyPressed( hObject, eventdata )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
if handles.focusMode
    step = 0.2;
else
    step = 1;
end
if strcmp(get(gcf, 'CurrentCharacter'),'f')
    cursorPoint = get(handles.AxesImage, 'CurrentPoint');
    curX = cursorPoint(1,1);
    curY = cursorPoint(1,2);
    xLimits = get(handles.AxesImage, 'xlim');
    yLimits = get(handles.AxesImage, 'ylim');
    if ~handles.focusMode && (curX > min(xLimits) && curX < max(xLimits) && ...
           curY > min(yLimits) && curY < max(yLimits))
        set(handles.AxesImage, 'xlim', [curX-40,curX+40], 'ylim', [curY-40,curY+40]);
        handles.focusMode = true;
        handles.selected = 0;
        for i = 1:size(handles.marks, 1)
            if abs(handles.marks(i, 1) - curX) < 40 && abs(handles.marks(i, 2) - curY) < 40
                handles.selected = i;
                break;
            end
        end
    else
        set(handles.AxesImage, 'xlim', [0.5,600.5], 'ylim', [0.5,600.5]);
        handles.focusMode = false;
        handles.selected = size(handles.marks, 1);
    end
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'w')
    if handles.selected ~= 0
        handles.marks(handles.selected, 2) = handles.marks(handles.selected, 2) - step;
        delete(handles.markPlots(handles.selected, :));
        handles = plotMarks(handles, handles.selected);
        guidata(hObject, handles);
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'a')
    if handles.selected ~= 0
        handles.marks(handles.selected, 1) = handles.marks(handles.selected, 1) - step;
        delete(handles.markPlots(handles.selected, :));
        handles = plotMarks(handles, handles.selected);
        guidata(hObject, handles);
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'s')
    if handles.selected ~= 0
        handles.marks(handles.selected, 2) = handles.marks(handles.selected, 2) + step;
        delete(handles.markPlots(handles.selected, :));
        handles = plotMarks(handles, handles.selected);
        guidata(hObject, handles);
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'d')
    if handles.selected ~= 0
        handles.marks(handles.selected, 1) = handles.marks(handles.selected, 1) + step;
        delete(handles.markPlots(handles.selected, :));
        handles = plotMarks(handles, handles.selected);
        guidata(hObject, handles);
    end
elseif strcmp(get(gcf, 'CurrentCharacter'),'e')
    main('SaveMark_Callback', handles.SaveMark, eventdata, handles);
elseif double(get(gcf, 'CurrentCharacter'))==29
    main('LoadNextImage_Callback', hObject, eventdata, handles);
elseif double(get(gcf, 'CurrentCharacter'))==28
    main('LoadLastImage_Callback', hObject, eventdata, handles);
end
end

