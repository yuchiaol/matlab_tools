function [output lon lat] = GLDAS_read(FLAG_run,FLAG_check,FLAG_matsave,year,var,latS,latN,lonW,lonE,mfile)

if (FLAG_run==1);

dirname = '/raid/yuchiao/NLDAS/nc/';
file = [dirname 'NLDAS_NOAH0125_M.A199412.002.nc'];
ncid = netcdf.open(file,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lat');
lat = netcdf.getVar(ncid,varid,'double');
if (FLAG_check==1);
   varid = netcdf.inqVarID(ncid,var);
   temp = netcdf.getVar(ncid,varid,'double');
   temp(abs(temp)>10^30)=nan;
   %figure;pcolor(lon,lat,temp');shading flat;colorbar;
end;
netcdf.close(ncid);

[lon(1) lon(end) lat(1) lat(end)]

if (FLAG_check==1);
   figure;pcolor(lon,lat,temp');
   shading flat;colorbar;
   clear temp;
end

AV = 0
for NY = 1:length(year);
   for NM = 1:12   
      AV = AV + 1;
      file = [dirname 'NLDAS_NOAH0125_M.A' num2str(year(NY)) num2str(NM,'%2.2d') '.002.nc']
      ncid = netcdf.open(file,'NC_NOWRITE');
      varid = netcdf.inqVarID(ncid,var);
      temp = netcdf.getVar(ncid,varid,'double');
      temp(abs(temp)>10^30) = nan;
      netcdf.close(ncid);
      output(:,:,AV) = temp;clear temp;
   end
end;

if (FLAG_matsave==1);eval(['save ' mfile]);end;

else

eval(['load ' mfile ' ''output'' ''lon'' ''lat'';'])

end

