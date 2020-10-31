%% Orbital Crash Detector and Avoidance Script
% Angus McAllister & Robert Ballantyne 26/10/20

clc 
clear
close all

global mu_Earth exclusion_radius r_Earth

mu_Earth = 3.986004418 * 10^14; %GM for the earth
r_Earth = 6357000; % radius of the earth in m

exclusion_radius = 1000e3; % danger radius, will change depending on some stats once we get there

orbit_radius = 35786000; % m, its geostationary

orbit_velocity = sqrt(mu_Earth / orbit_radius); %standard circular orbit equation

end_time = 60*60*24; %length of integration in seconds
time_step = 0.01; % time step in seconds
timespan = 0:time_step:end_time;

x0_1 = [orbit_radius 0 0]; % assumed to be on equator and Greenwich meridian

v0_1 = [0 orbit_velocity 0]; % perfectly circular orbit around equator

state0_1 = [x0_1 v0_1]; % initial state vector

y_1 = propagate(state0_1, timespan, 1e-8); % sets tolerance for integration, can make larger if it takes too long

x_out_1 = y_1(:,1:3); 
v_out_1 = y_1(:,4:6); 

x0_2 = [orbit_radius 0 0]; % assumed to be on equator and Greenwich meridian

v0_2 = [0 -orbit_velocity 0]; % this one is going to be perpendicular to the other orbit, a polar one

state0_2 = [x0_2 v0_2]; % initial state vector

y_2 = propagate(state0_2, timespan, 1e-8);

x_out_2 = y_2(:,1:3); 
v_out_2 = y_2(:,4:6); 

crashes = crash_detector(x_out_1, x_out_2);

% %% Delta V Calculation for Along Track Manoeuvre
% 
% deltaV1 = deltaV_1(orbit_velocity, orbit_radius);

%% Plots
figure
hold on
[xx, yy, zz] = sphere;
s1=surf(xx*r_Earth,yy*r_Earth,zz*r_Earth, 'facecolor',[.5 .5 .5]); % plots a sphere with the same radius as the earth
plot3(x_out_1(:,1),x_out_1(:,2),x_out_1(:,3),"b", "linewidth", 1); % plots the 3d representation of the orbit of body 1
plot3(x_out_2(:,1),x_out_2(:,2),x_out_2(:,3),"r", "linewidth", 1); % same but for body 2
view(45,45)
