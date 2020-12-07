clear 
clc
close all
tic

globals()

ISS = tle_read('tleISS');
Deb = tle_read('tle2');
tic

nu = 0:0.1:360;
xyPlane.a = 0; 
xyPlane.b = 0;
xyPlane.c = 1;
xyPlane.d = 0;

[rISS,vISS] = oe2rv(ISS.a, ISS.e, ISS.i, ISS.raan, ISS.w, nu);
xyISS = proj_plane(xyPlane, rISS(1,:), rISS(2,:), rISS(3,:));
xyISSFn = ellipsefit(xyISS(1:2, :));

[rDeb,vDeb] = oe2rv(Deb.a, Deb.e, Deb.i, Deb.raan, Deb.w, nu);
xyDeb = proj_plane(xyPlane, rDeb(1,:), rDeb(2,:), rDeb(3,:));
xyDebFn = ellipsefit(xyDeb(1:2, :));

%xmin = min(xyISS(2, :));
%xmax = max(xyISS(2, :));
%fimplicit(xyISSFn, [xmin xmax])
%hold on
%fimplicit(xyDebFn, [xmin xmax])
% syms x y
plot3(rISS(1, :), rISS(2, :), rISS(3, :), 'r')
hold on
plot3(rDeb(1, :), rDeb(2, :), rDeb(3, :), 'm')
% plot3(xyISS(1, :), xyISS(2, :), xyISS(3, :), 'r')
% plot3(xyDeb(1, :), xyDeb(2, :), xyDeb(3, :), 'r')
syms x y z t
planeISS = planefit(rISS);
planeDeb = planefit(rDeb);

coeffISS = planeCoeffs(planeISS);
coeffDeb = planeCoeffs(planeDeb);

interval = [min(rDeb(1, :)) max(rDeb(1, :)) min(rDeb(2, :)) max(rDeb(2, :)) min(rDeb(3, :)) max(rDeb(3, :))];

ISSSymFn = x .* coeffISS.a/1000 + y .* coeffISS.b/1000 + z .* coeffISS.c/1000 + coeffISS.d/1000;
%fimplicit3(f, interval)
DebSymFn = x .* coeffDeb.a/1000 + y .* coeffDeb.b/1000 + z .* coeffDeb.c/1000 + coeffDeb.d/1000;
%fimplicit3(f1, interval)

intersection = solve(planeISS, planeDeb);
line.x = coeffs(intersection.x);
line.y = coeffs(intersection.y);
line.z = [0, 1];

syms x y z t
line.xt = line.x(1) - t*line.x(2);
line.yt = line.y(1) - t*line.y(2);
line.zt = line.z(1) - t*line.z(2);
%fplot(line.xt, line.yt, [xmin xmax], 'r')
xtCoeffs = coeffs(line.xt);
ytCoeffs = coeffs(line.yt);
line.xy = -xtCoeffs(1) + 1/xtCoeffs(2) * x + ytCoeffs(1) - 1/ytCoeffs(2) * y;

imISS = solve(line.xy, xyISSFn);
rlISS = imScrub(imISS);

imDeb = solve(line.xy, xyDebFn);
rlDeb = imScrub(imDeb);

planeISScf = planeCoeffs(planeISS);
planeDebcf = planeCoeffs(planeDeb);

rlISSxyx = proj_plane(planeISScf, rlISS.x, rlISS.y, zeros(1, length(rlISS.x)));
rlDebxyx = proj_plane(planeDebcf, rlDeb.x, rlDeb.y, zeros(1, length(rlDeb.x)));

scatter3(rlISSxyx(1, :), rlISSxyx(2, :), rlISSxyx(3, :))
scatter3(rlDebxyx(1, :), rlDebxyx(2, :), rlDebxyx(3, :))

toc
[k1, dist1] = dsearchn(position_target3d', position_object3d');
[min1, index1] = min(dist1);

object_close = position_object3d(:, index1);

[k2, dist2] = dsearchn(position_target3d', object_close');
target_close = position_target3d(:, k2);
toc

%% Plotting section :-)
figure

tab1 = uitab('title', '3D plot');
ax1 = axes(tab1);
plot3(ax1, position_target3d(1, :), position_target3d(2, :), position_target3d(3, :))
hold on
plot3(ax1, position_object3d(1, :), position_object3d(2, :), position_object3d(3, :))
scatter3(ax1, object_close(1), object_close(2), object_close(3))
scatter3(ax1, target_close(1), target_close(2), target_close(3))
hold off

