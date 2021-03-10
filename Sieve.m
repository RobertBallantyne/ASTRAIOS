function safe = Sieve(SatPoints, SatPlane, SatEllipse, Deb, tolerance)
% Inpts sat and deb are the standard xyzuvw then kep elements

DebPoints = oe2rv(Deb.a, Deb.e, Deb.i, Deb.raan, Deb.omega, 0:360);

DebPlane = planeFit3(DebPoints);

DebEllipse = ellipsefit([DebPoints.x; DebPoints.y]);

syms x y z t

intersection.org = solve(SatPlane, DebPlane);
% Solves for the intersection between the two planes to give  a line of
% form x = a + bz, y = c + dz

line.x = coeffs(intersection.org.x);
line.y = coeffs(intersection.org.y);
line.z = [0, 1];

line.xt = line.x(1) - t*line.x(2);
line.yt = line.y(1) - t*line.y(2);
line.zt = line.z(1) - t*line.z(2);
% let z = t to allow for the equation to be solved
% 
line.coeffs.xt = coeffs(line.xt);
line.coeffs.yt = coeffs(line.yt);
line.xy = -line.coeffs.xt(1) + 1/line.coeffs.xt(2) * x + line.coeffs.yt(1) - 1/line.coeffs.yt(2) * y;
% 'projected' onto xy axis, z component removed, to give 2d line

intersection.Sat.im = solve(line.xy, SatEllipse);
intersection.Sat.rl = imScrub(intersection.Sat.im);
% real results of where the xy-ellipse of the satellite intersects the aforementioned line

intersection.Deb.im = solve(line.xy, DebEllipse);
intersection.Deb.rl = imScrub(intersection.Deb.im);
% same but for debris

intersection.Sat.rl.z = zeros(1, length(intersection.Sat.rl.x));
intersection.Deb.rl.z = zeros(1, length(intersection.Deb.rl.x));

line.solver.Sat = line.xt == intersection.Sat.rl.x;
line.solver.Deb = line.xt == intersection.Deb.rl.x;
% refurmulates the x equation for 't' to allow for it to be solved, giving
% z

if length(line.solver.Sat) == length(line.solver.Deb)
    for i = 1:length(line.solver.Sat)
        intersection.Sat.rl.z(i) = -double(solve(line.solver.Sat(i), t));
        intersection.Deb.rl.z(i) = -double(solve(line.solver.Deb(i), t));
    end
elseif length(line.solver.Sat) ~= length(line.solver.Deb)
    for i = 1:length(line.solver.Sat)
        intersection.Sat.rl.z(i) = solve(line.solver.Sat(i), t);
    end
    for j = 1:length(line.solver.Deb)
        intersection.Deb.rl.z(j) = solve(line.solver.Deb(j), t);
    end
end
% adds the z component back in to give the 3 intersection points

%% Loop for min distances

[~, distances] = dsearchn([intersection.Sat.rl.x; intersection.Sat.rl.y; intersection.Sat.rl.z].', [intersection.Deb.rl.x; intersection.Deb.rl.y; intersection.Deb.rl.z].');
% dsearchn finds the closest point in array B to each index of array A, and
% returns the distance between them

mindist = min(distances);
if mindist < tolerance
    safe = false;
elseif mindist > tolerance
    safe = true;
end
% if that minimum distance is less than your tolerance then youre in
% danger

%% Plotting -- obselete

% plot3d = figure;
% ax3d = axes('parent', plot3d);
% plot3(ax3d, 0, 0, 0);
% hold(ax3d, 'on')
% ax3d.Clipping = 'off';
% 
% plot2d = figure;
% ax2d = axes('parent', plot2d);
% plot(ax2d, 0, 0);
% hold(ax2d, 'on')
% 
% xmin = min([min(SatPoints.x); min(DebPoints.x)]);
% xmax = max([max(SatPoints.x); max(DebPoints.x)]);
% ymin = min([min(SatPoints.y); min(DebPoints.y)]);
% ymax = max([max(SatPoints.y); max(DebPoints.y)]);
% 
% plot3(ax3d, SatPoints.x, SatPoints.y, SatPoints.z, 'r')
% plot3(ax3d, DebPoints.x, DebPoints.y, DebPoints.z, 'k')
% 
% interval = [min(DebPoints.x) max(DebPoints.x) min(DebPoints.y) max(DebPoints.y) min(DebPoints.z) max(DebPoints.z)];
% fimplicit3(ax3d, SatPlane, interval, 'EdgeColor','none','FaceAlpha',.5)
% fimplicit3(ax3d, DebPlane, interval, 'EdgeColor','none','FaceAlpha',.5)
% % 
% fplot(ax2d, line.xt, line.yt, [xmin xmax], 'g')
% fplot3(ax3d, line.xt, line.yt, line.zt, [xmin xmax], 'g')
% % 
% scatter(ax2d, intersection.Sat.rl.x, intersection.Sat.rl.y)
% scatter(ax2d, intersection.Deb.rl.x, intersection.Deb.rl.y)
% % 
% fimplicit(ax2d, SatEllipse, [xmin xmax ymin ymax])
% fimplicit(ax2d, DebEllipse, [xmin xmax ymin ymax])
% % 
% scatter3(ax3d, intersection.Sat.rl.x, intersection.Sat.rl.y, intersection.Sat.rl.z, 'r')
% scatter3(ax3d, intersection.Deb.rl.x, intersection.Deb.rl.y, intersection.Deb.rl.z, 'k')
