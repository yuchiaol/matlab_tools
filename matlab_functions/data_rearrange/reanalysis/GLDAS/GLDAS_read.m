function [output lon lat] = GLDAS_read(FLAG_run,FLAG_check,FLAG_matsave,year,var,latS,latN,lonW,lonE,mfile,dimension)

if (FLAG_run==1);

dirname = '/raid/yuchiao/GLDAS/nc/';
file = [dirname 'GLDAS_NOAH10_M.A197804.020.nc'];
ncid = netcdf.open(file,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'lon');
lon_nc = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lat');
lat_nc = netcdf.getVar(ncid,varid,'double');
if (FLAG_check==1);
   varid = netcdf.inqVarID(ncid,var);
   temp = netcdf.getVar(ncid,varid,'double');
   temp(abs(temp)>10^30)=nan;
   %figure;pcolor(lon,lat,temp');shading flat;colorbar;
end;
netcdf.close(ncid);

[v I_W] = min(abs(lon_nc-lonW));
[v I_E] = min(abs(lon_nc-lonE));
[v I_S] = min(abs(lat_nc-latS));
[v I_N] = min(abs(lat_nc-latN));

lon = lon_nc(I_W:I_E);
lat = lat_nc(I_S:I_N);

[lon(1) lon(end) lat(1) lat(end)]

if (FLAG_check==1);
   figure;pcolor(lon,lat,temp(I_W:I_E,I_S:I_N,1)');
   shading flat;colorbar;
   clear temp;
end

AV = 0;
for NY = 1:length(year);
   for NM = 1:12   
      AV = AV + 1;
      file = [dirname 'GLDAS_NOAH10_M.A' num2str(year(NY)) num2str(NM,'%2.2d') '.020.nc']
      ncid = netcdf.open(file,'NC_NOWRITE');
      varid = netcdf.inqVarID(ncid,var);
      temp = netcdf.getVar(ncid,varid,'double');
      temp(abs(temp)>10^30) = nan;
      netcdf.close(ncid);
      if (dimension==3);output(:,:,:,AV) = temp(I_W:I_E,I_S:I_N,:);clear temp;end;
      if (dimension==2);output(:,:,AV) = temp(I_W:I_E,I_S:I_N);clear temp;end;
   end
end;

if (FLAG_matsave==1);eval(['save ' mfile]);end;

else

eval(['load ' mfile ' ''output'' ''lon'' ''lat'';'])

end

