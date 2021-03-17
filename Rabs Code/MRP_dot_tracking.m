function s_RN_tr_dot = MRP_dot_tracking(t, f, tracking, ref_MRP_dot)

if tracking
    s_RN_tr_dot = ref_MRP_dot;
else
    s_RN_tr_dot = zeros(3,1);
end