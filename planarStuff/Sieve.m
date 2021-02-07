function danger = Sieve(Sat, Deb, tolerance)
% Input deb has to be a structure containing the orbital elements as Deb.oe
% with their respective letters ie Deb.oe.a for semi-major axis
% Outputs a lot of stuff, equation of orbital plane, ellipse when projected
% onto xy plane and others, see function

syms x y z t

intersection.org = solve(Sat.plane, Deb.plane);
% Solves for the intersection between the two planes to give  a line of
% form x = a + bz, y = c + dz

line.x = coeffs(intersection.org.x);
line.y = coeffs(intersection.org.y);
line.z = [0, 1];

line.xt = line.x(1) - t*line.x(2);
line.yt = line.y(1) - t*line.y(2);
line.zt = line.z(1) - t*line.z(2);
% let z = t to allow for the equation to be solved

line.coeffs.xt = coeffs(line.xt);
line.coeffs.yt = coeffs(line.yt);
line.xy = -line.coeffs.xt(1) + 1/line.coeffs.xt(2) * x + line.coeffs.yt(1) - 1/line.coeffs.yt(2) * y;
% 'projected' onto xy axis, z component removed, to give 2d line

Sat.intersection.im = solve(line.xy, Sat.xyEllipse);
Sat.intersection.rl = imScrub(Sat.intersection.im);
% real results of where the xy-ellipse of the satellite intersects the aforementioned line

Deb.intersection.im = solve(line.xy, Deb.xyEllipse);
Deb.intersection.rl = imScrub(Deb.intersection.im);
% same but for debris

Sat.intersection.rl.z = zeros(1, length(Sat.intersection.rl.x));
Deb.intersection.rl.z = zeros(1, length(Deb.intersection.rl.x));

line.solver.Sat = line.xt == Sat.intersection.rl.x;
line.solver.Deb = line.xt == Deb.intersection.rl.x;
% refurmulates the x equation for 't' to allow for it to be solved, giving
% z

if length(line.solver.Sat) == length(line.solver.Deb)
    for i = 1:length(line.solver.Sat)
        Sat.intersection.rl.z(i) = -double(solve(line.solver.Sat(i), t));
        Deb.intersection.rl.z(i) = -double(solve(line.solver.Deb(i), t));
    end
elseif length(line.solver.Sat) ~= length(line.solver.Deb)
    for i = 1:length(line.solver.Sat)
        Sat.intersection.rl.z(i) = solve(line.solver.Sat(i), t);
    end
    for j = 1:length(line.solver.Deb)
        Deb.intersection.rl.z(j) = solve(line.solver.Deb(j), t);
    end
end
% adds the z component back in to give the 3 intersection points

%% Loop for min distances

[~, distances] = dsearchn([Sat.intersection.rl.x; Sat.intersection.rl.y; Sat.intersection.rl.z].', [Deb.intersection.rl.x; Deb.intersection.rl.y; Deb.intersection.rl.z].');
% dsearchn finds the closest point in array B to each index of array A, and
% returns the distance between them

mindist = min(distances);
if mindist < tolerance
    danger = true;
elseif mindist > tolerance
    danger = false;
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
% xmin = min([min(Sat.xyPlane.x); min(Deb.xyPlane.x)]);
% xmax = max([max(Sat.xyPlane.x); max(Deb.xyPlane.x)]);
% ymin = min([min(Sat.xyPlane.y); min(Deb.xyPlane.y)]);
% ymax = max([max(Sat.xyPlane.y); max(Deb.xyPlane.y)]);
% 
% plot3(ax3d, Sat.states.x, Sat.states.y, Sat.states.z, 'r')
% plot3(ax3d, Deb.states.x, Deb.states.y, Deb.states.z, 'k')
% 
% Sat.plane2 = x .* Sat.planeCf.a/Sat.planeCf.a + y .* Sat.planeCf.b/Sat.planeCf.a + z .* Sat.planeCf.c/Sat.planeCf.a + Sat.planeCf.d/Sat.planeCf.a;
% Deb.plane2 = x .* Deb.planeCf.a/Deb.planeCf.a + y .* Deb.planeCf.b/Deb.planeCf.a + z .* Deb.planeCf.c/Deb.planeCf.a + Deb.planeCf.d/Deb.planeCf.a;
% 
% 
% interval = [min(Deb.states.x) max(Deb.states.x) min(Deb.states.y) max(Deb.states.y) min(Deb.states.z) max(Deb.states.z)];
% % fimplicit3(ax3d, Sat.plane.Fn2, interval, 'EdgeColor','none','FaceAlpha',.5)
% % fimplicit3(ax3d, Deb.plane.Fn2, interval, 'EdgeColor','none','FaceAlpha',.5)
% 
% fplot(ax2d, line.xt, line.yt, [xmin xmax], 'g')
% fplot3(ax3d, line.xt, line.yt, line.zt, [xmin xmax], 'g')
% 
% scatter(ax2d, Sat.intersection.rl.x, Sat.intersection.rl.y)
% scatter(ax2d, Deb.intersection.rl.x, Deb.intersection.rl.y)
% 
% fimplicit(ax2d, Sat.xyEllipse, [xmin xmax ymin ymax])
% fimplicit(ax2d, Deb.xyEllipse, [xmin xmax ymin ymax])
% 
% scatter3(ax3d, Sat.intersection.rl.x, Sat.intersection.rl.y, Sat.intersection.rl.z, 'r')
% scatter3(ax3d, Deb.intersection.rl.x, Deb.intersection.rl.y, Deb.intersection.rl.z, 'k')


