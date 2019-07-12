classdef SlotList < handle
    %SLOTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        slotTable = []  % handle reference to ui table
        slotInfo = []   % handle reference to text ui of table
        slots
        slotPlots = []
        showPlot = false
    end
    
    methods
        function this = SlotList(slotTable, slotInfo)
            this.slotTable = slotTable;
            this.slotInfo = slotInfo;
        end
        
        function Initialize(this, slots, markingPoints, imageSize)
            % TODO: add default value
            this.slots = slots;
            if this.showPlot
                this.PlotSlots(markingPoints, imageSize);
            end
            
            slotsCell = num2cell(slots);
            slotsCell{16,5} = [];
            %slotsCell(:,3) = {1};
            %slotsCell(:,4) = {90};
            set(this.slotTable, 'data', slotsCell(1:15, 1:4));
        end
        
        function ShowPlot(this, markingPoints, imageSize)
            this.showPlot = true;
            this.PlotSlots(markingPoints, imageSize);
        end
        
        function HidePlot(this)
            this.showPlot = false;
            delete(this.slotPlots);
            this.slotPlots = [];
        end
        
        function Replot(this, markingPoints, imageSize)
            if ~this.showPlot
                return
            end
            delete(this.slotPlots);
            this.slotPlots = [];
            this.PlotSlots(markingPoints, imageSize);
        end
        
        function UpdateSlotsFromTable(this)
            % TODO: add default value
            slotCell = get(this.slotTable, 'data');
            slotCell(any(cellfun(@isempty, slotCell),2),:) = [];
            slotCell(any(cellfun(@isnan, slotCell),2),:) = [];
            this.slots = cell2mat(slotCell);
        end
        
        function PlotSlots(this, markingPoints, imageSize)
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
                    set(this.slotInfo, 'String', 'Invalid Slot in Table');
                    return;
                end
                x1 = markingPoints(this.slots(i,1)).src.x;
                y1 = markingPoints(this.slots(i,1)).src.y;
                x2 = markingPoints(this.slots(i,2)).src.x;
                y2 = markingPoints(this.slots(i,2)).src.y;
                distance = sqrt((x1-x2)^2 + (y1-y2)^2);

                if distance < VerticalSlotMin || distance > HorizentalSlotMax
                    set(this.slotInfo, 'String', 'Invalid Slot in Table');
                    return;
                end
                switch this.slots(i, 3)
                    case 1
                        if this.slots(i, 4) ~= 90
                            set(this.slotInfo, 'String', 'Invalid Slot in Table');
                            return;
                        end
                        if distance < (VerticalSlotMax + HorizentalSlotMin) / 2
                            sideLength = 280;
                        else
                            sideLength = 120;
                        end
                        vec = [x2-x1, y2-y1]*[0, -1; 1, 0];
                        vec = vec / norm(vec);
                    case {2, 3}
                        if this.slots(i, 4) <= 0
                            set(this.slotInfo, 'String', 'Invalid Slot in Table');
                            return;
                        end
                        rad = deg2rad(this.slots(i, 4));
                        vec = [x2-x1, y2-y1]*[cos(rad), -sin(rad); sin(rad), cos(rad)];
                        vec = vec / norm(vec);
                        sideLength = 280 / sin(rad);
                    otherwise
                        set(this.slotInfo, 'String', 'Invalid Slot in Table');
                        return;
                end
                this.slotPlots = [this.slotPlots;...
                    plot([x1+vec(1)*sideLength, x1, x2, x2+vec(1)*sideLength], ...
                    [y1+vec(2)*sideLength, y1, y2, y2+vec(2)*sideLength], 'k', 'LineWidth', 1)];
                set(this.slotInfo, 'String', '');
            end
        end
    end
    
end



