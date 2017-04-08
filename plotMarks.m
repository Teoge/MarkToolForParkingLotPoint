function handles = plotMarks(handles, index)
%PLOTMARKS Summary of this function goes here
%   Detailed explanation goes here
curX = handles.marks(index, 1);
curY = handles.marks(index, 2);
theta = linspace(0,2*pi);
x = 10*cos(theta) + curX;
y = 10*sin(theta) + curY;
handles.markPlots(index, :) = ...
    [text(curX+10, curY+10, num2str(index), 'Color', 'blue'), ...
    plot(curX, curY, 'b.', 'MarkerSize', 5), ...
    plot(x, y, 'r', 'LineWidth', 1)];
end

