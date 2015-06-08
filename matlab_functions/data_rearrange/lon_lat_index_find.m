function [x1 x2 y1 y2] = lon_lat_index_find(lon,lat,lon_w,lon_e,lat_s,lat_n)

[Y, x1] = min(abs(lon-lon_w));
[Y, x2] = min(abs(lon-lon_e));
[Y, y1] = min(abs(lat-lat_s));
[Y, y2] = min(abs(lat-lat_n));

[lon(x1) lon(x2) lat(y1) lat(y2)]

return
