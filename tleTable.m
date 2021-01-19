function [tleTableOut] = tleTable(tle_file)

global mu_Earth r_Earth

file = fopen(tle_file, 'r');
if file < 0, file = fopen(tle_file,'r'); 
end
assert(file > 0,['Can''t open file ' file ' for reading.'])

Nrows = numel(textread('historicTLE.txt','%1c%*[^\n]'));

Ntles = Nrows/2;

vars = {'catID', 'x', 'y', 'z', 'u', 'v', 'w', 'apo', 'peri', 'a', 'e', 'i', 'raan', 'omega', 'epoch'};
vartypes = {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
tleTableOut = table('Size', [Ntles, length(vars)], 'VariableTypes', vartypes, 'VariableNames', vars);
for counter = 1:Ntles
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
    E = keplerEq(Mrad,e,1e-5);
    
    nu = acos((cos(E)- e) / (1 - e * cos(E)));
    epoch = epochConvertor(tleEpoch);
    
    tleTableOut(counter, {'x', 'y', 'z', 'u', 'v', 'w'})...
        = struct2table(oe2rv(a, e, i, raan, omega, nu));
    
    tleTableOut(counter, :).catID = catID;
    tleTableOut(counter, :).apo = apo/1000;
    tleTableOut(counter, :).peri = peri/1000;
    tleTableOut(counter, :).a = a/1000;
    tleTableOut(counter, :).e = e;
    tleTableOut(counter, :).i = i;
    tleTableOut(counter, :).raan = raan;
    tleTableOut(counter, :).omega = omega;
    tleTableOut(counter, :).epoch = epoch;
end
end