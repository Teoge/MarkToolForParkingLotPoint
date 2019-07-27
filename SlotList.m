classdef SlotList < handle
    %SLOTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        slotTable = []  % handle reference to ui table
        slotInfo = []   % handle reference to text ui of table
        slots
        slotPlots = []
    end
    
    methods
        % public:
        function this = SlotList(slotTable, slotInfo)
            this.slotTable = slotTable;
            this.slotInfo = slotInfo;
        end
        
        function Initialize(this, slots, points, imageSize)
            this.slots = slots;
            this.PlotSlots(points, imageSize);
            
            slotsCell = num2cell(slots);
            slotsCell{16,5} = [];
            set(this.slotTable, 'data', slotsCell(1:15, 1:4));
            this.autoFillTable();
        end
        
        function UpdateSlotsFromTable(this)
            this.autoFillTable();
            slotsCell = get(this.slotTable, 'data');
            slotsCell(any(cellfun(@isempty, slotsCell),2),:) = [];
            slotsCell(any(cellfun(@isnan, slotsCell),2),:) = [];
            this.slots = cell2mat(slotsCell);
        end
        
        function Replot(this, points, imageSize)
            delete(this.slotPlots);
            this.slotPlots = [];
            this.PlotSlots(points, imageSize);
        end
        
        % private:
        function autoFillTable(this)
            slotsCell = get(this.slotTable, 'data');
            for i = 1 : size(slotsCell, 1)
                valueExist = false;
                for j = 1 : size(slotsCell, 2)
                    if ~isempty(slotsCell{i, j})
                        valueExist = true;
                        break;
                    end
                end
                if valueExist
                    if isempty(slotsCell{i, 3})
                        slotsCell{i, 3} = 1;
                    end
                    if isempty(slotsCell{i, 4})
                        slotsCell{i, 4} = 90;
                    end
                end
            end
            set(this.slotTable, 'data', slotsCell(1:15, 1:4));
        end
        
        function PlotSlots(this, points, imageSize)
            MidianSlotLength = imageSize * 0.360145135816851225;
            ParallelSeparatorLength = imageSize * 0.20;
            PerpendicularSeparatorLength = imageSize * 0.53;
            for i = 1:size(this.slots, 1)
                if this.slots(i,1) > length(points) || this.slots(i,2) > length(points)
                    set(this.slotInfo, 'String', 'Invalid Slot in Table');
                    return;
                end
                x1 = points(this.slots(i,1)).x;
                y1 = points(this.slots(i,1)).y;
                x2 = points(this.slots(i,2)).x;
                y2 = points(this.slots(i,2)).y;
                distance = sqrt((x1-x2)^2 + (y1-y2)^2);

                switch this.slots(i, 3)
                    case 1
                        if this.slots(i, 4) ~= 90
                            set(this.slotInfo, 'String', 'Invalid Slot in Table');
                            return;
                        end
                        if distance < MidianSlotLength
                            sideLength = PerpendicularSeparatorLength;
                        else
                            sideLength = ParallelSeparatorLength;
                        end
                        vec = [x2-x1, y2-y1]*[0, -1; 1, 0];
                        vec = vec / norm(vec);
                    case {2, 3}
                        if this.slots(i, 3) == 2
                            if this.slots(i, 4) >= 90 || this.slots(i, 4) <= 0
                                set(this.slotInfo, 'String', 'Invalid Slot in Table');
                                return;
                            end
                        else
                            if this.slots(i, 4) >= 180 || this.slots(i, 4) <= 90
                                set(this.slotInfo, 'String', 'Invalid Slot in Table');
                                return;
                            end
                        end
                        rad = deg2rad(this.slots(i, 4));
                        vec = [x2-x1, y2-y1]*[cos(rad), -sin(rad); sin(rad), cos(rad)];
                        vec = vec / norm(vec);
                        sideLength = PerpendicularSeparatorLength / sin(rad);
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



