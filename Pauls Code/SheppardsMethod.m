function EP = SheppardsMethod(DCM)

    B_0 = sqrt(0.25*(1+trace(DCM)));
    B_1 = sqrt(0.25*(1+2*DCM(1,1)-trace(DCM)));
    B_2 = sqrt(0.25*(1+2*DCM(2,2)-trace(DCM)));
    B_3 = sqrt(0.25*(1+2*DCM(3,3)-trace(DCM)));
    B = [B_0 B_1 B_2 B_3];
    max_B = max(B);
    
    if max_B == B_0
        B_1 = (DCM(2,3)-DCM(3,2))/(4*B_0);
        B_2 = (DCM(3,1)-DCM(1,3))/(4*B_0);
        B_3 = (DCM(1,2)-DCM(2,1))/(4*B_0);
        EP = [B_0 B_1 B_2 B_3];
    end
    
    if max_B == B_1
        B_0 = (DCM(2,3)-DCM(3,2))/(4*B_1);
        B_2 = (DCM(1,2)+DCM(2,1))/(4*B_1);
        B_3 = (DCM(3,1)+DCM(1,3))/(4*B_1);
        EP = [B_0 B_1 B_2 B_3];
    end
    
    if max_B == B_2
        B_0 = (DCM(3,1)-DCM(1,3))/(4*B_2);
        B_1 = (DCM(1,2)+DCM(2,1))/(4*B_2);
        B_3 = (DCM(2,3)+DCM(3,2))/(4*B_2);
        EP = [B_0 B_1 B_2 B_3];
    end
    
    if max_B == B_3
        B_0 = (DCM(1,2)-DCM(2,1))/(4*B_3);
        B_1 = (DCM(3,1)+DCM(1,3))/(4*B_3);
        B_2 = (DCM(2,3)+DCM(3,2))/(4*B_3);
        EP = [B_0 B_1 B_2 B_3];
    end
    
end