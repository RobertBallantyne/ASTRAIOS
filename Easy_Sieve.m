clear 
clc
close all
tic
target = tle_read('tle1');
object = tle_read('tle2');

global mu_Earth

mu_Earth = 3.986004418 * 10^14; %GM for the earth

tic
position_target3d = plot_kep3d(target(2), target(3), target(4), target(5), target(8));
position_object3d = plot_kep3d(object(2), object(3), object(4), object(5), object(8));
% Plots the orbits onto a 2d frame then rotates them appropriately
% depending on orbital elements

[k1, dist1] = dsearchn(position_target3d', position_object3d');
[min1, index1] = min(dist1);

object_close = position_object3d(:, index1);

[k2, dist2] = dsearchn(position_target3d', object_close');
target_close = position_target3d(:, k2);
toc

%% Plotting section :-)
figure

tab1 = uitab('title', '3D plot');
ax1 = axes(tab1);
plot3(ax1, position_target3d(1, :), position_target3d(2, :), position_target3d(3, :))
hold on
plot3(ax1, position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))
scatter3(ax1, object_close(1), object_close(2), object_close(3))
scatter3(ax1, target_close(1), target_close(2), target_close(3))
hold off

