function DCM = DCM_321(EA)
    DCM(1,1) = cos(EA(1,2))*cos(EA(1,1));
    DCM(1,2) = cos(EA(1,2))*sin(EA(1,1));
    DCM(1,3) = -sin(EA(1,2));
    DCM(2,1) = sin(EA(1,3))*sin(EA(1,2))*cos(EA(1,1))-cos(EA(1,3))*sin(EA(1,1));
    DCM(2,2) = sin(EA(1,3))*sin(EA(1,2))*sin(EA(1,1))+cos(EA(1,3))*cos(EA(1,1));
    DCM(2,3) = sin(EA(1,3))*cos(EA(1,2));
    DCM(3,1) = cos(EA(1,3))*sin(EA(1,2))*cos(EA(1,1))+sin(EA(1,3))*sin(EA(1,1));
    DCM(3,2) = cos(EA(1,3))*sin(EA(1,2))*sin(EA(1,1))-sin(EA(1,3))*cos(EA(1,1));
    DCM(3,3) = cos(EA(1,3))*cos(EA(1,2));
end