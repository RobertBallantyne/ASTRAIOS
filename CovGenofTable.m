function [bin, covariances, error] = CovGenofTable(differencingTable, analysisWindow)

error = false;

% tableSort = sortrows(differencingTable, 'deltaT', 'ascend');

findReferences = differencingTable.deltaT == 0;
referenceTLEs = differencingTable(findReferences, :);
clear findReferences propOut

%% Finding difference between propagated and epoch in UVW frame
if height(referenceTLEs) < 50
    bin = 0;
    covariances = 0;
    error = true;
    disp('Not enough reference TLEs')
    return
end
epsilonx = [];
epsilonv = [];
deltas = [];

for i = 1:height(referenceTLEs) % i is count for all given tles
    x = referenceTLEs(i, :).x;
    y = referenceTLEs(i, :).y;
    z = referenceTLEs(i, :).z;
    u = referenceTLEs(i, :).u;
    v = referenceTLEs(i, :).v;
    w = referenceTLEs(i, :).w;
    
    [Umat, Vmat, Wmat] = orc([x y z u v w]); % orc returns the U, V and W unit vectors
    
    R = [Umat; Vmat; Wmat];
    
    xrefTr = R * [x; y; z];
    vrefTr = R * [u; v; w];

    findLines = differencingTable.stopTime == referenceTLEs(i, :).startTime;
    consideredLines = differencingTable(findLines, :);

    for j = 1:height(consideredLines)
        if consideredLines(j, :).deltaT < analysisWindow && consideredLines(j, :).catID == referenceTLEs(i, :).catID
            xm = [consideredLines(j, :).x; consideredLines(j, :).y; consideredLines(j, :).z];
            xmTr = R * xm;

            vm = [consideredLines(j, :).u; consideredLines(j, :).v; consideredLines(j, :).w];
            vmTr = R * vm;

            newline = [abs(xrefTr - xmTr); abs(vrefTr - vmTr); consideredLines(j, :).deltaT; consideredLines(j, :).catID];
            deltas = [deltas newline];
        end
    end

%     while j <= height(differencingTable) && differencingTable(j, :).stopTime == referenceTLEs(i, :).startTime
%         
%         xm = [tableSort(j, :).x; tableSort(j, :).y; tableSort(j, :).z];
%         xmTr = R * xm;
%         
%         epsilonx = [epsilonx abs(xrefTr - xmTr)];
%         
%         vm = [tableSort(j, :).u; tableSort(j, :).v; tableSort(j, :).w];
%         vmTr = R * vm;
%         
%         epsilonv = [epsilonv abs(vrefTr - vmTr)];
%         j = j + 1;
%     end
%     
end

% tableSort.UxDiff = epsilonx(1, :)';
% tableSort.VxDiff = epsilonx(2, :)';
% tableSort.WxDiff = epsilonx(3, :)';
% tableSort.UvDiff = epsilonv(1, :)';
% tableSort.VvDiff = epsilonv(2, :)';
% tableSort.WvDiff = epsilonv(3, :)';
newTab = table();
newTab.catID  = deltas(8, :)';
newTab.deltaT = double(deltas(7, :)');
newTab.UxDiff = double(deltas(1, :)');
newTab.VxDiff = double(deltas(2, :)');
newTab.WxDiff = double(deltas(3, :)');
newTab.UvDiff = double(deltas(4, :)');
newTab.VvDiff = double(deltas(5, :)');
newTab.WvDiff = double(deltas(6, :)');

clear x y z u v w xm vm xref vref xmTr vmTr xrefTr vrefTr Umat Vmat Wmat R i j findReferences
% propSortdT = sortrows(tableSort,'deltaT','ascend');
newTab = sortrows(newTab,'deltaT','ascend');
%%
% scatterPlotBars('UxDiff', propSortdT.deltaT, propSortdT.UxDiff)
% scatterPlotBars('VxDiff', propSortdT.deltaT, propSortdT.VxDiff)
% scatterPlotBars('WxDiff', propSortdT.deltaT, propSortdT.WxDiff)
% scatterPlotBars('UvDiff', propSortdT.deltaT, propSortdT.UvDiff)
% scatterPlotBars('VvDiff', propSortdT.deltaT, propSortdT.VvDiff)
% scatterPlotBars('WvDiff', propSortdT.deltaT, propSortdT.WvDiff)

%% Binning deltas by half a day
bins = 0:1:analysisWindow;

% propSortdT.bin = discretize(propSortdT.deltaT, bins);
newTab.bin = discretize(newTab.deltaT, bins);

covs = [];

% for i = 1:length(bins)-1
%     binFind = propSortdT.bin == i;
%     bin.(['bin_' num2str(i)]) = propSortdT(binFind, :);
%     variables = [bin.(['bin_' num2str(i)])(:, 'UxDiff') ...
%                  bin.(['bin_' num2str(i)])(:, 'VxDiff') ...
%                  bin.(['bin_' num2str(i)])(:, 'WxDiff') ...
%                  bin.(['bin_' num2str(i)])(:, 'UvDiff') ...
%                  bin.(['bin_' num2str(i)])(:, 'VvDiff') ...
%                  bin.(['bin_' num2str(i)])(:, 'WvDiff')];
%     varMat = table2array(variables);
%     if isempty(varMat)
%         error = true;
%         break
%     end
%     covariances.(['bin_' num2str(i)]) = cov(varMat);
% %     corrplot(varMat)
% end

for i = 1:length(bins)-1
    binFind = newTab.bin == i;
    bin.(['bin_' num2str(i)]) = newTab(binFind, :);
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