function [elements] = tle_read(tle_file)

global mu_Earth 

file = fopen([tle_file '.tle'], 'r');
if file < 0, file = fopen([tle_file '.tle'],'r'); 
end
assert(file > 0,['Can''t open file ' file ' for reading.'])

line_1 = fgetl(file);
line_2 = fgetl(file);

epoch_year = str2double(line_1(19:20));
epoch_day = str2double(line_1(21:32));

catalogue_number = str2double(line_2(3:7));
inclination = str2double(line_2(9:16));
RAAN = str2double(line_2(18:25));
eccentricity = str2double(['0.' line_2(27:33)]);
arg_of_perigee = str2double(line_2(35:42));
mean_anomaly = str2double(line_2(44:51));
mean_motion = str2double(line_2(53:63));
period = 60*60*24 / mean_motion;

semi_major_axis = ((period/(2*pi))^2*mu_Earth)^(1/3);
semi_minor_axis = semi_major_axis*sqrt(1-eccentricity^2);

apogee = semi_major_axis * (1 + eccentricity);
perigee = semi_major_axis * (1 - eccentricity);

elements = [catalogue_number inclination eccentricity RAAN arg_of_perigee mean_anomaly mean_motion semi_major_axis semi_minor_axis apogee perigee epoch_year epoch_day];

end