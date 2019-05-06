function draw_rectangles(z,x,y, l,w,L,W)
%DRAWRECTANGLES Summary of this function goes here
%   Detailed explanation goes here
dx=0;
axis([0, L, 0 ,W])
for i=1:length(x)
    rectangle('Position',[x(i)+dx, y(i)+dx, l(i)-dx, w(i)-dx], 'EdgeColor', [rand(),rand(),rand()], 'LineWidth', 1)
    hold on
    text( (2*x(i)+l(i))/2, (2*y(i)+w(i))/2, z(i)+"")
end
hold off;