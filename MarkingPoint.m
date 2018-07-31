classdef MarkingPoint < handle
    %MARKINGPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        src
        dest
        type = 0  % 0 represents T and 1 represents L
        % plot properties
        separator
        bridge
        label
    end
    
    methods
        function this = MarkingPoint(varargin)
            assert(nargin == 1 || nargin == 2)
            if nargin == 1
                vector = varargin{1}(:);
                assert(length(vector) == 5);
                this.src = Point(vector(1), vector(2));
                this.dest = Point(vector(3), vector(4));
                this.type = vector(5);
                assert(this.type==0 || this.type==1);
                this.Plot();
            else
                this.src = Point(varargin{1}, varargin{2});
            end
        end
        
        function DelayConstruct(this, x, y)
            this.dest = Point(x, y);
            this.Plot();
        end
        
        function delete(this)
            delete(this.src);
            delete(this.dest);
            delete(this.separator);
            delete(this.bridge);
            delete(this.label);
        end
        
        function Plot(this)
            vec = [this.dest.x - this.src.x, this.dest.y - this.src.y];
            this.separator = quiver(this.src.x, this.src.y, vec(1), vec(2), 1, 'm', 'LineWidth', 1);
            vec = vec / norm(vec) * this.src.radius;
            if this.type == 0
                X = [this.src.x - vec(2), this.src.x + vec(2)];
                Y = [this.src.y + vec(1), this.src.y - vec(1)];
            elseif this.type == 1
                X = [this.src.x - vec(2), this.src.x];
                Y = [this.src.y + vec(1), this.src.y];
            end
            this.bridge = plot(X, Y, 'm', 'LineWidth', 1);
            this.label = text(this.src.x+this.src.radius, this.src.y+this.src.radius, '', 'Color', 'blue');
        end
        
        function UpdatePlot(this)
            vec = [this.dest.x - this.src.x, this.dest.y - this.src.y];
            this.separator.XData = this.src.x;
            this.separator.YData = this.src.y;
            this.separator.UData = vec(1);
            this.separator.VData = vec(2);
            vec = vec / norm(vec) * this.src.radius;
            if this.type == 0
                X = [this.src.x - vec(2), this.src.x + vec(2)];
                Y = [this.src.y + vec(1), this.src.y - vec(1)];
            elseif this.type == 1
                X = [this.src.x - vec(2), this.src.x];
                Y = [this.src.y + vec(1), this.src.y];
            end
            this.bridge.XData = X;
            this.bridge.YData = Y;
            this.label.Position(1) = this.src.x + this.src.radius;
            this.label.Position(2) = this.src.y + this.src.radius;
        end
        
        function SetSrc(this, x, y)
            this.src.Set(x, y);
            this.UpdatePlot();
        end
        
        function ShiftSrc(this, x, y)
            this.src.Shift(x, y);
            this.UpdatePlot();
        end
        
        function SetDest(this, x, y)
            this.dest.Set(x, y);
            this.UpdatePlot();
        end
        
        function ShiftDest(this, x, y)
            this.dest.Shift(x, y);
            this.UpdatePlot();
        end
        
        function SetType(this, type)
            assert(type==0 || type==1);
            if this.type ~= type
                this.type = type;
                this.UpdatePlot();
            end
        end
        
        function SetLabel(this, label)
            this.label.String = num2str(label);
        end
        
        function vector = ToVector(this)
            vector = [this.src.x, this.src.y, this.dest.x, this.dest.y, this.type];
        end
    end
    
end

