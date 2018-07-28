classdef SlotList < handle
    %SLOTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        slots = []
        mkpoints = []
        slotPlots = []
    end
    
    methods
        function this = SlotPlotter(slotTable)
            this.updateSlotsFromTable(slotTable)
        end
        
        function updateSlotsFromTable(this, slotTable)
            slotTable(any(cellfun(@isempty, slotTable),2),:) = [];
            slotTable(any(cellfun(@isnan, slotTable),2),:) = [];
            this.slots = cell2mat(slotTable);
        end
        
        function msg = plotSlots(this, markingPoints, imageSize)
            if imageSize == 600
                VerticalSlotMin = 125;
                VerticalSlotMax = 200;
                HorizentalSlotMin = 232;
                HorizentalSlotMax = 401;
            elseif imageSize == 416
                VerticalSlotMin = 86;
                VerticalSlotMax = 139;
                HorizentalSlotMin = 160;
                HorizentalSlotMax = 279;
            else
                return;
            end
            for i = 1:size(this.slots, 1)
                if this.slots(i,1) > length(markingPoints) || this.slots(i,2) > length(markingPoints)
                    msg = 'Invalid Point in Table';
                    return;
                end
                x1 = markingPoints(this.slots(i,1)).startX;
                y1 = markingPoints(this.slots(i,1)).startY;
                x2 = markingPoints(this.slots(i,2)).startX;
                y2 = markingPoints(this.slots(i,2)).startY;
                distance = sqrt((x1-x2)^2 + (y1-y2)^2);

                if distance < VerticalSlotMin || distance > HorizentalSlotMax
                    msg = 'Invalid Slot in Table';
                    return;
                end
                %radian = 1.16937 angle = 67
                switch this.slots(i, 3)
                    case 1
                        if this.slots(i, 4) ~= 90
                            msg = 'Invalid Slot in Table';
                            return;
                        end
                        if distance < (VerticalSlotMax + HorizentalSlotMin) / 2
                            sideLength = 280;
                        else
                            sideLength = 120;
                        end
                        vec = [x2-x1, y2-y1]*[0, -1; 1, 0];
                        vec = vec / norm(vec);
                    case 2
                        if this.slots(i, 4) <= 0 || this.slots(i, 4) >= 90
                            msg = 'Invalid Slot in Table';
                            return;
                        end
                        rad = deg2rad(this.slots(i, 4));
                        vec = [x2-x1, y2-y1]*[cos(rad), -sin(rad); sin(rad), cos(rad)];
                        vec = vec / norm(vec);
                        sideLength = 280 / sin(rad);
                    case 3
                        if this.slots(i, 4) <= 0 || this.slots(i, 4) >= 90
                            msg = 'Invalid Slot in Table';
                            return;
                        end
                        rad = deg2rad(this.slots(i, 4));
                        vec = [x2-x1, y2-y1]*[-cos(rad), -sin(rad); sin(rad), -cos(rad)];
                        vec = vec / norm(vec);
                        sideLength = 280 / sin(rad);
                    otherwise
                        msg = 'Invalid Slot in Table';
                        return;
                end
                this.slotPlots = [this.slotPlots;...
                    plot([x1+vec(1)*sideLength, x1, x2, x2+vec(1)*sideLength], ...
                    [y1+vec(2)*sideLength, y1, y2, y2+vec(2)*sideLength], 'k', 'LineWidth', 1)];
                msg = '';
            end
        end
        
        function msg = RePlot(this, slotTable, markingPoints, imageSize)
            delete(this.slotPlots(:));
            this.slotPlots(:) = [];
            this.updateSlotsFromTable(slotTable);
            msg = this.plotSlots(markingPoints, imageSize);
        end
    end
    
end



