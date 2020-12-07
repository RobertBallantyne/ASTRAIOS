function datevec=epoch2datevec(tle_epoch)
ymd=floor(tle_epoch);
yr=fix(ymd/1000);
dofyr=mod(ymd,1000);
    if (yr < 57)
         year=  yr+ 2000;
    else
         year=  yr+ 1900;
    end
   
decidy=round((tle_epoch-ymd)*10^8)/10^8;
temp=decidy*24;
hh=fix(temp);
temp=(temp-hh)*60;
mm=fix(temp);
temp=(temp-mm)*60;
ss=(temp);
nd = eomday(year,1:12);
temp = cumsum(nd);
month=find(temp>=dofyr, 1 );
temp=temp(month)-dofyr;
date=nd(month)-temp;
datevec=[year,month,date,hh,mm,ss];
end