classdef PointList < handle
    %MARKINGPOINTLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        points
        % assign value only by selectPoint function
        seletedPoint = [] % reference to selected point, [] means non selected
        seletedPointIndex = 0  % index of selected point, 0 means non selected
        showSelected  % GUI text showing seletedPointIndex
    end
    
    methods
        % public:
        function this = PointList(marks, showSelected)
            if isempty(marks)
                return
            end
            for i = 1:size(marks, 1)
                point = Point(marks(i, 1), marks(i, 2));
                this.points = [this.points; point];
                point.SetLabel(i);
            end
            this.showSelected = showSelected;
            this.selectPoint(0);
        end
        
        function marks = ToVector(this)
            marks = zeros(length(this.points), 2);
            for i = 1:size(marks, 1)
                marks(i, :) = [this.points(i).x, this.points(i).y];
            end
        end
        
        function found = FindPointInRange(this, x, y)
            found = false;
            for i = 1 : length(this.points)
                px = this.points(i).x;
                py = this.points(i).y;
                radius = this.points(i).radius;
                if norm([px - x, py - y]) < radius
                    this.selectPoint(i);
                    found = true;
                    return;
                end
            end
        end
        
        function DeselectIfNotInRange(this, x1, y1, x2, y2)
            if isempty(this.seletedPoint)
                return;
            end
            x = this.seletedPoint.x;
            y = this.seletedPoint.y;
            if x < x1 || x > x2 || y < y1 || y > y2
                this.selectPoint(0);
            end
        end
        
        function [x, y] = GetSelectedPostion(this)
            if isempty(this.seletedPoint)
                x = 0;
                y = 0;
                return;
            end
            x = this.seletedPoint.x;
            y = this.seletedPoint.y;
        end
        
        function AddPoint(this, x, y)
            creatingPoint = Point(x, y);
            this.points = [this.points; creatingPoint];
            creatingPoint.SetLabel(length(this.points));
            this.selectPoint(length(this.points));
        end
        
        function SetPointPosition(this, x, y)
            if ~isempty(this.seletedPoint)
                this.seletedPoint.Set(x, y);
            end
        end
        
        function ShiftPointPosition(this, x, y)
            if ~isempty(this.seletedPoint)
                this.seletedPoint.Shift(x, y);
            end
        end
        
        function DeletePoint(this)
            if this.seletedPointIndex ~= 0
                delete(this.points(this.seletedPointIndex));
                this.points(this.seletedPointIndex) = [];
                for i = this.seletedPointIndex : length(this.points)
                    this.points(i).SetLabel(i);
                end
            end
            this.selectPoint(0);
        end
        
        % private:
        function selectPoint(this, index)
            this.seletedPointIndex = index;
            set(this.showSelected, 'String', num2str(index));
            if ~isempty(this.seletedPoint) && isvalid(this.seletedPoint)
                this.seletedPoint.Deboldify();
            end
            if index == 0
                this.seletedPoint = [];
            else
                this.seletedPoint = this.points(index);
                this.seletedPoint.Boldify();
            end
        end
    end
    
end

