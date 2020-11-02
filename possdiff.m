function [difference_x, difference_y] = possdiff(ellipse, plane)

z1 = ellipse(3);
syms x y z
plane_x = double(subs(plane.x, z, z1));
plane_y = double(subs(plane.y, z, z1));

ellipse_x = ellipse(1);
ellipse_y = ellipse(2);

difference_x = abs(plane_x - ellipse_x);
difference_y = abs(plane_y - ellipse_y);
end