function [px,py,pz]=proj_plane(a,b,c,d,x,y,z)
A=[1 0 0 -a; 0 1 0 -b; 0 0 1 -c; a b c 0];
B=[x; y; z; d];
X=A\B;
px=X(1);
py=X(2);
pz=X(3);
end
