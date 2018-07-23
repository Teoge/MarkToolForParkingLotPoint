classdef MarkingPoint < handle
    %MARKINGPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        startX = 0
        startY = 0
        endX = 0
        endY = 0
        type = 0  % 0 represents T and 1 represents L
        % plot properties
        label
        dot
        circleStart
        circleEnd
        separator
        bridge
        % constant
        radius = 10
    end
    
    methods
        function this = MarkingPoint(vector)
            vector = vector(:);
            if length(vector) < 5
                vector = [vector; zeros(5 - length(vector), 1)];
            end
            assert(vector(5)==0 || vector(5)==1);
            this.startX = vector(1);
            this.startY = vector(2);
            this.endX = vector(3);
            this.endY = vector(4);
            this.type = vector(5);
            this.PlotMarkingPoint();
        end
        
        function PlotMarkingPoint(this)
            this.label = text(this.startX + this.radius, this.startY + this.radius, num2str(index), 'Color', 'blue');
            
            this.separator = quiver(this.startX, this.startY, this.endX, this.endY, 1, 'm' , 'LineWidth', 1);
            
            vec = [this.endX - this.startX, this.endY - this.startY];
            vec = vec / norm(vec) * this.radius;
            if this.type == 0
                X = [this.startX - vec(2), this.startX + vec(2)];
                Y = [this.startY + vec(1), this.startY - vec(1)];
            elseif this.type == 1
                X = [this.startX - vec(2), this.startX];
                Y = [this.startY + vec(1), this.startY];
            end
            this.bridge = plot(X, Y, 'm', 'LineWidth', 1);
            
            this.dot = plot(this.startX, this.startY, 'b.', 'MarkerSize', 5);
            
            theta = linspace(0,2*pi);
            x = this.radius*cos(theta) + this.startX;
            y = this.radius*sin(theta) + this.startY;
            this.circleStart = plot(x, y, 'r', 'LineWidth', 1);
            
            theta = linspace(0,2*pi);
            x = this.radius*cos(theta) + this.endX;
            y = this.radius*sin(theta) + this.endY;
            this.circleStart = plot(x, y, 'r', 'LineWidth', 1);
        end
        
        function RePlot(this)
            delete(this.label);
            delete(this.dot);
            delete(this.circleStart);
            delete(this.circleEnd);
            delete(this.separator);
            delete(this.bridge);
            this.PlotMarkingPoint();
        end
        
        function SetStartPoint(this, x, y)
            this.startX = x;
            this.startY = y;
            this.Replot();
        end
        
        function SetEndPoint(this, x, y)
            this.endX = x;
            this.endY = y;
            this.Replot();
        end
        
        function SetType(this, type)
            assert(type==0 || type==1);
            this.type = type;
        end
        
        function vector = ToVector(this)
            vector = [this.startX, this.startY, this.endX, this.endY, this.type];
        end
    end
    
end

