function ad = atmos_drag(x , y , z , u , v , w)
V=[u ; v ; w];
R = [x;y;z];                                        %ISS coord vector
r = norm(R);

BSTAR = 0.000018407;                                %From tle AUTOMATE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
wE = [0 ; 0 ; 7.2921159e-5];                        %Earth’s angular velocity (rad/s)
r_e = 6378.000; 

alt =r-r_e;
rho = atmosphere(alt); 
rho_ref = 0.1570;

Vrel = (V - cross(wE,R))*1000; 
vrel = norm(Vrel);
uv = Vrel / vrel;

drag_a = rho / rho_ref * BSTAR * vrel^2;
ad = -drag_a * uv;
end
