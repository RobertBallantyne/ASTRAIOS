%Probably of closest approach conjunction


function [P_c] = SinglePos(stateISS, stateDeb, CovarianceISS, CovarianceDeb)

ISSmultiple = stateISS;

Debrismultiple = stateDeb;
 %%

 multipleDistISStoDebris = [];
for i = 1:length(ISSmultiple)
    
    DistISStoDebris = [sqrt((ISSmultiple(i,2)-Debrismultiple(i,2))^2+(ISSmultiple(i,3)-Debrismultiple(i,3))^2+(ISSmultiple(i,4)-Debrismultiple(i,4))^2)];
         multipleDistISStoDebris = [ multipleDistISStoDebris; DistISStoDebris];
         
         
end
[closestDist,idx] = min(multipleDistISStoDebris(:));
[row] = ind2sub(size(multipleDistISStoDebris),idx);
time_in_days = ISSmultiple(row,1)/(3600*24);

%%
%used statevectors and covariance matrix

%ISS state vector
State_ISS = [ ISSmultiple(row,2)	ISSmultiple(row,3)	ISSmultiple(row,4)	ISSmultiple(row,5)	ISSmultiple(row,6) ISSmultiple(row,7)];

%Debris state vector
State_Deb = [ Debrismultiple(row,2)  Debrismultiple(row,3)	Debrismultiple(row,4)	 Debrismultiple(row,5)	Debrismultiple(row,6)  Debrismultiple(row,7)];

%Covariance alreday in uvw 0.0235090175307170
C_t = CovarianceISS;

C_r = CovarianceDeb;

Cuvw = C_t + C_r;

Chat = Cuvw(1:3,1:3);

%%
%Collision cross-section

R_ISS = 0.06; %0.05545; %ISS radius of sphere of influence
R_Deb = 0.05; %Debris radius of sphere of influence

R_col = R_ISS + R_Deb; %Radius of collision cross-section

%%
%Translating to the uvw frame

[Ut Vt Wt] = orc(State_ISS);

Ruvw_t = [Ut(1) Ut(2) Ut(3); Vt(1) Vt(2) Vt(3); Wt(1) Wt(2) Wt(3)];

dr_tca_uvw = Ruvw_t*State_Deb(1:3)' - Ruvw_t*State_ISS(1:3)';

%%
%Probability calculation
% C_xyz_t = inv(Ruvw_t)*covariance.C_t*inv(Ruvw_t');
% C_xyz_r = inv(Ruvw_t)*covariance.C_r*inv(Ruvw_t');
% 
% C_xyz = C_xyz_t + C_xyz_r;
% 
% dr_tca_xyz = statevectors.State_Deb(1:3)' - statevectors.State_ISS(1:3)';
% dv_tca_xyz = statevectors.State_Deb(4:6)' - statevectors.State_ISS(4:6)';
% 
% [X_B Y_B] = Bplane(dr_tca_xyz, dv_tca_xyz);
% 
% Rxbyb = [ X_B(1) X_B(2) X_B(3); Y_B(1) Y_B(2) Y_B(3) ];

%C_B = Rxbyb*C_xyz*Rxbyb';
C_B = [Chat(1,1) Chat(1,3); Chat(3,1) Chat(3,3)]; 

dr_tca_B = [dr_tca_uvw(1) dr_tca_uvw(3)]'; %Rxbyb*statevectors.State_Deb(1:3)' - Rxbyb*statevectors.State_ISS(1:3)';

% Pcmax = (col_crosssection.R_col^2)/(exp(1)*sqrt(det(C_B))*dr_tca_B'*inv(C_B)*dr_tca_B)

%%

dX_min = -2*dr_tca_B(1);
dX_max = 2*dr_tca_B(1);
dY_min = -2*dr_tca_B(2);
dY_max = 2*dr_tca_B(2);

stepsize = 0.1;

Nsteps = ceil((dX_max - dX_min)/stepsize);

dX = linspace(dX_min, dX_max, Nsteps);
dY = linspace(dY_min, dY_max, Nsteps);
P = zeros(Nsteps, Nsteps);

inCB = inv(C_B);
detCB = det(C_B);

for i = 1:Nsteps
    for j = 1:Nsteps
        P(i,j) = (1/(2*pi*sqrt(detCB)))*exp(-0.5*[dX(1,i) dY(1,j)]*inCB*[dX(1,i);dY(1,j)]);
    end
end

[dX, dY] = meshgrid(dX, dY);
surf(dX, dY, P)

x = linspace(dr_tca_B(1)-R_col,dr_tca_B(1) + R_col,Nsteps);
y = linspace(dr_tca_B(2)-R_col,dr_tca_B(2) + R_col,Nsteps);
P_c = trapz(y, trapz(x, P, 2));

