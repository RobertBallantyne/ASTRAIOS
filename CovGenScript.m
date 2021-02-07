fclose('all')
clear 
clc

globals()

if count(py.sys.path,strcat(pwd, '\Python_Scripts\spacetrack_api')) == 0
    insert(py.sys.path,int32(0),strcat(pwd, '\Python_Scripts\spacetrack_api'));
end

%%
mod = py.importlib.import_module('api_pull');
py.importlib.reload(mod);

%%
tic
historyFile = mod.derek('robert.a.ballantyne@gmail.com', '5z6F7Q!.VhLYrxF', ['25544']);

%%

analWindow = 5;
TLEpath = [pwd '/HistoryISS'];
mod.ali(char(historyFile), TLEpath);
propOut = homeSgp4([pwd '\' char(historyFile)], analWindow);
propSort = sortrows(propOut, 'stopTime', 'ascend');

findReferences = propSort.deltaT == 0;
referenceTLEs = propSort(findReferences, :);
clear findReferences
%% Finding difference between propagated and epoch in UVW frame

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
    
    Umat = [x y z] / norm([x y z]);
    Wmat = cross([x y z], [u v w]) / norm(cross([x y z], [u v w]));
    Vmat = cross(Wmat, Umat);
    
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
scatterPlotBars('UxDiff', propSortdT.deltaT, propSortdT.UxDiff)
scatterPlotBars('VxDiff', propSortdT.deltaT, propSortdT.VxDiff)
scatterPlotBars('WxDiff', propSortdT.deltaT, propSortdT.WxDiff)
scatterPlotBars('UvDiff', propSortdT.deltaT, propSortdT.UvDiff)
scatterPlotBars('VvDiff', propSortdT.deltaT, propSortdT.VvDiff)
scatterPlotBars('WvDiff', propSortdT.deltaT, propSortdT.WvDiff)

%% Binning deltas by half a day
bins = 0:0.5:analWindow;

propSortdT.bin = discretize(propSortdT.deltaT, bins);

for i = 1:length(bins)
    binFind = propSortdT.bin == i;
    bin.(['bin_' num2str(i)]) = propSortdT(binFind, :);
end