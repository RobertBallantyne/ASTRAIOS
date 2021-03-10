function [U V W] = orc(Statevector)  
%orbit-rlated coordinate system
x = Statevector(1);
y = Statevector(2);
z = Statevector(3);
vx = Statevector(4);
vy = Statevector(5);
vz = Statevector(6);

r = [ x y z ];
v = [ vx vy vz ];

U = r/norm(r);
W = cross(r,v)/norm(cross(r,v));
V = cross(W,U);
