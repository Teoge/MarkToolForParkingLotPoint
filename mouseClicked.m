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
        actionCreate = true;
        for i = 1:size(handles.marks, 1)
            if norm(handles.marks(i, :) - [curX, curY]) < 10
                actionCreate = false;
                handles.moving = i;
                handles.selected = handles.moving;
                set(handles.SelectedMark, 'String', num2str(handles.selected));
                handles.movingOffset = handles.marks(i, :) - [curX, curY];
                break;
            end
        end
        if actionCreate
            handles.marks = [handles.marks; [curX, curY]];
            handles = plotMarks(handles, size(handles.marks,1));
            handles.moving = size(handles.marks,1);
            handles.selected = handles.moving;
            set(handles.SelectedMark, 'String', num2str(handles.selected));
            handles.movingOffset = [0, 0];
        end
    elseif strcmp(get(gcf,'selectionType'), 'alt')
        for i = 1:size(handles.marks, 1)
            if norm(handles.marks(i, :) - [curX, curY]) < 10
                handles.marks(i, :) = [];
                delete(handles.markPlots(i, :));
                handles.markPlots(i, :) = [];
                for j = i:size(handles.marks, 1)
                    delete(handles.markPlots(j, 1));
                    handles.markPlots(j, 1) = text(handles.marks(j, 1)+10, handles.marks(j, 2)+10, ...
                        num2str(j),'Color','blue');
                end
                if handles.selected == i
                    handles.selected = 0;
                elseif handles.selected > i
                    handles.selected = handles.selected - 1;
                end
                set(handles.SelectedMark, 'String', num2str(handles.selected));
                break;
            end
        end
    elseif strcmp(get(gcf,'selectionType'), 'extend')
        if handles.moving ~= 0
            i = handles.moving;
            handles.moving = 0;
            handles.marks(i, :) = [];
            delete(handles.markPlots(i, :));
            handles.markPlots(i, :) = [];
            for j = i:size(handles.marks, 1)
                delete(handles.markPlots(j, 1));
                handles.markPlots(j, 1) = text(handles.marks(j, 1)+10, handles.marks(j, 2)+10, ...
                    num2str(j),'Color','blue');
            end
            handles.selected = 0;
            set(handles.SelectedMark, 'String', '0');
        end
    end
    guidata(hObject, handles);
end

end