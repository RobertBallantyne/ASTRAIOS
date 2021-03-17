function X_tilde = tilde(X)
    X_tilde = [0 -X(3,1) X(2,1); X(3,1) 0 -X(1,1);-X(2,1) X(1,1) 0];
end