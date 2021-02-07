function scatterPlotBars(thing, x, y)

p = polyfit(x, y, 3);
y_fit = polyval(p, x);

positive = [];
negative = [];
positiveY_fit = [];
negativeY_fit = [];
residuals = y - y_fit;
for i = 1:length(residuals)
    if residuals(i) > 0
        positive = [positive; x(i) residuals(i)];
        positiveY_fit = [positiveY_fit; y_fit(i)];
    else
        negative = [negative; x(i) residuals(i)];
        negativeY_fit = [negativeY_fit; y_fit(i)];
    end
end
% plot(positive(:, 1), positive(:, 2), 'b')
% hold on
% plot(negative(:, 1), negative(:, 2), 'r')

pP = polyfit(positive(:, 1), positive(:, 2), 2);
y_fitP = polyval(pP, positive(:, 1));

pN = polyfit(negative(:, 1), negative(:, 2), 2);
y_fitN = polyval(pN, negative(:, 1));

figure
hold on
plot(x, y, 'bo')
plot(x, y_fit,'r-')
pBar = y_fitP + positiveY_fit;
nBar = y_fitN + negativeY_fit;
plot(positive(:, 1), pBar, 'r')
plot(negative(:, 1), nBar, 'r')
end