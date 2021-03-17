function B_matrix = B_MRP(X)
    X_tilde = tilde(X);
    X_norm = norm(X);
    B_matrix = (1-X_norm^2)*eye(3) - 2*X_tilde + 2*X*transpose(X);
end