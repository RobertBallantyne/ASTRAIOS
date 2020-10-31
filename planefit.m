function fn = planefit(points)

p1 = points(:, 1).';
p2 = points(:, 2).';
p3 = points(:, 3).';

normal = cross(p1-p2, p1-p3);

syms x y z
p  = [x y z];

realdot = @(u, v) u*transpose(v);

fn = (realdot(p-p1, normal));
end