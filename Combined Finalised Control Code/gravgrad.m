function Lg = gravgrad(X_BN , soly)
    global I 

m_e = 5.972e24;                 %Mass of earth (kg)
G = 6.67430e-11;                %Gravitational constant of earth
BO = MRPtoDCM(X_BN);            %DCM for coordinate conversion

R_co = [ 0 ; 0 ; soly];         %Grav grad direction vector in non inertial frame
R_cb = BO * R_co;               %Grav grad direction vector converted to body frame coords

Lg = 3*G*m_e / soly^5 * [R_cb(2)*R_cb(3)*(I(3,3) - I(2,2))  ; 
                         R_cb(1)*R_cb(3)*(I(1,1) - I(3,3))  ; 
                         R_cb(1)*R_cb(2)*(I(2,2) - I(1,1))] ;


end

