function [s_BR, BR] = MRP_BR(s_BN, s_RN, tracking)

BN = MRPtoDCM(s_BN);

if tracking
    RN = MRPtoDCM(s_RN);
    BR = BN*transpose(RN);
    s_BR = DCMtoMRP(BR);
    
else
    BR = BN;
    s_BR = s_BN;
end

end