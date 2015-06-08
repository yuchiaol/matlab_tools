function [time_flow river_flow] = dai_trenberth_read

dir_name = '/raid2/data1/yuchiao/DATA/DAITREN/';
file_name = 'coastal-stns-Vol-monthly.updated-oct2007.nc';

ncid = netcdf.open([dir_name file_name],'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'time');
time = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'FLOW');
river_tmp = netcdf.getVar(ncid,varid,'double');
river_flow = squeeze(river_tmp(6,:));
netcdf.close(ncid);

%pcolor(river_tmp);shading flat;

for II = 1:length(time);
   time_flow(II) = datenum(floor(time(II)/100),mod(time(II),100),01);
end
