function orbitInfo = orbitGeometry(orbitInfo)

nu = 0:0.1:360;
xyPlane.a = 0; 
xyPlane.b = 0;
xyPlane.c = 1;
xyPlane.d = 0;

orbitInfo.state = oe2rv(orbitInfo.tle.a, orbitInfo.tle.e, orbitInfo.tle.i, orbitInfo.tle.raan, orbitInfo.tle.w, nu);
% uses orbital elements and all true anomalies to find position and
% velocity at every point 

orbitInfo.xy = projPlane(xyPlane, orbitInfo.state.x, orbitInfo.state.y, orbitInfo.state.z);
% projects those points onto the xy plane

orbitInfo.ellipse.Fn = ellipsefit([orbitInfo.xy.x; orbitInfo.xy.y]);
% fits the ellipse to those projected points

orbitInfo.plane.Fn = planefit(orbitInfo.state);
% fits plane to 3d points

orbitInfo.plane.coeffs = planeCoeffs(orbitInfo.plane.Fn);
% extracts coefficients of plane formula
end
