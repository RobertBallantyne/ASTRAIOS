clear 
clc
fclose('all')
close all

target = tle_read('tle1');
object = tle_read('tle2');

mu_Earth = 3.986004418 * 10^14; %GM for the earth

position_target3d = plot_kep3d(target(2), target(3), target(4), target(5), target(8));
position_object3d = plot_kep3d(object(2), object(3), object(4), object(5), object(8));

projection_target3d = zeros(length(position_target3d(:, 1)), length(position_target3d(1, :)));
projection_object3d = zeros(length(position_target3d(:, 1)), length(position_target3d(1, :)));

plane_target = planefit(position_target3d);

coefficients = coeffs(plane_target);

a = double(coefficients(4));
b = double(coefficients(3));
c = double(coefficients(2));
d = double(coefficients(1));

for i = 1:length(position_target3d(1, :))
    [projection_target3d(1, i), projection_target3d(2, i), projection_target3d(3, i)] = proj_plane(a, b, c, d, position_target3d(1, i), position_target3d(2, i), position_target3d(3, i));
    [projection_object3d(1, i), projection_object3d(2, i), projection_object3d(3, i)] = proj_plane(a, b, c, d, position_object3d(1, i), position_object3d(2, i), position_object3d(3, i));
end

for i = 1:length(position_target3d(1, :))
    [projection_targetxy(1, i), projection_targetxy(2, i), projection_targetxy(3, i)] = proj_plane(0, 0, 1, 0, projection_target3d(1, i), projection_target3d(2, i), projection_target3d(3, i));
    [projection_objectxy(1, i), projection_objectxy(2, i), projection_objectxy(3, i)] = proj_plane(0, 0, 1, 0, projection_object3d(1, i), projection_object3d(2, i), projection_object3d(3, i));
end
% 
% plot3(projection_target3d(1, :), projection_target3d(2, :), projection_target3d(3, :))
% hold on
% plot3(projection_object3d(1, :), projection_object3d(2, :), projection_object3d(3, :))
% hold off
% 
% figure
% plot3(position_target3d(1, :), position_target3d(2, :), position_target3d(3, :))
% hold on
% plot3(position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))
% hold off
% 
figure
plot3(projection_targetxy(1, :), projection_targetxy(2, :), projection_targetxy(3, :))
hold on
plot3(projection_objectxy(1, :), projection_objectxy(2, :), projection_objectxy(3, :))
hold off

target_samples = randsample(length(projection_objectxy(1, :)), 10);
object_samples = randsample(length(projection_objectxy(1, :)), 10); 

ellipse_coeffs_target = ellipsefit(projection_targetxy(1:2, :));
line_coeffs_object = polyfit(projection_objectxy(1, object_samples), projection_objectxy(2, object_samples), 1);

line = polyval(line_coeffs_object, projection_objectxy(1, :));
figure
plot(projection_objectxy(1, :), line)
hold on
plot(projection_targetxy(1, :), projection_targetxy(2, :))
syms x y
target_eqn = ellipse_coeffs_target(1)*x^2 + ellipse_coeffs_target(2)*x*y + ellipse_coeffs_target(3)*y^2 + ellipse_coeffs_target(4)*x + ellipse_coeffs_target(5)*y + ellipse_coeffs_target(6);
% object_eqn = line_coeffs_object

xmin=min(2*projection_targetxy(1, :));
xmax=max(2*projection_targetxy(2, :));

figure
fimplicit(ellipse_coeffs_target(1)*x^2 + ellipse_coeffs_target(2)*x*y + ellipse_coeffs_target(3)*y^2 + ellipse_coeffs_target(4)*x + ellipse_coeffs_target(5)*y + ellipse_coeffs_target(6) == 0, [xmin, xmax])
hold on
fimplicit(-line_coeffs_object(1)*x + y + -line_coeffs_object(2) == 0, [xmin, xmax])





