function danger = Sieve(Sat, Deb, tolerance)

Deb = orbitGeometry(Deb);

syms x y z t

intersection.org = solve(Sat.plane.Fn, Deb.plane.Fn);
line.x = coeffs(intersection.org.x);
line.y = coeffs(intersection.org.y);
line.z = [0, 1];

line.xt = line.x(1) - t*line.x(2);
line.yt = line.y(1) - t*line.y(2);
line.zt = line.z(1) - t*line.z(2);

line.coeffs.xt = coeffs(line.xt);
line.coeffs.yt = coeffs(line.yt);
line.xy = -line.coeffs.xt(1) + 1/line.coeffs.xt(2) * x + line.coeffs.yt(1) - 1/line.coeffs.yt(2) * y;

Sat.intersection.im = solve(line.xy, Sat.ellipse.Fn);
Sat.intersection.rl = imScrub(Sat.intersection.im);

Deb.intersection.im = solve(line.xy, Deb.ellipse.Fn);
Deb.intersection.rl = imScrub(Deb.intersection.im);

Sat.intersection.rl.z = zeros(1, length(Sat.intersection.rl.x));
Deb.intersection.rl.z = zeros(1, length(Deb.intersection.rl.x));

line.solver.Sat = line.xt == Sat.intersection.rl.x;
line.solver.Deb = line.xt == Deb.intersection.rl.x;

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


%% Loop for min distances

[~, distances] = dsearchn([Sat.intersection.rl.x; Sat.intersection.rl.y; Sat.intersection.rl.z].', [Deb.intersection.rl.x; Deb.intersection.rl.y; Deb.intersection.rl.z].');

mindist = min(distances);
if mindist < tolerance
    danger = true;
elseif mindist > tolerance
    danger = false;
end

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
% xmin = min([min(Sat.xy.x); min(Deb.xy.x)]);
% xmax = max([max(Sat.xy.x); max(Deb.xy.x)]);
% ymin = min([min(Sat.xy.y); min(Deb.xy.y)]);
% ymax = max([max(Sat.xy.y); max(Deb.xy.y)]);
% 
% plot3(ax3d, Sat.xyz.x, Sat.xyz.y, Sat.xyz.z, 'r')
% plot3(ax3d, Deb.xyz.x, Deb.xyz.y, Deb.xyz.z, 'k')
% 
% Sat.plane.Fn2 = x .* Sat.plane.coeffs.a/Sat.plane.coeffs.a + y .* Sat.plane.coeffs.b/Sat.plane.coeffs.a + z .* Sat.plane.coeffs.c/Sat.plane.coeffs.a + Sat.plane.coeffs.d/Sat.plane.coeffs.a;
% Deb.plane.Fn2 = x .* Deb.plane.coeffs.a/Deb.plane.coeffs.a + y .* Deb.plane.coeffs.b/Deb.plane.coeffs.a + z .* Deb.plane.coeffs.c/Deb.plane.coeffs.a + Deb.plane.coeffs.d/Deb.plane.coeffs.a;
% 
% 
% interval = [min(Deb.xyz.x) max(Deb.xyz.x) min(Deb.xyz.y) max(Deb.xyz.y) min(Deb.xyz.z) max(Deb.xyz.z)];
% % fimplicit3(ax3d, Sat.plane.Fn2, interval, 'EdgeColor','none','FaceAlpha',.5)
% % fimplicit3(ax3d, Deb.plane.Fn2, interval, 'EdgeColor','none','FaceAlpha',.5)
% 
% fplot(ax2d, line.xt, line.yt, [xmin xmax], 'g')
% fplot3(ax3d, line.xt, line.yt, line.zt, [xmin xmax], 'g')
% 
% scatter(ax2d, Sat.intersection.rl.x, Sat.intersection.rl.y)
% scatter(ax2d, Deb.intersection.rl.x, Deb.intersection.rl.y)
% 
% fimplicit(ax2d, Sat.ellipse.Fn, [xmin xmax ymin ymax])
% fimplicit(ax2d, Deb.ellipse.Fn, [xmin xmax ymin ymax])
% 
% scatter3(ax3d, Sat.intersection.rl.x, Sat.intersection.rl.y, Sat.intersection.rl.z, 'r')
% scatter3(ax3d, Deb.intersection.rl.x, Deb.intersection.rl.y, Deb.intersection.rl.z, 'k')


