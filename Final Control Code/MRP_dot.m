function MRP_dot = MRP_dot(MRP, w)

MRP_tilde = tilde(MRP);
MRP_norm = norm(MRP);

B_sigma = 0.25*((1-MRP_norm^2)*eye(3) + 2*MRP_tilde + 2*MRP*transpose(MRP));
MRP_dot = B_sigma*w;

end