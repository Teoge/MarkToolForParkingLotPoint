classdef MarkingPointList < handle
    %MARKINGPOINTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        markingPoints
        seletedPoint = []
        % First number: index in variable 'markingPoints'.
        % Second number: 1 means the src point, 2 means the dest point.
        seletedPointIndex = [0, 0]
        pointForCreate = []
    end
    
    methods
        function this = MarkingPointList(marks)
            if isempty(marks)
                return
            end
            if size(marks, 2) < 5
                marks = [marks, zeros(size(marks, 1), 5 - size(marks, 2))];
            end
            for i = size(marks, 1)
                mkpoint = MarkingPoint(marks(i, :));
                this.markingPoints = [markingPoints; mkpoint];
                mkpoint.SetLabel(i);
            end
        end

        function selectPoint(this, index, type)
            if ~isempty(this.seletedPoint)
                this.seletedPoint.Deboldify();
            end
            this.seletedPointIndex = [index, type];
            if index == 0 && type == 0
                this.seletedPoint = this.pointForCreate;
            else
                if type == 1
                    this.seletedPoint = this.markingPoints(index).src;
                elseif type == 2
                    this.seletedPoint = this.markingPoints(index).dest;
                end
            end
            this.seletedPoint.Boldify();
        end
        
        function found = FindPointInRange(this, x, y)
            found = false;
            for i = 1 : length(this.markingPoints)
                px = this.markingPoints(i).src.x;
                py = this.markingPoints(i).src.y;
                radius = this.markingPoints(i).src.radius;
                if norm([px - x, py - y]) < radius
                    this.selectPoint(i, 1);
                    found = true;
                    return;
                end
                px = this.markingPoints(i).dest.x;
                py = this.markingPoints(i).dest.y;
                radius = this.markingPoints(i).dest.radius;
                if norm([px - x, py - y]) < radius
                    this.selectPoint(i, 2);
                    found = true;
                    return;
                end
            end
        end
        
        function FindPointInRangeOrCreate(this, x, y)
            if(~this.FindPointInRange(x, y))
                this.pointForCreate = Point(x, y);
                this.selectPoint(0, 0);
            end
        end
        
        function FindPointInRangeToDelete(this, x, y)
            if(this.FindPointInRange(x, y))
                this.DeleteMarkingPoint();
            end
        end
        
        function CancelPointCreation(this)
            delete(this.pointForCreate);
            this.pointForCreate = [];
            this.selectPoint(0, 0);
        end
        
        function AddMarkingPoint(this, x, y)
            if isempty(this.pointForCreate)
                return
            end
            mkpoint = MarkingPoint(this.pointForCreate, Point(x, y), 0);
            this.markingPoints = [this.markingPoints; mkpoint];
            mkpoint.SetLabel(length(this.markingPoints));
            this.pointForCreate = [];
            this.selectPoint(length(this.markingPoints), 2);
        end
        
        function SetPointPosition(this, x, y)
            if this.seletedPoint == this.pointForCreate
                this.seletedPoint.Set(x, y);
            else
                if this.seletedPointIndex(2) == 1
                    this.markingPoints(this.seletedPointIndex(1)).SetSrc(x, y);
                elseif this.seletedPointIndex(2) == 2
                    this.markingPoints(this.seletedPointIndex(1)).SetDest(x, y);
                end
            end
        end
        
        function SetMarkingPointType(this, type)
            if this.seletedPointIndex(1) ~= 0
                this.markingPoints(this.seletedPointIndex(1)).SetType(type);
            end
        end
        
        function DeleteMarkingPoint(this)
            if this.seletedPointIndex(1) ~= 0
                return;
            end
            delete(this.markingPoints(this.seletedPointIndex(1)));
            this.markingPoints(this.seletedPointIndex(1)) = [];
            for i = this.seletedPointIndex(1) : length(this.markingPoints)
                this.markingPoints(i).SetLabel(i);
            end
            this.selectPoint(0, 0);
        end
    end
    
end

