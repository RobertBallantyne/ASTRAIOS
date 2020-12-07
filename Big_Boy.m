clear 
clc
tic
global mu_Earth r_Earth

if count(py.sys.path,strcat(pwd, '\Python_Scripts\spacetrack_api')) == 0
    insert(py.sys.path,int32(0),strcat(pwd, '\Python_Scripts\spacetrack_api'));
end

mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod)
name = mod.brian('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', 'out');
%%

nameOut = string(name);
nameOut = 'out_on_11_24_2020_18_20_58.inp';
[x_out, v_out] = Sgp4(nameOut, 'this_better_work.out');
global ISS ISS_points ISS_plane
ISS = tle_read('tleISS');
Results = [];

ISS_points = plot_kep3d(iss(4), iss(5), iss(10), iss(11), iss(13));
ISS_plane = planefit(ISS_points);
for i = 1:size(all_TLE, 1)
    currentline = all_TLE(i, :);
    check = Sieve1(table2array(currentline(1, 2:end)), 5);
    if check
        output = Sieve2(iss(2:end), table2array(currentline(1, 2:end)));
        Results = [Results; i output];
    end
end

toc
