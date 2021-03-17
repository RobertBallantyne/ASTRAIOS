function Rw_RN = Rw_RN(t, f, tracking, ref_MRP, ref_MRP_dot)

s_RN = MRP_tracking(t, f, tracking, ref_MRP);
s_RN_dot = MRP_dot_tracking(t, f, tracking, ref_MRP_dot);
B_RN = B_MRP(s_RN);
Rw_RN = 4/((1+norm(s_RN)^2)^2)*B_RN*s_RN_dot;

end