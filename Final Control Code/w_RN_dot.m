function w_RN_dot = w_RN_dot(t, dt, BR, f, tracking, ref_MRP, ref_MRP_dot)
w_RN_dot = (w_RN(t+dt, BR, f, tracking, ref_MRP, ref_MRP_dot)-w_RN(t-dt, BR, f, tracking, ref_MRP, ref_MRP_dot))/(2*dt);
end