xCenter = 0;
yCenter = 0;
xRadius = 4;
yRadius = 3;
theta = 0 : 0.01 : 2*pi;
x = xRadius * cos(theta) + xCenter;
y = yRadius * sin(theta) + yCenter;
plot(x, y, 'b');
axis square;
axis equal;
xlim([-5, 5])
ylim([-5, 5])
grid on;
hold on
plot(1, 0, '.g', 'MarkerSize',200)
xRadius2 = 4.5;
yRadius2 = 4.5;
x2 = xRadius2 * cos(theta) + xCenter;
y2 = yRadius2 * sin(theta) + yCenter;
plot(x2, y2, 'r');