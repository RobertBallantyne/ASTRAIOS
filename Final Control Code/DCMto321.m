function EA_321 = DCMto321(DCM)
    yaw = atan(DCM(1,2)/DCM(1,1));
    pitch = -asin(DCM(1,3));
    roll = atan(DCM(2,3)/DCM(3,3));
    EA_321 = [yaw pitch roll];
end