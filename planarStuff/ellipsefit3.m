function [merit]= ellipsefit3(x, vmatrix) % x is the initial parameters, vmatrix stores the datapoints
load vmatrix.txt % In vmatrix, the data are stored: N rows x 3 columns
a = x(1);
b = x(2);c
alpha = x(3);
beta = x(4);
gamma = x(5);
z = [x(6),x(7),x(8)];
t = z';
[dim1, dim2]=size(vmatrix);
% construction of rotation matrix R(alpha,beta,gamma)
R1 = [cos(alpha), sin(alpha), 0; -sin(alpha), cos(alpha), 0; 0, 0, 1];v
R2 = [1, 0, 0; 0, cos(beta), sin(beta); 0, -sin(beta), cos(beta)];
R3 = [cos(gamma), sin(gamma), 0; -sin(gamma), cos(gamma), 0; 0, 0, 1];
R = R3*R2*R1;
% first  compute  vector phi (in the length of the data) by minimizing for every
% point in the data set the distance of this point to the ellipse
% (with its initial parameters a,b,alpha,beta,gamma, z1,z2,z3 held fixed) with respect to phi.
for i=1:dim1
point=vmatrix(i,:)';
dist=@(phi)sum((R*[a*cos(phi); b*sin(phi); 0]+t-point)).^2; 
phi(i)=fminbnd(dist,0,2*pi);
end
v = [a*cos(phi); b*sin(phi); zeros(size(phi))];
P = R*v;
%The targetfunction is: g = (xi1,xi2,xi3)' -(z1,z2,z3)'-R(alpha,beta,gamma)(a cos(phi), b sin(phi),0)'
% Construction of distance function
merit = [vmatrix(:,1)-z(1)-P(1),vmatrix(:,2)-z(2)-P(2),vmatrix(:,3)-z(3)-P(3)]; 
merit = sqrt(sum(sum(merit.^2)))
end