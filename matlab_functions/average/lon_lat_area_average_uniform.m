function [area] = lon_lat_area_average_uniform(lon,lat)

dx = lon(2) - lon(1);
dy = lat(2) - lat(1);

for II = 1:length(lon);
for JJ = 1:length(lat);
   area(II,JJ) = areaquad(lat(JJ)-dy/2,lon(II)-dx/2,lat(JJ)+dy/2,lon(II)+dx/2);
end;
end;
