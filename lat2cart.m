function [x,y,z] = lat2cart(lat,long,rad)
x = rad * cosd(lat) * cosd(long);       %x coord of iss
y = rad * cosd(lat) * sind(long);       %y coord of iss
z = rad * sind(lat);                    %z coord of iss
end

