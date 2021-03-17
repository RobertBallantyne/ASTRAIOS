function MRP = DCMtoMRP(DCM)
   EP = SheppardsMethod(DCM);
   MRP = EP(1,2:end)/(1+EP(1,1));
   if norm(MRP)>1
       MRP = -EP(1,2:end)/(1-EP(1,1));
   end
end