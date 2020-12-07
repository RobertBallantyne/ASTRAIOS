function orbitInfo = orbitGeometry(orbitInfo)

nu = 0:0.1:360;
xyPlane.a = 0; 
xyPlane.b = 0;
xyPlane.c = 1;
xyPlane.d = 0;

[orbitInfo.xyz,orbitInfo.uvw] = oe2rv(orbitInfo.oe.a, orbitInfo.oe.e, orbitInfo.oe.i, orbitInfo.oe.raan, orbitInfo.oe.w, nu);
orbitInfo.xy = projPlane(xyPlane, orbitInfo.xyz.x, orbitInfo.xyz.y, orbitInfo.xyz.z);
orbitInfo.ellipse.Fn = ellipsefit([orbitInfo.xy.x; orbitInfo.xy.y]);

orbitInfo.plane.Fn = planefit(orbitInfo.xyz);
orbitInfo.plane.coeffs = planeCoeffs(orbitInfo.plane.Fn);
end
