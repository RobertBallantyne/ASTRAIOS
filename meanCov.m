function covarianceMean = meanCov(objectTable)
totalCovariance = zeros(3);
samples = 0;
global analWindow tThrottle fetch 
for i = 1:height(objectTable)
    [bin, covariances, error] = CovGen(objectTable(i, :).catID, analWindow);
    % use CovGen to get the covariance matrices for each time bin for this
    % thing in orbit
    if error
        continue
    end
    fields = fieldnames(covariances);
    % take all field names (the bins)
    
    totalCovariance = totalCovariance + covariances.(string(fields(end-1)))(1:3, 1:3);
    % gets the sum of all the covariances
    samples = samples + 1;
    tSince = toc(tThrottle);
    if tSince > 65 * 60
        fetch = 0;
        tThrottle = tic;
    end
    if fetch == 200
        tLeft = 55 * 60 - tSince;
        pause(tLeft)
        fetch = 0;
        tThrottle = tic;
    end
end
covarianceMean = totalCovariance / samples;
% divides by the number of objects in this section to get the mean
end