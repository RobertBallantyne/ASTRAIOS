function epochOut = epochConvertor(epochIn) % takes tle formatted epochs and converts to sgp4 propagable ones

%tle input comes in form YYDDD.dddddddd

% output needs to be of the form D.dddddddd since 00:00 01/01/1950

epoch1 = floor(epochIn);
% rounds the epochIn value down to give the last whole day

if epoch1 > 50000
    
    date = datetime(num2str(1900000 + epoch1), 'InputFormat', 'uuuuDDD');
    
else
    date = datetime(num2str(2000000 + epoch1), 'InputFormat', 'uuuuDDD');
end
% reads this into a matlab understandable datetime variable type

daysSince = days(date-'01-jan-1950'+1);
% as it is in datetime format you can use normal equations on it to find
% the time between these two dates, in days

epochOut = daysSince + (epochIn - epoch1);
% adds the day fraction onto the total number of days for the required
% format
end