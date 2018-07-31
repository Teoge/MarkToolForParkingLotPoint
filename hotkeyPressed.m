function hotkeyPressed( hObject, eventdata )
%HOTKEYPRESSED Respond the keyboard press event
%   Detailed explanation goes here
handles = guidata(hObject);
if ~handles.readSuccess
    return;
end
if handles.focusMode
    step = 0.1;
else
    step = 1;
end
if strcmp(get(gcf, 'CurrentCharacter'),'1')
    set(handles.AxesImage, 'xlim', [0.5, handles.imageWidth + 0.5], 'ylim', [0.5, handles.imageHeight + 0.5]);
    handles.focusMode = false;
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'2')
    cursorPoint = get(handles.AxesImage, 'CurrentPoint');
    curX = cursorPoint(1,1);
    curY = cursorPoint(1,2);
    xLimits = get(handles.AxesImage, 'xlim');
    yLimits = get(handles.AxesImage, 'ylim');
    if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
        set(handles.AxesImage, 'xlim', [curX-120,curX+120], 'ylim', [curY-120,curY+120]);
        handles.focusMode = true;
    end
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'3')
    cursorPoint = get(handles.AxesImage, 'CurrentPoint');
    curX = cursorPoint(1,1);
    curY = cursorPoint(1,2);
    xLimits = get(handles.AxesImage, 'xlim');
    yLimits = get(handles.AxesImage, 'ylim');
    if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
        set(handles.AxesImage, 'xlim', [curX-40,curX+40], 'ylim', [curY-40,curY+40]);
        handles.focusMode = true;
    end
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'w') && handles.mouseReleased && ~handles.creatingPoint
    handles.markingPointList.ShiftPointPosition(0, -step);
    handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'a') && handles.mouseReleased && ~handles.creatingPoint
    handles.markingPointList.ShiftPointPosition(-step, 0);
    handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'s') && handles.mouseReleased && ~handles.creatingPoint
    handles.markingPointList.ShiftPointPosition(0, step);
    handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'d') && handles.mouseReleased && ~handles.creatingPoint
    handles.markingPointList.ShiftPointPosition(step, 0);
    handles.slotList.Replot(handles.markingPointList.markingPoints, handles.imageWidth);
    guidata(hObject, handles);
elseif strcmp(get(gcf, 'CurrentCharacter'),'e')
    main('SaveMark_Callback', handles.SaveMark, eventdata, handles);
elseif double(get(gcf, 'CurrentCharacter'))==29
    main('LoadNextImage_Callback', hObject, eventdata, handles);
elseif double(get(gcf, 'CurrentCharacter'))==28
    main('LoadLastImage_Callback', hObject, eventdata, handles);
end
end
