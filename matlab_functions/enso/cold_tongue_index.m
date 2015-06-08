function [CTI] = cold_tongue_index(yr_st,yr_end);

addpath('/data11/home/yuchiaol/matlab_tools/matlab_functions/data_rearrange');
addpath('/data11/home/yuchiaol/matlab_tools/matlab_functions/average');

N_yr = yr_end-yr_st+1;

% construct CTI to represent ENSO signal
dirname = '/data9/jinyi/yuchiaol/data/ERRST/';
filename = 'sst.mnmean.nc';
[lat] = nc_var_read([dirname filename],'lat','double');
lat = flipdim(lat,1);
[lon] = nc_var_read([dirname filename],'lon','double');
[area] = lon_lat_area_average_uniform(lon,lat);
[sst_tmp] = nc_var_read([dirname filename],'sst','double');
sst_tmp(sst_tmp==32767) = nan;
sst = 0.01*sst_tmp(:,:,(yr_st-1854)*12+1:(yr_st-1854)*12+N_yr*12);
clear sst_tmp;
sst = flipdim(sst,2);

lat_s = -6; lat_n = 6;
lon_w = 180; lon_e = 270;
[x1 x2 y1 y2] = lon_lat_index_find(lon,lat,lon_w,lon_e,lat_s,lat_n);

[sst_clim sst_rm] = climatology_compute_remove(sst(x1:x2,y1:y2,:),3);

for II = 1:size(sst_rm,1);
   CTI(II) = nansum(nansum(squeeze(sst_rm(II,:,:)).*area(x1:x2,y1:y2)))/nansum(nansum(area(x1:x2,y1:y2)));
end

return;
