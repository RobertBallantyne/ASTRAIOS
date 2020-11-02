clear
close all


global mu_Earth exclusion_radius r_Earth

mu_Earth = 3.986004418 * 10^14; %GM for the earth
r_Earth = 6357000; % radius of the earth in m

exclusion_radius = 1000e3; % danger radius, will change depending on some stats once we get there

target = tle_read('tle1');
object = tle_read('tle2');

% target_i = target(2); % inclination
% target_e = target(3); % eccentricity 
% target_W = target(4); % right angle of ascending node
% target_w = target(5); % argument of the perigee
% target_a = target(8); % semi_major axis

% same for the object parameters

position_target2d = plot_kep2d(target(3), target(8));
position_object2d = plot_kep2d(object(3), object(8));

ellipse_coeffs_target = ellipsefit(position_target2d);
ellipse_coeffs_object = ellipsefit(position_object2d);

figure
tab1 = uitab('title', 'Tab 1');
ax1 = axes(tab1);
hold on
plot(ax1, position_target2d(1, :), position_target2d(2, :))
plot(ax1, position_object2d(1, :), position_object2d(2, :))

position_target3d = plot_kep3d(target(2), target(3), target(4), target(5), target(8));
position_object3d = plot_kep3d(object(2), object(3), object(4), object(5), object(8));

tab2 = uitab('title', 'Tab 2');
ax2 = axes(tab2);
plot3(ax2, position_target3d(1, :), position_target3d(2, :), position_target3d(3, :), position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))

xmin=min(position_target2d(1, :));
xmax=max(position_target2d(2, :));
% 
tab3 = uitab('title', 'Tab 3');
ax3 = axes(tab3);
syms x y 
fimplicit(ax3, ellipse_coeffs_target(1)*x^2 + ellipse_coeffs_target(2)*x*y + ellipse_coeffs_target(3)*y^2 + ellipse_coeffs_target(4)*x + ellipse_coeffs_target(5)*y + ellipse_coeffs_target(6) == 0, [xmin, xmax])

% collisions = intersection(ellipse_coeffs_target, ellipse_coeffs_object);
% X = double(collisions.x);
% Y = double(collisions.y);
% mask = ~any(imag(X), 2) | ~any(imag(Y), 2);
% X_rl = X(mask);
% Y_rl = Y(mask);
% 
% scatter(ax1, X_rl, Y_rl)

syms x y z
plane_target = planefit(position_target3d);
plane_object = planefit(position_object3d);

coefficients = coeffs(plane_target);

a = double(coefficients(4));
b = double(coefficients(3));
c = double(coefficients(2));
d = double(coefficients(1));

position_object3d_projected = zeros(length(position_object3d(:, 1)), length(position_object3d(1, :)));

for i = 1:length(position_object3d(1, :))
    [p(i), q(i), r(i)] = proj_plane(a, b, c, d, position_object3d(1, i), position_object3d(2, i), position_object3d(3, i));
end    

position_object3d_projected = [p; q; r];

% plot(r, 1:length(position_object3d(1, :)))
hold(ax2, 'on')
plot3(ax2, p, q, r)

ellipse_coeffs_proj = ellipsefit(position_target2d);

plane_intersect = solve(plane_target, plane_object);

j = 1;
i = 1;
jump = 1;
tol = 1000;
dx_old = 0;
dy_old = 0;
tic

%% Finding intersections

% Going through the dataset to din
while i <= length(position_target3d(1, :))
    
    [dx, dy] = possdiff(position_target3d(:, i), plane_intersect);
    
    if dx < tol && dy < tol
        intersection_position(:, j) = position_target3d(:, i);
        intersection_iteration(j) = i;
        j = j + 1;
    end
    
    
    if dx > dx_old || dy > dy_old
        jump = jump + 50;
    elseif jump > 1
        jump = ceil(jump / 2);
    else
    end
    
    dx_old = dx;
    dy_old = dy;
   
    i = i + jump;
end
toc
% hold(ax2, 'on')
% scatter3(ax2, intersection_position(1, :), intersection_position(2, :), intersection_position(3, :))

% for i = 1:length(difference_x)
%     mag(i) = sqrt(difference_x(i)^2 + difference_y^2);
% end
% 
% plot(mag)

fclose('all');