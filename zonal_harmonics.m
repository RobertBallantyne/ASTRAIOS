function [azx,azy,azz] = zonal_harmonics(x,y,z)

r_e = 6378.000;                                 %equatorial radius of the earth (km)
mu_e = 398600.4415;                             %gravitational parameter of earth
R = [x,y,z];                                    %ISS coord vector
r = norm(R);

J2 = 1082.63e-6;                                %J2 pertubation coefficient
J3 = -2.52e-6;                                  %J3 pertubation coefficient 
J4 = -1.61e-6;                                  %J4 pertubation coefficient 
J5 = -0.15e-6;                                  %J5 pertubation coefficient 
J6 = 0.57e-6;                                   %J6 pertubation coefficient      

a_j2 = -3/2*J2*(mu_e/r^2)*((r_e/r)^2) * [(1-5*(z/r)^2)*(x/r) ; (1 - 5*(z/r)^2)*(y/r) ; (3 - 5*(z/r)^2)*(z/r)];
a_j3 =  1/2*J3*(mu_e/r^2)*((r_e/r)^3) * [5*(7*(z/r)^3 - 3*(z/r))*(x/r) ; 5*(7*(z/r)^3 - 3*(z/r))*(y/r) ; 3*(1 - 10*(z/r)^2 + (35/3)*(z/r)^4)];
a_j4 =  5/8*J4*(mu_e/r^2)*((r_e/r)^4) * [(3 - 42*(z/r)^2 + 63*(z/r)^4)*(x/r) ; (3 - 42*(z/r)^2 + 63*(z/r)^4)*(y/r) ; (15 - 70*(z/r)^2 + 63*(z/r)^4)*(z/r)];
a_j5 =  1/8*J5*(mu_e/r^2)*((r_e/r)^5) * [3*(35*(z/r) - 210*(z/r)^3 + 231*(z/r)^5)*(x/r) ; 3*(35*(z/r) - 210*(z/r)^3 + 231*(z/r)^5)*(y/r) ; (693*(z/r)^6 - 945*(z/r)^4 + 315*(z/r)^2 - 15)];
a_j6 =-1/16*J6*(mu_e/r^2)*((r_e/r)^6) * [(35 - 945*(z/r)^2 + 3465*(z/r)^4 - 3003*(z/r)^6)*(x/r) ; (35 - 945*(z/r)^2 + 3465*(z/r)^4 - 3003*(z/r)^6)*(y/r) ; (245 - 2205*(z/r)^2 +4851*(z/r)^4 - 3003*(z/r)^6)*(z/r)];

azx = a_j2(1) + a_j3(1) + a_j4(1) + a_j5(1) + a_j6(1);
azy = a_j2(2) + a_j3(2) + a_j4(2) + a_j5(2) + a_j6(2);
azz = a_j2(3) + a_j3(3) + a_j4(3) + a_j5(3) + a_j6(3);
end
