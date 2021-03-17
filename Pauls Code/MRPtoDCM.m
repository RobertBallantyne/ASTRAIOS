function DCM = MRPtoDCM(MRP)
    
    MRP_tilde = tilde(MRP);
    MRP_norm = norm(MRP);

    DCM = eye(3) + (8*MRP_tilde^2-4*(1-MRP_norm^2)*MRP_tilde)/((1+MRP_norm^2)^2);

end