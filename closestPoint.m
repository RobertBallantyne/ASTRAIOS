function danger = closestPoint(orbitalElements1, orbitalElements2, ISScovariance)

points1 = oe2rv(orbitalElements1.a, orbitalElements1.e, orbitalElements1.i, orbitalElements1.raan, orbitalElements1.omega, 0:360);
points2 = oe2rv(orbitalElements2.a, orbitalElements2.e, orbitalElements2.i, orbitalElements2.raan, orbitalElements2.omega, 0:360);

xyz1 = [points1.x; points1.y; points1.z]';
uvw1 = [points1.u; points1.v; points1.w]';
xyz2 = [points2.x; points2.y; points2.z]';
uvw2 = [points2.u; points2.v; points2.w]';

periType = floor(orbitalElements2.peri/100)*100; % rounds down to nearest hundred, as that is how things are seperated for covariances

if orbitalElements2.e < 0.02
    eccType = 'e00_e02';
elseif orbitalElements2.e < 0.2
    eccType = 'e02_e2';
elseif orbitalElements2.e < 0.7
    eccType = 'e2_e7';
elseif orbitalElements2.e < 1
    eccType = 'e7_e';
end

[bins2, cov2] = CovGen(orbitalElements2.catID, 5);
factor = sqrt(chi2inv(0.99, 3));

Utol = sqrt(cov2.bin_10(1, 1) + ISScovariance.bin_10(1, 1)) * factor;
Vtol = sqrt(cov2.bin_10(2, 2) + ISScovariance.bin_10(2, 2)) * factor;
Wtol = sqrt(cov2.bin_10(3, 3) + ISScovariance.bin_10(3, 3)) * factor;

[a, b] = dsearchn(xyz1, xyz2); % finds closest point in mat 2 to every point in mat 1, a is the element in mat 2 that is closest to the index it represents

safe = zeros(length(b), 1);

for i = 1:length(b)
    x = points1.x(i);
    y = points1.y(i);
    z = points1.z(i);
    u = points1.u(i);
    v = points1.v(i);
    w = points1.w(i);

    [Umat, Vmat, Wmat] = orc([x y z u v w]);

    R = [Umat; Vmat; Wmat];

    xrefTr = R * xyz1(i, :)';
    xothTr = R * xyz1(a(i), :)';

    dx = xrefTr - xothTr;

    if abs(dx(1)) > Utol || abs(dx(2)) > Vtol || abs(dx(3)) > Wtol
        safe(i) = 1;
    else
        safe(i) = 0;
    end
end

if min(safe) == 0
   danger = true;
end

end