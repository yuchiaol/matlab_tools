function [output] = nc_var_read(filename,var,var_type)

ncid = netcdf.open(filename,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,var);
output = netcdf.getVar(ncid,varid,var_type);
netcdf.close(ncid);

