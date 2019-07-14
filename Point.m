classdef Point < handle
    %POINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        % plot property
        dot
        circle
        label
        % constant
        radius = 10
    end
    
    methods
        function this = Point(x, y)
            this.x = x;
            this.y = y;
            this.Plot();
        end
        
        function delete(this)
            delete(this.dot);
            delete(this.circle);
            delete(this.label);
        end
        
        function Plot(this)
            this.dot = plot(this.x, this.y, 'b.', 'MarkerSize', 5);
            
            theta = linspace(0,2*pi);
            X = this.radius*cos(theta) + this.x;
            Y = this.radius*sin(theta) + this.y;
            this.circle = plot(X, Y, 'r', 'LineWidth', 1);
            
            this.label = text(this.x+this.radius, this.y+this.radius, '', 'Color', 'blue');
        end
        
        function Set(this, x, y)
            diffX = x - this.x;
            diffY = y - this.y;
            this.dot.XData = this.dot.XData + diffX;
            this.dot.YData = this.dot.YData + diffY;
            this.circle.XData = this.circle.XData + diffX;
            this.circle.YData = this.circle.YData + diffY;
            this.x = x;
            this.y = y;
            this.label.Position(1) = this.x + this.radius;
            this.label.Position(2) = this.y + this.radius;
        end
        
        function Shift(this, x, y)
            this.dot.XData = this.dot.XData + x;
            this.dot.YData = this.dot.YData + y;
            this.circle.XData = this.circle.XData + x;
            this.circle.YData = this.circle.YData + y;
            this.x = this.x + x;
            this.y = this.y + y;
            this.label.Position(1) = this.x + this.radius;
            this.label.Position(2) = this.y + this.radius;
        end
        
        function SetLabel(this, label)
            this.label.String = num2str(label);
        end
        
        function Boldify(this)
            this.circle.LineWidth = 2;
            this.label.FontWeight = 'bold';
        end
        
        function Deboldify(this)
            this.circle.LineWidth = 1;
            this.label.FontWeight = 'normal';
        end
    end
    
end

