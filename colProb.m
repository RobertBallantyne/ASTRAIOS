%Probability of collision at closest approach dr_tca_uvw between ISS and Debris

function [Pc Pcx Pcy Pcz] = colProb(Chat,dr_tca_uvw,R_col)

lowlim = dr_tca_uvw - R_col;
uplim = dr_tca_uvw + R_col;
V_col = (4/3)*pi*R_col^3;

Pc_3D = (1/sqrt(((2*pi)^3)*det(Chat)))*2*V_col*exp((-0.5)*dr_tca_uvw'*inv(Chat)*dr_tca_uvw);
Pc = (1/(2*pi*sqrt(det(Chat))))*(sqrt(det(Chat)))*(1.25331*erf((0.707107*uplim)/sqrt(det(Chat))) - 1.25331*erf((0.707107*lowlim)/sqrt(det(Chat))));
  
Xlowlim = dr_tca_uvw(1) - R_col;
Xuplim = dr_tca_uvw(1) + R_col;
    
Pcx = (1/(2*pi*sqrt(det(Chat(1,1)))))*(sqrt(Chat(1,1)))*(1.25331*erf((0.707107*Xuplim)/sqrt(Chat(1,1))) - 1.25331*erf((0.707107*Xlowlim)/sqrt(Chat(1,1))));
  
Ylowlim = dr_tca_uvw(2) - R_col;
Yuplim = dr_tca_uvw(2) + R_col;
    
Pcy = (1/(2*pi*sqrt(det(Chat(2,2)))))*(sqrt(Chat(1,1)))*(1.25331*erf((0.707107*Yuplim)/sqrt(Chat(2,2))) - 1.25331*erf((0.707107*Ylowlim)/sqrt(Chat(2,2))));
  
Zlowlim = dr_tca_uvw(3) - R_col;
Zuplim = dr_tca_uvw(3) + R_col;
    
Pcz = (1/(2*pi*sqrt(det(Chat(3,3)))))*(sqrt(Chat(1,1)))*(1.25331*erf((0.707107*Zuplim)/sqrt(Chat(3,3))) - 1.25331*erf((0.707107*Zlowlim)/sqrt(Chat(3,3))));
  
   