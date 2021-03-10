function [jd] = tle2jd(ds)
yeardayhour = str2double(regexp(ds, '(\d{2})(\d{3})(\.\d+)', 'tokens', 'once'));
dn = datenum(yeardayhour(1) + 2000, 0, yeardayhour(2), 24 * yeardayhour(3), 0, 0);
dt = datetime(dn, 'ConvertFrom', 'datenum');
jd = juliandate(dt);
end

