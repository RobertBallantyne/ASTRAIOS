function collision_points = intersection(ellipseA_coeffs, ellipseB_coeffs)

syms x y
ellipseA = ellipseA_coeffs(1)*x^2 + ellipseA_coeffs(2)*x*y + ellipseA_coeffs(3)*y^2 + ellipseA_coeffs(4)*x + ellipseA_coeffs(5)*y + ellipseA_coeffs(6) == 0;
ellipseB = ellipseB_coeffs(1)*x^2 + ellipseB_coeffs(2)*x*y + ellipseB_coeffs(3)*y^2 + ellipseB_coeffs(4)*x + ellipseB_coeffs(5)*y + ellipseB_coeffs(6) == 0;

collision_points = solve(ellipseA, ellipseB);

end