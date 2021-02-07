function [elements] = tleRead(tle_file)

global mu_Earth r_Earth

file = fopen(tle_file, 'r');
if file < 0, file = fopen(tle_file,'r'); 
end
assert(file > 0,['Can''t open file ' file ' for reading.'])


line_1 = fgetl(file);
line_2 = fgetl(file);

catID = str2double(line_2(3:7));
tleEpoch = str2double(line_1(19:32));
i = str2double(line_2(9:16));
e = str2double(['0.' line_2(27:33)]);
M = str2double(line_2(44:51));
mm = str2double(line_2(53:63));
T = 60*60*24 / mm;
a = ((T/(2*pi))^2*mu_Earth)^(1/3);
apo = a * (1.0 + e) - r_Earth;
peri = a * (1.0 - e) - r_Earth;
raan = str2double(line_2(18:25));
omega = str2double(line_2(35:42));

Mrad = deg2rad(M);
[~, nuRad] = kepler2(Mrad, e);
nu = rad2deg(nuRad);

epoch = epochConvertor(tleEpoch);

tleTableOut(counter, {'x', 'y', 'z', 'u', 'v', 'w'})...
    = struct2table(oe2rv(a, e, i, raan, omega, nu));
elements.x = elements.x / 1000;
elements.y = elements.y / 1000;
elements.z = elements.z / 1000;
elements.u = elements.u / 1000;
elements.v = elements.v ;
elements.w = elements.w;
elements.catID = catID;
elements.apo = apo/1000;
elements.peri = peri/1000;
elements.a = a/1000;
elements.e = e;
elements.i = i;
elements.raan = raan;
elements.omega = omega;
elements.epoch = epoch;
end