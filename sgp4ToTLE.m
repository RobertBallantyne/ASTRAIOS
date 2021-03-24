function epochOut = sgp4ToTLE(epochIn)
percentDay = epochIn - floor(epochIn);
date = datetime('01-jan-1950') + days(floor(epochIn));

daynumber = day(date, 'dayofyear');
epochOut = 21000 + daynumber + 1 + percentDay;
end