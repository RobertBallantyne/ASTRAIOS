clear 
clc
fclose('all')
close all
tic
target = tle_read('tle1');
object = tle_read('tle2');

global mu_Earth

mu_Earth = 3.986004418 * 10^14; %GM for the earth

position_target3d = plot_kep3d(target(2), target(3), target(4), target(5), target(8));
position_object3d = plot_kep3d(object(2), object(3), object(4), object(5), object(8));
% Plots the orbits onto a 2d frame then rotates them appropriately
% depending on orbital elements

projection_target3d = zeros(length(position_target3d(:, 1)), length(position_target3d(1, :)));
projection_object3d = zeros(length(position_target3d(:, 1)), length(position_target3d(1, :)));

if object(7) < target(7)
    plane_target = planefit(position_object3d);
else
    plane_target = planefit(position_target3d);
end
% Fits a plane to a set of points, the plane depends on which orbit is
% at a higher altitude (if its higher it will have a larger mean motion)

coefficients = coeffs(plane_target);
% Function takes out the coefficients of a symbolic function

a = double(coefficients(4));
b = double(coefficients(3));
c = double(coefficients(2));
d = double(coefficients(1));

for i = 1:length(position_target3d(1, :)) 
    [projection_target3d(1, i), projection_target3d(2, i), projection_target3d(3, i)] = proj_plane(a, b, c, d, position_target3d(1, i), position_target3d(2, i), position_target3d(3, i));
    [projection_object3d(1, i), projection_object3d(2, i), projection_object3d(3, i)] = proj_plane(a, b, c, d, position_object3d(1, i), position_object3d(2, i), position_object3d(3, i));
end 
% Projects both onto the desired plane, does both as you dont know which
% will be chosen beforehand 

for i = 1:length(position_target3d(1, :))
    [projection_targetxy(1, i), projection_targetxy(2, i), projection_targetxy(3, i)] = proj_plane(0, 0, 1, 0, projection_target3d(1, i), projection_target3d(2, i), projection_target3d(3, i));
    [projection_objectxy(1, i), projection_objectxy(2, i), projection_objectxy(3, i)] = proj_plane(0, 0, 1, 0, projection_object3d(1, i), projection_object3d(2, i), projection_object3d(3, i));
end
% Projects the projections onto the xy plane so that it becomes a 2d problem

figure

tab1 = uitab('title', '3D plot');
ax1 = axes(tab1);
plot3(ax1, position_target3d(1, :), position_target3d(2, :), position_target3d(3, :))
hold on
plot3(ax1, position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))
hold off

tab2 = uitab('title', 'First Projection');
ax2 = axes(tab2);
plot3(ax2, projection_target3d(1, :), projection_target3d(2, :), projection_target3d(3, :))
hold on
plot3(ax2, projection_object3d(1, :), projection_object3d(2, :), projection_object3d(3, :))
hold off

tab3 = uitab('title', 'XY projection');
ax3 = axes(tab3);
plot3(ax3, projection_targetxy(1, :), projection_targetxy(2, :), projection_targetxy(3, :))
hold on
plot3(ax3, projection_objectxy(1, :), projection_objectxy(2, :), projection_objectxy(3, :))
hold off

target_samples = randsample(length(projection_objectxy(1, :)), 10);
object_samples = randsample(length(projection_objectxy(1, :)), 10); 

coeffs_target = ellipsefit(projection_targetxy(1:2, :));
coeffs_object = ellipsefit(projection_objectxy(1:2, :));
% 
% line = polyval(coeffs_object, projection_objectxy(1, :));
% figure
% plot(projection_objectxy(1, :), projection_objectxy(2, :))
% hold on
% plot(projection_targetxy(1, :), projection_targetxy(2, :))
syms x y
target_eqn = coeffs_target(1)*x^2 + coeffs_target(2)*x*y + coeffs_target(3)*y^2 + coeffs_target(4)*x + coeffs_target(5)*y + coeffs_target(6);
object_eqn = coeffs_object(1)*x^2 + coeffs_object(2)*x*y + coeffs_object(3)*y^2 + coeffs_object(4)*x + coeffs_object(5)*y + coeffs_target(6);

xmax = 1.1*max([projection_targetxy(1, :) projection_objectxy(1, :) abs(min([projection_targetxy(1, :) projection_objectxy(1, :)]))]);
xmin = -xmax;

tab4 = uitab('title', 'Ellipse fit, 2D');
ax4 = axes(tab4);
fimplicit(ax4, target_eqn, [xmin xmax])
hold on
fimplicit(ax4, object_eqn, [xmin xmax])

intersection = solve([target_eqn, object_eqn], [x y]);

X = double(intersection.x);
Y = double(intersection.y);
mask = ~any(imag(X), 2) | ~any(imag(Y), 2);
X_rl = X(mask);
Y_rl = Y(mask);
toc




