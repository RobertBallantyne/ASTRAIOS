function [bin, covariances, error] = CovGen(catID, analWindow)

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
epsilonx = [];
epsilonv = [];
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
    
    xrefTr = R * [x; y; z];
    vrefTr = R * [u; v; w];

    while j <= height(propSort) && propSort(j, :).stopTime == referenceTLEs(i, :).startTime
        
        xm = [propSort(j, :).x; propSort(j, :).y; propSort(j, :).z];
        xmTr = R * xm;
        
        epsilonx = [epsilonx xrefTr - xmTr];
        
        vm = [propSort(j, :).u; propSort(j, :).v; propSort(j, :).w];
        vmTr = R * vm;
        
        epsilonv = [epsilonv vrefTr - vmTr];
        j = j + 1;
    end
    
end

propSort.UxDiff = epsilonx(1, :)';
propSort.VxDiff = epsilonx(2, :)';
propSort.WxDiff = epsilonx(3, :)';
propSort.UvDiff = epsilonv(1, :)';
propSort.VvDiff = epsilonv(2, :)';
propSort.WvDiff = epsilonv(3, :)';

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
                 bin.(['bin_' num2str(i)])(:, 'WxDiff') ...
                 bin.(['bin_' num2str(i)])(:, 'UvDiff') ...
                 bin.(['bin_' num2str(i)])(:, 'VvDiff') ...
                 bin.(['bin_' num2str(i)])(:, 'WvDiff')];
    varMat = table2array(variables);
    if isempty(varMat)
        error = true;
        break
    end
    covariances.(['bin_' num2str(i)]) = cov(varMat);
%     corrplot(varMat)
    covs = [covs; covariances.(['bin_' num2str(i)])(1, 1) covariances.(['bin_' num2str(i)])(2, 2) covariances.(['bin_' num2str(i)])(3, 3)];
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