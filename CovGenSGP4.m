function [bin, covariances, error] = CovGenSGP4(catID, analWindow)

error = false;

if count(py.sys.path,strcat(pwd, '\Python_Scripts\spacetrack_api')) == 0
    insert(py.sys.path,int32(0),strcat(pwd, '\Python_Scripts\spacetrack_api'));
end

%%
mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod);

%%
tic
historyFile = mod.derek('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', catID);

%%

propOut = homeSgp4([pwd '\' char(historyFile)], analWindow);
propSort = sortrows(propOut, 'stopTime', 'ascend');

findReferences = propSort.deltaT == 0;
referenceTLEs = propSort(findReferences, :);
clear findReferences propOut
%% Finding difference between propagated and epoch in UVW frame
if height(referenceTLEs) < 10
    bin = 0;
    covariances = 0;
    error = true;
    disp('Not enough reference TLEs')
    return
end
dr_UVW = zeros(3, height(propSort));
dv_UVW = zeros(3, height(propSort));
j = 1;
for i = 1:height(referenceTLEs) % i is count for all given tles
    x = referenceTLEs(i, :).x;
    y = referenceTLEs(i, :).y;
    z = referenceTLEs(i, :).z;
    u = referenceTLEs(i, :).u;
    v = referenceTLEs(i, :).v;
    w = referenceTLEs(i, :).w;
    
    [Umat, Vmat, Wmat] = orc([x y z u v w]);
    
    R = [Umat; Vmat; Wmat];
    
    r_O = [x; y; z]; % r observed
    v_O = [u; v; w]; % v observed

    while j <= height(propSort) && propSort(j, :).stopTime == referenceTLEs(i, :).startTime
        
        r_C = [propSort(j, :).x; propSort(j, :).y; propSort(j, :).z]; % r calculated
        v_C = [propSort(j, :).u; propSort(j, :).v; propSort(j, :).w]; % v calculated
        dr_ECI = r_O - r_C; % position residual in ECI reference frame
        dv_ECI = v_O - v_C; % velocity residual in ECI reference frame
        
        dr_UVW(:, j) = R * dr_ECI; % position residual in UVW reference frame
        dv_UVW(:, j) = R * dv_ECI; % velocity residual in UVW reference frame
        
        j = j + 1;
    end
    
end

propSort.UxDiff = dr_UVW(1, :)';
UxMean = mean(dr_UVW(1, :));
UxStD = std(dr_UVW(1, :));
trimUx = abs(dr_UVW(1, :)) > UxMean + 2 * UxStD;

propSort.VxDiff = dr_UVW(2, :)';
VxMean = mean(dr_UVW(2, :));
VxStD = std(dr_UVW(2, :));
trimVx = abs(dr_UVW(2, :)) > VxMean + 2 * VxStD;

propSort.WxDiff = dr_UVW(3, :)';
WxMean = mean(dr_UVW(3, :));
WxStD = std(dr_UVW(3, :));
trimWx = abs(dr_UVW(3, :)) > WxMean + 2 * WxStD;

allTrim = or(trimUx, trimVx);
allTrim = or(trimWx, allTrim);
propSort(allTrim, :) = [];

clear x y z u v w xm vm xref vref xmTr vmTr xrefTr vrefTr Umat Vmat Wmat R i j findReferences
propSortdT = sortrows(propSort,'deltaT','ascend');

%%
% scatterPlotBars('UxDiff', propSortdT.deltaT, propSortdT.UxDiff)
% scatterPlotBars('VxDiff', propSortdT.deltaT, propSortdT.VxDiff)
% scatterPlotBars('WxDiff', propSortdT.deltaT, propSortdT.WxDiff)
% scatterPlotBars('UvDiff', propSortdT.deltaT, propSortdT.UvDiff)
% scatterPlotBars('VvDiff', propSortdT.deltaT, propSortdT.VvDiff)
% scatterPlotBars('WvDiff', propSortdT.deltaT, propSortdT.WvDiff)

%% Binning deltas by half a day
bins = 0:0.5:analWindow;

propSortdT.bin = discretize(propSortdT.deltaT, bins);
covs = [];

for i = 1:length(bins)-1
    binFind = propSortdT.bin == i;
    bin.(['bin_' num2str(i)]) = propSortdT(binFind, :);
    variables = [bin.(['bin_' num2str(i)])(:, 'UxDiff') ...
                 bin.(['bin_' num2str(i)])(:, 'VxDiff') ...
                 bin.(['bin_' num2str(i)])(:, 'WxDiff')];
    varMat = table2array(variables);
    if isempty(varMat)
        error = true;
        break
    end
    covariances.(['bin_' num2str(i)]) = cov(varMat);
%     corrplot(varMat)
    %covs = [covs; covariances.(['bin_' num2str(i)])(1, 1) covariances.(['bin_' num2str(i)])(2, 2) covariances.(['bin_' num2str(i)])(3, 3)];
end
% figure
% hold on
% 
% scatter(propSortdT.deltaT, propSortdT.UxDiff, 'bo')
% plot(bins, sqrt(covs(:, 1))*factor, 'r')
% plot(bins, -sqrt(covs(:, 1))*factor, 'r')
% 
% figure
% hold on
% 
% scatter(propSortdT.deltaT, propSortdT.VxDiff, 'bo')
% plot(bins, sqrt(covs(:, 2))*factor, 'r')
% plot(bins, -sqrt(covs(:, 2))*factor, 'r')
% 
% figure
% hold on
% 
% scatter(propSortdT.deltaT, propSortdT.WxDiff, 'bo')
% plot(bins, sqrt(covs(:, 3))*factor, 'r')
% plot(bins, -sqrt(covs(:, 3))*factor, 'r')
end