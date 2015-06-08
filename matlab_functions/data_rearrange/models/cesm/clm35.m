function [output_var lon lat] = clm35_read(FLAG_run,FLAG_check,FLAG_matsave,case1,component,year,var,latS,latN,lonW,lonE,mfile,dimension)

dirname = ['/raid2/mlo/clm/output/' case1 '/'];

if FLAG_run == 1;

file = [dirname case1 '.clm2.h0.2001-01-02-00000.nc'];
ncid = netcdf.open(file,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'landmask');
landmask = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lon');
lon_cesm = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lat');
lat_cesm = netcdf.getVar(ncid,varid,'double');
netcdf.close(ncid);
%pcolor(lon_cesm,lat_cesm,landmask');shading flat;colorbar;

[v I_S] = min(abs(latS-lat_cesm));
[v I_N] = min(abs(latN-lat_cesm));
[v I_W] = min(abs(lonW-lon_cesm));
[v I_E] = min(abs(lonE-lon_cesm));
lat=lat_cesm(I_S:I_N);
lon=lon_cesm(I_W:I_E);
[lat(1) lat(end) lon(1) lon(end)]

AV = 0;
for NY = 1:length(year);
   for NM = 1:12;
      AV=AV+1;
      file = [dirname case1 '.' component '.h1.' num2str(year(NY)) '-' num2str(NM,'%2.2d') '.nc']
      ncid = netcdf.open(file,'NC_NOWRITE');
      varid = netcdf.inqVarID(ncid,var);
      temp = netcdf.getVar(ncid,varid,'double');
      temp(abs(temp)>10^30) = nan;
      if (dimension==2);      
      output_var(:,:,AV) = temp(I_W:I_E,I_S:I_N);
      elseif(dimension==3);
      output_var(:,:,:,AV) = temp(I_W:I_E,I_S:I_N,:);
      end
      netcdf.close(ncid);
      clear temp;
   end
end
%pcolor(lon_cesm,lat_cesm,temp');shading flat;colorbar;

if (FLAG_matsave == 1);eval(['save ' mfile]);end;

else

eval(['load ' mfile]);

end


