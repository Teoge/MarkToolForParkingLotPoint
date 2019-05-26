function handles = drawSlots( handles, slots, marks )
%DRAWSLOTS Draw slots
%   Detailed explanation goes here
if handles.imageWidth == 600
    VerticalSlotMin = 125;
    VerticalSlotMax = 200;
    HorizentalSlotMin = 232;
    HorizentalSlotMax = 401;
elseif handles.imageWidth == 416
    VerticalSlotMin = 86;
    VerticalSlotMax = 139;
    HorizentalSlotMin = 160;
    HorizentalSlotMax = 279;
else
    return;
end
for i = 1:size(slots,1)
    if slots(i,1)>size(marks,1)||slots(i,2)>size(marks,1)
        set(handles.TableInfo, 'String', 'Invalid Point in Table');
        continue;
    end
    x1 = marks(slots(i,1),1);
    y1 = marks(slots(i,1),2);
    x2 = marks(slots(i,2),1);
    y2 = marks(slots(i,2),2);
    distance = sqrt((x1-x2)^2 + (y1-y2)^2);

    if distance < VerticalSlotMin || distance > HorizentalSlotMax
        set(handles.TableInfo, 'String', 'Invalid Slot in Table');
        continue;
    end
    %radian = 1.16937 angle = 67
    switch slots(i, 3)
        case 1
            if slots(i, 4) ~= 90
                set(handles.TableInfo, 'String', 'Invalid Slot in Table');
                continue;
            end
            if distance < (VerticalSlotMax + HorizentalSlotMin) / 2
                sideLength = 280;
            else
                sideLength = 120;
            end
            vec = [x2-x1, y2-y1]*[0, -1; 1, 0];
            vec = vec / norm(vec);
        case {2, 3}
            if slots(i, 4) <= 0
                set(handles.TableInfo, 'String', 'Invalid Slot in Table');
                continue;
            end
            rad = deg2rad(slots(i, 4));
            vec = [x2-x1, y2-y1]*[cos(rad), -sin(rad); sin(rad), cos(rad)];
            vec = vec / norm(vec);
            sideLength = 280 / sin(rad);
        otherwise
            set(handles.TableInfo, 'String', 'Invalid Slot Type in Table');
            continue;
    end
    handles.markLines = [handles.markLines;...
        plot([x1+vec(1)*sideLength, x1, x2, x2+vec(1)*sideLength], ...
        [y1+vec(2)*sideLength, y1, y2, y2+vec(2)*sideLength], 'k', 'LineWidth', 1)];
    set(handles.TableInfo, 'String', '');
end

end

