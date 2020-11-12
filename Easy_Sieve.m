clear 
clc
close all
tic

global mu_Earth r_Earth

mu_Earth = 3.986004418 * 10^14; %GM for the earth
r_Earth = 6378000;

target = tle_read('tle1');
object = tle_read('tle2');
tic
position_target3d = plot_kep3d(target(4), target(5), target(10), target(11), target(13));
position_object3d = plot_kep3d(object(4), object(5), object(10), object(11), object(13));
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

