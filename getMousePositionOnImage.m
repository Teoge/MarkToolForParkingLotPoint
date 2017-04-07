function getMousePositionOnImage(src, event)

handles = guidata(src);
if ~handles.readSuccess
    return;
end
cursorPoint = get(handles.AxesImage, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);

xLimits = get(handles.AxesImage, 'xlim');
yLimits = get(handles.AxesImage, 'ylim');

if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
    %disp(['Cursor coordinates are (' num2str(curX) ', ' num2str(curY) ').']);
    hold on;
    if strcmp(get(handles.figure1,'selectionType'), 'normal')
        handles.marks = [handles.marks; [curX, curY]];
        theta = linspace(0,2*pi);
        x = 10*cos(theta) + curX;
        y = 10*sin(theta) + curY;
        handles.markPlots = [handles.markPlots; [plot([curX-20,curX+20], [curY,curY], 'b'), plot([curX,curX], [curY-20,curY+20], 'b'), plot(x,y,'r','LineWidth',1), text(curX+10,curY+10,num2str(size(handles.marks,1)),'Color','blue')]];
    elseif strcmp(get(handles.figure1,'selectionType'), 'alt')
        for i = 1:size(handles.marks, 1)
            if norm(handles.marks(i, :) - [curX, curY]) < 10
                handles.marks(i, :) = [];
                delete(handles.markPlots(i, :));
                handles.markPlots(i, :) = [];
                for j = i:size(handles.marks, 1)
                    delete(handles.markPlots(j, 3));
                    handles.markPlots(j, 3) = text(handles.marks(j, 1)+10,handles.marks(j, 2)+10,num2str(j),'Color','blue');
                end
                break;
            end
        end
    end
    guidata(src, handles);
end

end