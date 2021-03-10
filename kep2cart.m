function VelStateVec = kep2cart(kep,mu)
e   = kep(2);
i   = kep(3);
Om  = kep(4);
om  = kep(5);
tho = kep(6);

% Rotation matrix
R(1,1)=cos(om)*cos(Om)-sin(om)*cos(i)*sin(Om);
R(2,1)=cos(om)*sin(Om)+sin(om)*cos(i)*cos(Om);
R(3,1)=sin(om)*sin(i);

R(1,2)=-sin(om)*cos(Om)-cos(om)*cos(i)*sin(Om);
R(2,2)=-sin(om)*sin(Om)+cos(om)*cos(i)*cos(Om);
R(3,2)=cos(om)*sin(i);

R(1,3)=sin(i)*sin(Om);
R(2,3)=-sin(i)*cos(Om);
R(3,3)=cos(i);

%     In plane     Parameters
if e==1 % Parabola
    p=2*kep(1); % In the case of a parabola, kep(1) is rp
else
    p = kep(1)*(1-e^2);
end

r=p/(1+e*cos(tho));
xp=r*cos(tho);
yp=r*sin(tho);
wom_dot = sqrt(mu*p)/r^2;
r_dot   = sqrt(mu/p)*e*sin(tho);
vxp=r_dot*cos(tho)-r*sin(tho)*wom_dot;
vyp=r_dot*sin(tho)+r*cos(tho)*wom_dot;

% 3D cartesian vector
out(1)=R(1,1)*xp+R(1,2)*yp;
out(2)=R(2,1)*xp+R(2,2)*yp;
out(3)=R(3,1)*xp+R(3,2)*yp;

out(4)=R(1,1)*vxp+R(1,2)*vyp;
out(5)=R(2,1)*vxp+R(2,2)*vyp;
out(6)=R(3,1)*vxp+R(3,2)*vyp;

return
end

