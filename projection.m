clear
close all
fclose('all');
clc

target = tle_read('tle1');
object = tle_read('tle2');

target_i = target(2); % inclination
target_e = target(3); % eccentricity 
target_W = target(4); % right angle of ascending node
target_w = target(5); % argument of the perigee
target_a = target(8); % semi_major axis

object_i = object(2);
object_e = object(3);
object_W = object(4);
object_w = object(5);
object_a = object(8);

position_target2d = plot_kep2d(target_e, target_a);
position_object2d = plot_kep2d(object_e, object_a);

figure
tab1 = uitab('title', 'Tab 1');
ax1 = axes(tab1);
hold on
plot(ax1, position_target2d(1, :), position_target2d(2, :))
plot(ax1, position_object2d(1, :), position_object2d(2, :))

position_target3d = plot_kep3d(target_i, target_e, target_W, target_w, target_a);
position_object3d = plot_kep3d(object_i, object_e, object_W, object_w, object_a);

tab2 = uitab('title', 'Tab 2');
ax2 = axes(tab2);
plot3(ax2, position_target3d(1, :), position_target3d(2, :), position_target3d(3, :), position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))

ellipse_coeffs_target = ellipsefit(position_target2d);
ellipse_coeffs_object = ellipsefit(position_object2d);

xmin=min(position_target2d(1, :));
xmax=max(position_target2d(2, :));

tab3 = uitab('title', 'Tab 3');
ax3 = axes(tab3);
syms x y 
fimplicit(ax3, ellipse_coeffs_target(1)*x^2 + ellipse_coeffs_target(2)*x*y + ellipse_coeffs_target(3)*y^2 + ellipse_coeffs_target(4)*x + ellipse_coeffs_target(5)*y + ellipse_coeffs_target(6) == 0, [xmin, xmax])

collisions = intersection(ellipse_coeffs_target, ellipse_coeffs_object);
X = double(collisions.x);
Y = double(collisions.y);
mask = ~any(imag(X), 2) | ~any(imag(Y), 2);
X_rl = X(mask);
Y_rl = Y(mask);

scatter(ax1, X_rl, Y_rl)

syms x y z
plane_target = planefit(position_target3d);
plane_object = planefit(position_object3d);

plane_intersect = solve(plane_target, plane_object);

xline = plane_intersect.x;
yline = plane_intersect.y;
z = 0:1:100;
figure
plot3(xline, yline, z)







