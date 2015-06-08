function [lon lat lev output] = agcm_read(file_name,var)

ncid = netcdf.open(file_name,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lat');
lat = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lev');
lev = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,var);
temp = netcdf.getVar(ncid,varid,'double');
netcdf.close(ncid);

output=temp;
