function [TS_1D] = area_average(TS_2D,lon,lat,enso_index)

mask_tmp = ones(size(TS_2D,1),size(TS_2D,2));
mask_tmp(isnan(TS_2D)) = nan;

% determine the region indexes
if ( mean(enso_index == 'nino1+2') == 1 );
   display(' (IN area_average.m) The region you choose is NINO1+2.')
   lat_S = -10; lat_N = 0;
   lon_W = (180-90)+180; lon_E = (180-80)+180;
elseif ( mean(enso_index == 'nino3  ') == 1 )
   display(' (IN area_average.m) The region you choose is NINO3.')
   lat_S = -5; lat_N = 5;
   lon_W = (180-150)+180; lon_E = (180-90)+180;
elseif ( mean(enso_index == 'nino3.4') == 1 )
   display(' (IN area_average.m) The region you choose is NINO3.4.')
   lat_S = -5; lat_N = 5;
   lon_W = (180-170)+180; lon_E = (180-120)+180;
elseif ( mean(enso_index == 'nino4  ') == 1 )
   display(' (IN area_average.m) The region you choose is NINO4.')
   lat_S = -5; lat_N = 5;
   lon_W = 160; lon_E = (180-150)+180;
else
   display(' xxxooo ')
end
[v I_S] = min(abs(lat_S-lat));
[v I_N] = min(abs(lat_N-lat));I_N = I_N + 1;
[v I_W] = min(abs(lon_W-lon));I_W = I_W;
[v I_E] = min(abs(lon_E-lon));I_E = I_E + 1;
[360-lon(I_W) 360-lon(I_E) lat(I_S) lat(I_N)]

Re = 6.37*10^6;
% compute the area mean
for II = I_W:I_E-1
for JJ = I_S:I_N-1
   TS_temp(II-I_W+1,JJ-I_S+1) = 0.25*(TS_2D(II,JJ)+TS_2D(II+1,JJ)+TS_2D(II,JJ+1)+TS_2D(II+1,JJ+1));
   mask(II-I_W+1,JJ-I_S+1) = 0.25*(mask_tmp(II,JJ)+mask_tmp(II+1,JJ)+mask_tmp(II,JJ+1)+mask_tmp(II+1,JJ+1));  
   dx = Re*(lon(II+1)-lon(II))*cosd((lat(JJ+1)+lat(JJ))/2.)*pi/180;
   dy = Re*(lat(JJ+1)-lat(JJ))*pi/180;
   area(II-I_W+1,JJ-I_S+1) = dx*dy;
end
end
oareasum = 1./nansum(nansum(area.*mask));

TS_1D = squeeze(nansum(nansum(TS_temp.*area.*mask))*oareasum);




