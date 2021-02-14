function distance = closestPoint2(orbitalElements1, orbitalElements2)

points1 = oe2rv(orbitalElements1.a, orbitalElements1.e, orbitalElements1.i, orbitalElements1.raan, orbitalElements1.omega, 0:360);
points2 = oe2rv(orbitalElements2.a, orbitalElements2.e, orbitalElements2.i, orbitalElements2.raan, orbitalElements2.omega, 0:360);
% mean motion is in revolutions per day, so get it into degrees per day
% then to degrees per second then seconds per degree
dt1 = 1 / (orbitalElements1.mm / (24*60*60) * 360);
dt2 = 1 / (orbitalElements2.mm / (24*60*60) * 360);

% assuming the maximum distance each object can travel in that time is the
% escape velocity gives the maximum distance it can travel, then add the
% exclusion radius

xyz1 = [points1.x; points1.y; points1.z]';
uvw1 = [points1.u; points1.v; points1.w]';

xyz2 = [points2.x; points2.y; points2.z]';
uvw2 = [points2.u; points2.v; points2.w]';

[a, b] = dsearchn(xyz1, xyz2); % finds closest point in mat 2 to every point in mat 1, a is the element in mat 2 that is closest to the index it represents
Ux = [];
Vx = [];
Wx = [];

for i = 1:length(b)
    x = points1.x(i);
    y = points1.y(i);
    z = points1.z(i);
    u = points1.u(i);
    v = points1.v(i);
    w = points1.w(i);
    
    magnitude = dt1 * norm(uvw1(i)) + dt2 * (uvw2(i));

    [Umat, Vmat, Wmat] = orc([x y z u v w]);

    R = [Umat; Vmat; Wmat];

    xrefTr = R * xyz1(i, :)';
    xothTr = R * xyz1(a(i), :)';

    dx = xrefTr - xothTr;

    Ux = [Ux; dx(1)];
    Vx = [Vx; dx(2)];
    Wx = [Wx; dx(3)];
    end
end

distance = [min(Ux), min(Vx), min(Wx)];

end