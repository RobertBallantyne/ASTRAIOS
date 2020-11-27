function epochOut = epochConvertor(epochIn) % takes tle formatted epochs and converts to sgp4 propagable ones

%tle input comes in form YYDDD.dddddddd

% output needs to be of the form D.dddddddd since 00:00 01/01/1950

epoch1 = round(epochIn);
% rounds the epochIn value to no decimal places which returns the date it
% refers to as it is yyDDD.etc

date = datetime(num2str(epoch1), 'InputFormat', 'yyDDD');
% reads this into a matlab understandable datetime variable type

daysSince = days(date-'01-jan-1950');
% as it is in datetime format you can use normal equations on it to find
% the time between these two dates, in days

epochOut = daysSince + (epochIn - epoch1);
% adds the day fraction onto the total number of days for the required
% format
end