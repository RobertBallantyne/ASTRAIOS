function perturbation_acceleration = perturbation_code(x , y , z , u , v , w, tSince)
%tic
%x = 1058.06193248336;
%y = -4188.37231339556;
%z = -5253.18726604499;
%u = 7.55530924038791;
%v = 0.618594103041329;
%w = 1.02901026688371;
%% Initial Conditions
%r_e = 6378.000;                                         %equatorial radius of the earth (km)
%m_e = 5.972e24;                                         %mass of earth (kg)
%G = 6.6708e-11;                                         %gravitational const (m^3 kg^-1 s^-2)
%mu_e = 398600.4415;                                     %gravitational parameter of earth
mu_M = 4903;                                            %gravitational parameter of moon
mu_S = 132.712e9;                                       %gravitational parameter of sun
%AU = 149597870.691;                                     %1 astronomical unit in km
S = 1367*1000000;                                               %solar constant (W/m^2)
c = 299792458/1000;                                          %speed of light (m/s)
CR = 1.4;                                               %radiation pressure coefficient     (AUTOMATE QITH TLE)!!!!!!!!!!!!!!!
%r_iss = 109;
A_iss = 500/1000000;                                            %Frontal area (m^2)
m_iss=419700;                                           %Mass (kg)
%% ISS Co-ordinates 
R = [x ; y ; z];                                        %ISS coord vector
%r = norm(R);                                            %magnitude of vector of ISS to earth centre
%% Zonal Harmonics %%
[azx,azy,azz] = zonal_harmonics(x,y,z);                 %accel due to zonal harmonics
Az = [azx ; azy ; azz];
%az = norm(Az);
%% TLE to Julian Date %%
ds = '16034.13467034';                                  %TLE data for time                  (AUTOMATE WITH TLE)!!!!!!!!!!!!!!
global propagationEpoch
jd = propagationEpoch + tSince/86400 + 2433281.5;
%jd = tle2jd(ds);                                 
% %% Position of Sun rel Earth
% [position_sun,velocity_sun] = planetEphemeris([jd],'Earth','Sun','421','km');
% x_sun=position_sun(1);                                  %x coord of sun wrt earth
% y_sun=position_sun(2);                                  %y coord of sun wrt earth
% z_sun=position_sun(3);                                  %z coord of sun wrt earth
% RS = [x_sun ; y_sun ; z_sun];                           %position vector of sun
% rS = norm(RS);                                          %mag of position vector of sun
% %% Position of Moon rel Earth
% [position_moon,velocity_moon] = planetEphemeris([jd],'Earth','Moon','421','km');
% x_moon=position_moon(1);                                %x coord of moon wrt earth
% y_moon=position_moon(2);                                %y coord of moon wrt earth
% z_moon=position_moon(3);                                %z coord of moon wrt earth
% RM = [x_moon ; y_moon ; z_moon];                        %position vector of moon
% rM = norm(RM);                                          %mag of position vector of moon
% %% Lunar Gravity
% RM_sat = RM - R;                                        %position of moon w.r.t satellite
% rM_sat = norm(RM_sat);                                  %mag RM_sat
% am = mu_M*[((RM_sat(1)/rM_sat^3) - (RM(1)/rM^3)) ; ...
%                   ((RM_sat(2)/rM_sat^3) - (RM(3)/rM^3)) ; ...
%                   ((RM_sat(3)/rM_sat^3)- (RM(2)/rM^3))];  %accel due to lunar grav
% %% Solar Gravity
% RS_sat = RS - R;                                        %position of sun w.r.t satellite
% rS_sat = norm(RS_sat);                                  %mag RS_s
% as = mu_S*[((RS_sat(1)/rS_sat^3) - (RS(1)/rS^3)) ; ...
%                   ((RS_sat(2)/rS_sat^3) - (RS(2)/rS^3)) ; ...
%                   ((RS_sat(3)/rS_sat^3) - (RS(3)/rS^3))];  %accel due to solar grav
% %% SRP
% [nu] = shadow_func(R,RS);                               %shadow function
% uS_sat = RS_sat / rS_sat;                               %unit vector between satellite and sun
% am_ratio = A_iss / m_iss;                               %area to mass ratio
% PSR = nu * S / c * CR * am_ratio;                       
% aSRP = -PSR * [uS_sat(1) ; uS_sat(2) ; uS_sat(3)] / 1000000;
% %% Atmospheric Drag
ad = atmos_drag(x , y , z , u , v , w)*1000000;
% %% TOTAL
% accel_x = as(1) + am(1) + aSRP(1) + ad(1) + Az(1);      %total perturbation x component
% accel_y = as(2) + am(2) + aSRP(2) + ad(2) + Az(2);      %total perturbation y component
% accel_z = as(3) + am(3) + aSRP(3) + ad(3) + Az(3);      %total perturbation z component
accel_x = ad(1);
accel_y = ad(2);
accel_z = ad(3);
perturbation_acceleration = [accel_x ; accel_y ; accel_z];
%%toc
end


