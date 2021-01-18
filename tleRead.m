function [elements] = tleRead(tle_file)

global mu_Earth r_Earth

file = fopen(tle_file, 'r');
if file < 0, file = fopen(tle_file,'r'); 
end
assert(file > 0,['Can''t open file ' file ' for reading.'])


line_1 = fgetl(file);
line_2 = fgetl(file);


NORAD_CAT_ID = str2double(line_2(3:7));
EPOCH = str2double(line_1(19:32));

INCLINATION = str2double(line_2(9:16));
ECCENTRICITY = str2double(['0.' line_2(27:33)]);
MEAN_MOTION = str2double(line_2(53:63));
PERIOD = 60*60*24 / MEAN_MOTION;
SEMI_MAJOR_AXIS = ((PERIOD/(2*pi))^2*mu_Earth)^(1/3);
APOAPSIS = SEMI_MAJOR_AXIS * (1.0 + ECCENTRICITY) - r_Earth;
PERIAPSIS = SEMI_MAJOR_AXIS * (1.0 - ECCENTRICITY) - r_Earth;
AVERAGE_APSIS = (APOAPSIS+PERIAPSIS)/2;
RA_OF_ASC_NODE = str2double(line_2(18:25));
ARG_OF_PERICENTER = str2double(line_2(35:42));
MEAN_ANOMALY = str2double(line_2(44:51));
MEAN_ANOMALYrad = deg2rad(MEAN_ANOMALY);
ECCENTRICITY_ANOMALY = keplerEq(MEAN_ANOMALYrad,ECCENTRICITY,1e-8);
    
nu = acos((cos(ECCENTRICITY_ANOMALY)- ECCENTRICITY) / (1 - ECCENTRICITY * cos(ECCENTRICITY_ANOMALY)));

T = 2.0 * pi * ((SEMI_MAJOR_AXIS ^ 3.0) / mu_Earth) ^(0.5);
Vel = (mu_Earth / SEMI_MAJOR_AXIS) ^ (0.5);

REV_AT_EPOCH = 0;

elements.Epoch = EPOCH;
elements.ID = NORAD_CAT_ID;
elements.Rev = REV_AT_EPOCH;
elements.i = INCLINATION;
elements.e = ECCENTRICITY;
elements.m = MEAN_MOTION;
elements.apo = APOAPSIS;
elements.peri = PERIAPSIS;
elements.raan = RA_OF_ASC_NODE;
elements.omega = ARG_OF_PERICENTER;
elements.nu = nu;
elements.a = SEMI_MAJOR_AXIS;
elements.T = T;
elements.V = Vel;
end