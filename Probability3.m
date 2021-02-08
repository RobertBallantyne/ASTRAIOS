%Probability3
clear;
clear all;
%%
% %stuff rab sent
% axis = 6.798120498932169e+03;
% i = 51.646000000000000;
% e = 2.205000000000000e-04;
% raan = 3.281531000000000e+02;
% omega = 2.896828000000000e+02;
% nu = 0.835702749937068;
% var = oe2rv(axis,e,i,raan,omega,nu);

%%
%ISS state vector
% x_t = -155.308154626131    -4468.84231562975    -5118.58170114094    7.15270950143093    -2.16658148201390    1.67449416556627
% x_r = -155.308154626131    -4468.84231562975    -5118.58170114094    -7.15270950143093    2.16658148201390    -1.67449416556627

State_t = [179715	732.588232789672	6751.01261162200	349.775048211597	-4.69570796668911	0.819521664362943	-5.99041204117603];
State_r = [179715	634.152369195065	6776.35123257810	448.607273488693	-1.06630928227009	-0.273021193206265	7.84806210493506];

[Ut Vt Wt] = orc(State_t);
%[Ur Vr Wr] = orc(State_r);

%sensitivity
% theta = 

%Covariance alreday in uvw
C_t = [3.43277238027061	-105.713201431152	0.000321901674039412;
-105.713201431152	3870.35286308290	0.259190058043855;
0.000321901674039412	0.259190058043855	0.102204931140936];

C_r = [0.00428779626076860	-0.0628791393741612	0.000198327124917972;
-0.0628791393741612	1.50167461537386	-0.00953017236297744;
0.000198327124917972	-0.00953017236297744	0.00198148637104321];

Ruvw_t = [Ut(1) Ut(2) Ut(3); Vt(1) Vt(2) Vt(3); Wt(1) Wt(2) Wt(3)];
%Ruvw_r = [Ur(1) Ur(2) Ur(3); Vr(1) Vr(2) Vr(3); Wr(1) Wr(2) Wr(3)];

%Cuvw_t = Ruvw_t*C_t*Ruvw_t';
%Cuvw_r = Ruvw_r*C_r*Ruvw_r';

dr_tca_uvw = Ruvw_t*State_r(1:3)' - Ruvw_t*State_t(1:3)'; % The X matrx
dv_tca_uvw = Ruvw_t*State_r(4:6)' - Ruvw_t*State_t(4:6)';

dr = dr_tca_uvw + dv_tca_uvw; %*dt;

Cuvw = C_t + C_r;

Chat = Cuvw(1:3,1:3); %Replace with Rabs

%pdr = (1/sqrt(((2*pi)^3)*det(Chat)))*exp((-1/2)*dr'*inv(Chat)*dr);
mu = dr_tca_uvw(1:2)';
sigma = Chat(1:2,1:2);
x1 = linspace(mu(1)-10,mu(1)+10,100);
x2 = linspace(mu(2)-200,mu(2)+200,100);
[X1,X2] = meshgrid(x1',x2');
X = [X1(:) X2(:)];
pdf = mvnpdf(X,mu,sigma);
Z = reshape(pdf,100,100);
surf(X1, X2, Z);
xlabel('U');
ylabel('V');
shading interp
collision = max(pdf);
% This works
% x1 = linspace(-10,10,100);
% x2 = linspace(-200,200,100);
% [X1,X2] = meshgrid(x1',x2');
% X = [X1(:) X2(:)];
% pdf = mvnpdf(X,[0 0],sigma);
% Z = reshape(pdf,100,100);
% surf(X1, X2, Z);
% shading interp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Probability of collision

Rt = 10;
Rr = 5;

Rc = Rt +Rr;
Ac = pi*Rc^2;

% pdr = (1/sqrt((2*pi)^3*det(Chat)))*exp((-1/2)*dr*C^-1*dr');

%B-plane
%could be xyz or uvw
[X_B Y_B] = Bplane(dr_tca_uvw, dv_tca_uvw);

Rxbyb = [ X_B(1) X_B(2) X_B(3); Y_B(1) Y_B(2) Y_B(3) ];
C_B = Rxbyb*C_t*Rxbyb';

%eigen values
[a1, a2] = eig(C_B);
a1sig  = sqrt(max(a2));

[b1, b2] = eig(C_B);
b1sig = sqrt(min(b2));

xb = a2(2,2)/norm(a2(2,2));
phi_B = acosd(xb*X_B);

%own guess work here, repeating the same process as before
dr_tca_B = Rxbyb*dr_tca_xyz';
dv_tca_B = Rxbyb*dv_tca_xyz';

dr_B = dr_tca_B + dv_tca_B; %dt

%maximum possible collision probability
Pc_max = (Rc^2)/(exp(1)*sqrt(det(C_B))*dr_B'*inv(C_B)*dr_B);

%K_c^2 
k_c_sqr = (dr(1)/Rc)^2 + (dr(2)/Rc)^2 + (dr(3)/Rc)^2;
C_Bstar = k_c_sqr*C_B;

A_B = Ac;
p_Bplane = (1/(2*pi*k_c_sqr*sqrt(det(C_Bstar))))*exp((-1/k_c_sqr)*A_B);


%%
%probability density distribution
% % x = fitdist(pdr,'normal')
% x = dr;
% y = makedist(x, pdr);
% plot(x, y)

hold on
plot(dr_tca_uvw, pdr,'.g','MarkerSize',50);
plot(dr, pdr,'.r','MarkerSize',25);
plot(dr, Pc_max,'.c','MarkerSize',10);
plot(dr, p_Bplane,'.b','MarkerSize',5);

%%
% figure
% hold on
% scatter3(State_r(1), State_r(2), State_r(3))
% scatter3(State_t(1), State_t(2), State_t(3))
% points = oe2rv(axis,e,i,raan,omega,1:1:360);
% plot3(points.x, points.y, points.z)

% Ux = [ State_t(1), Ut(1)+State_t(1)];
% Uy = [ State_t(2), Ut(2)+State_t(2)];
% Uz = [ State_t(3), Ut(3)+State_t(3)];
% Ucom = [Ux; Uy; Uz];
% plot3(Ux, Uy, Uz,'r')
% 
% Vx = [ State_t(1), Vt(1)+State_t(1)];
% Vy = [ State_t(2), Vt(2)+State_t(2)];
% Vz = [ State_t(3), Vt(3)+State_t(3)];
% Vcom = [ Vx; Vy; Vz ];
% plot3(Vx, Vy,Vz,'g')
% 
% Wx = [ State_t(1), Wt(1)+State_t(1)];
% Wy = [ State_t(2), Wt(2)+State_t(2)];
% Wz = [ State_t(3), Wt(3)+State_t(3)];
% plot3(Wx, Wy, Wz,'b')

% Bxx = [ State_t(1), 1000*X_B(1)+State_t(1)];
% Bxy = [ State_t(2), 1000*X_B(2)+State_t(2)];
% Bxz = [ State_t(3), 1000*X_B(3)+State_t(3)];
% plot3( Bxx, Bxy, Bxz,'c')
% 
% Byx = [ State_t(1), 1000*Y_B(1)+State_t(1)];
% Byy = [ State_t(2), 1000*Y_B(2)+State_t(2)];
% Byz = [ State_t(3), 1000*Y_B(3)+State_t(3)];
% plot3( Byx, Byy, Byz,'m')

% plot3(Ux, Vy, Wz, 'black')
% DotProducts = [ dot(Ucom(:,2), Vcom(:,2)) ]
%%
% mu = M_t;
% sigma = 1;
% pd = makedist('Normal','mu',mu,'sigma',sigma);
% 
% x = -50:0.5:50;
% y = pdf(pd,x);
% plot(x,y)