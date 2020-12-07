function coefficients = planeCoeffs(planeFunction)

% extracts coefficients from a plane formula and converts them to a double,
% which is a more legible number than a symbolic one

symCoeffs = coeffs(planeFunction);
coefficients.a = double(symCoeffs(4));
coefficients.b = double(symCoeffs(3));
coefficients.c = double(symCoeffs(2));
coefficients.d = double(symCoeffs(1));
end