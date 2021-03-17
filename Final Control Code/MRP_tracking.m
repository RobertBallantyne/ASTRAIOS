function MRP_RN = MRP_tracking(t, f, tracking, ref_MRP)

if tracking
    MRP_RN = ref_MRP;
else
    MRP_RN = zeros(3,1);
end

end