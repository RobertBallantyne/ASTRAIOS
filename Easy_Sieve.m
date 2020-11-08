clear 
clc
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

d = pdist2(position_target3d', position_object3d');
[mindist, idx] = min(d, [], 2);

pos_diff = position_target3d-position_object3d;

mag_pos_diff = sqrt(pos_diff(1, :).^2 + pos_diff(2, :).^2 + pos_diff(3, :).^2);

[min, index] = min(mag_pos_diff);