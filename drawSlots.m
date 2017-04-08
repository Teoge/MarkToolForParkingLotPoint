function handles = drawSlots( handles, slots, marks )
%DRAWSLOTS Summary of this function goes here
%   Detailed explanation goes here
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
    handles.markLines = [handles.markLines;...
        plot([x1+vec(1)*sideLength, x1, x2, x2+vec(1)*sideLength], ...
        [y1+vec(2)*sideLength,y1,y2,y2+vec(2)*sideLength], 'k', 'LineWidth', 1)];
    set(handles.TableInfo, 'String', '');
end

end

