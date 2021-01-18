function distance = closestPoint(orbitalElements1, orbitalElements2)

points1 = oe2rv(orbitalElements1.a/1000, orbitalElements1.e, orbitalElements1.i, orbitalElements1.raan, orbitalElements1.omega, 1:1:360);
points2 = oe2rv(orbitalElements2.a, orbitalElements2.e, orbitalElements2.i, orbitalElements2.raan, orbitalElements2.omega, 1:1:360);

xyz1 = [points1.x; points1.y; points1.z]';
xyz2 = [points2.x; points2.y; points2.z]';

[a, b] = dsearchn(xyz1, xyz2);

minDist = min(b);

distance = minDist;

end