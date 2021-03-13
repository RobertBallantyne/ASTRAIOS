function propagationOutput = propagateMany(inputFile, analysisWindow)

allTleTable = tleTable(inputFile);
timeStep = 10;
tolerance = 1E-8;
vars = {'catID', 'x', 'y', 'z', 'u', 'v', 'w', 'startTime', 'stopTime', 'deltaT'};
vartypes = {'string', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
propagationOutput = table('Size', [0 length(vars)], 'VariableTypes', vartypes, 'VariableNames', vars);

for i = 1:height(allTleTable)-1
    refTLE = allTleTable(i, :);
    for j = i+1:height(allTleTable)
        dt = abs(allTleTable(j, :).epoch - refTLE.epoch);
        if dt > analysisWindow
            break;
        end
        t = 1:timeStep:(dt*60*60*24);
        tic
        propOut = propagateState([refTLE.x, refTLE.y, refTLE.z, refTLE.u, refTLE.v, refTLE.w], t, tolerance);
        toc
        propagationOutput = [propagationOutput; {refTLE.catID, ...
            propOut(end, :).x, propOut(end, :).y, propOut(end, :).z, ...
            propOut(end, :).u, propOut(end, :).v, propOut(end, :).w, ...
            refTLE.epoch, allTleTable(j, :).epoch, dt}];
    end
end
end