function coefficients = planeCoeffs(planeFunction)
symCoeffs = coeffs(planeFunction);
coefficients.a = double(symCoeffs(4));
coefficients.b = double(symCoeffs(3));
coefficients.c = double(symCoeffs(2));
coefficients.d = double(symCoeffs(1));
end