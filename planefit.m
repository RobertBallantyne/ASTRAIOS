function fn = planefit(points)

p1 = [points.x(1); points.y(1); points.z(1)].';
p2 = [points.x(2); points.y(2); points.z(2)].';
p3 = [points.x(3); points.y(3); points.z(3)].';

normal = cross(p1-p2, p1-p3);

syms x y z
p  = [x y z];

realdot = @(u, v) u*transpose(v);

fn = (realdot(p-p1, normal));
end