function out=projPlane(coefficients,x,y,z)

A=[1 0 0 -coefficients.a; 0 1 0 -coefficients.b; 0 0 1 -coefficients.c; coefficients.a coefficients.b coefficients.c 0];
B=[x; y; z; zeros(1, length(x)) - coefficients.d];
X=A\B;
px=X(1, :);
py=X(2, :);
pz=X(3, :);
out.x = px;
out.y = py;
out.z = pz;
end
