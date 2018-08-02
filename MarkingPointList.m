classdef MarkingPointList < handle
    %MARKINGPOINTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        markingPoints
        seletedPoint = []
        % First number: index in variable 'markingPoints'.
        % Second number: 1 means the src point, 2 means the dest point.
        seletedPointIndex = [0, 0]
        mkPointForCreate = []
    end
    
    methods
        function this = MarkingPointList(marks)
            if isempty(marks)
                return
            end
            if size(marks, 2) == 2
                marks = [marks, marks + 10, zeros(size(marks, 1), 1)];
            end
            for i = 1:size(marks, 1)
                mkpoint = MarkingPoint(marks(i, :));
                this.markingPoints = [this.markingPoints; mkpoint];
                mkpoint.SetLabel(i);
            end
        end
        
        function marks = ToVector(this)
            marks = zeros(length(this.markingPoints), 5);
            for i = 1:size(marks, 1)
                marks(i, :) = this.markingPoints(i).ToVector();
            end
        end

        function selectPoint(this, index, type)
            if ~isempty(this.seletedPoint)
                this.seletedPoint.Deboldify();
            end
            this.seletedPointIndex = [index, type];
            if type == 0
                this.seletedPoint = [];
                return;
            end
            if index == 0
                if type == 1
                    this.seletedPoint = this.mkPointForCreate.src;
                elseif type == 2
                    this.seletedPoint = this.mkPointForCreate.dest;
                end
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
        
        function [x, y, type] = GetSelectedInfo(this)
            x = 0;
            y = 0;
            type = 0;
            if this.seletedPointIndex(2) == 0
                return;
            end
            x = this.seletedPoint.x;
            y = this.seletedPoint.y;
            if this.seletedPointIndex(1) == 0
                type = this.mkPointForCreate.type;
            else
                type = this.markingPoints(this.seletedPointIndex(1)).type;
            end
        end
        
        function CreatingFirstPoint(this, x, y)
            this.mkPointForCreate = MarkingPoint(x, y);
            this.selectPoint(0, 1);
        end
        
        function CreatingSecondPoint(this, x, y)
            this.mkPointForCreate.DelayConstruct(x, y);
            this.selectPoint(0, 2);
        end
        
        function AddMarkingPoint(this)
            if isempty(this.mkPointForCreate)
                return
            end
            this.markingPoints = [this.markingPoints; this.mkPointForCreate];
            this.mkPointForCreate.SetLabel(length(this.markingPoints));
            this.mkPointForCreate = [];
            this.selectPoint(length(this.markingPoints), 2);
        end
        
        function SetPointPosition(this, x, y)
            if ~isempty(this.mkPointForCreate)
                if this.seletedPoint == this.mkPointForCreate.src
                    this.seletedPoint.Set(x, y);
                elseif this.seletedPoint == this.mkPointForCreate.dest
                    this.mkPointForCreate.SetDest(x, y);
                end
            else
                if this.seletedPointIndex(2) == 1
                    this.markingPoints(this.seletedPointIndex(1)).SetSrc(x, y);
                elseif this.seletedPointIndex(2) == 2
                    this.markingPoints(this.seletedPointIndex(1)).SetDest(x, y);
                end
            end
        end
        
        function ShiftPointPosition(this, x, y)
            if ~isempty(this.mkPointForCreate)
                if this.seletedPoint == this.mkPointForCreate.src
                    this.seletedPoint.Shift(x, y);
                elseif this.seletedPoint == this.mkPointForCreate.dest
                    this.mkPointForCreate.ShiftDest(x, y);
                end
            else
                if this.seletedPointIndex(2) == 1
                    this.markingPoints(this.seletedPointIndex(1)).ShiftSrc(x, y);
                elseif this.seletedPointIndex(2) == 2
                    this.markingPoints(this.seletedPointIndex(1)).ShiftDest(x, y);
                end
            end
        end
        
        function SetMarkingPointType(this, type)
            if this.seletedPointIndex(1) ~= 0
                this.markingPoints(this.seletedPointIndex(1)).SetType(type);
            end
        end
        
        function DeleteMarkingPoint(this)
            if this.seletedPointIndex(1) == 0
                delete(this.mkPointForCreate);
                this.mkPointForCreate = [];
            else
                delete(this.markingPoints(this.seletedPointIndex(1)));
                this.markingPoints(this.seletedPointIndex(1)) = [];
                for i = this.seletedPointIndex(1) : length(this.markingPoints)
                    this.markingPoints(i).SetLabel(i);
                end
            end
            this.seletedPoint = [];
            this.selectPoint(0, 0);
        end
    end
    
end

