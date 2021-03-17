function w_BN = w_RN(t, BR, f, tracking, ref_MRP, ref_MRP_dot)
w_BN = BR*Rw_RN(t, f, tracking, ref_MRP, ref_MRP_dot);
end
