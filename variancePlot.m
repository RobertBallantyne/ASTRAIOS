function variancePlot(thing, dt, diff, covariance)

p = polyfit(dt, diff, 3);
y_fit = polyval(p, dt);

figure
hold on
plot(dt, diff, 'bo')
plot(dt, y_fit,'r-')

factor = sqrt(chi2inv(0.99, 3));

scatter(1, mean(diff) + sqrt(covariance)*factor, 'ro')
scatter(1, mean(diff) - sqrt(covariance)*factor, 'ro')
end