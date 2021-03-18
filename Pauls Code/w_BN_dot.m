function w_BN_dot = w_BN_dot(w, u, L, DeltaL)
global I 
w_BN_dot = inv(I)*((-tilde(w)*I)*w + u + L + DeltaL);
end