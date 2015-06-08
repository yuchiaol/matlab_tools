function [thetao lon_enso lat_enso] = ORAS4_enso_region(year,var,FLAG_run,FLAG_check,FLAG_matsave,enso_latS,enso_latN,enso_lonW,enso_lonE,mfile)

%FLAG_check=0;
%FLAG_matsave=0;
layer = [1:1];

if (FLAG_run == 1);
%clear all

%enso region [160E 80W 10S 10N]
%enso_latS=-10;enso_latN=10;
%enso_lonW=160;enso_lonE=(180-80)+180;

%year = [1958:2011]
vartxt = {var};
dirname = '/raid/yuchiao/ORA-S4/monthly_1x1/';

file = [dirname 'thetao_oras4_1m_1989_grid_1x1.nc'];
ncid = netcdf.open(file,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'mask');
mask = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lat');
lat = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'lon');
lon = netcdf.getVar(ncid,varid,'double');
varid = netcdf.inqVarID(ncid,'depth');
depth = netcdf.getVar(ncid,varid,'double');
netcdf.close(ncid);

[v I_S] = min(abs(lat-enso_latS));
[v I_N] = min(abs(lat-enso_latN));I_N=I_N+1;
[v I_W] = min(abs(lon-enso_lonW));
[v I_E] = min(abs(lon-enso_lonE));I_E=I_E+1;

[lat(I_S) lat(I_N) lon(I_W) lon(I_E)]
lat_enso = lat(I_S:I_N);
lon_enso = lon(I_W:I_E); 

AV = 0;
for nt = 1:length(year)
AV = AV + 1;
for II = 1:length(vartxt);
   file = [dirname vartxt{II} '_oras4_1m_' num2str(year(nt)) '_grid_1x1.nc']
   ncid = netcdf.open(file,'NC_NOWRITE');
   %varid = netcdf.inqVarID(ncid,'so');
   eval(['varid=netcdf.inqVarID(ncid,''' vartxt{II} ''');']);
   %so = netcdf.getVar(ncid,varid,'double');
   eval(['temp=netcdf.getVar(ncid,varid,''double'');']);
   eval([vartxt{II} '(:,:,(AV-1)*12+1:AV*12)=squeeze(temp(I_W:I_E,I_S:I_N,layer,:));'])
   %so(abs(so)>10^30)=nan;
   eval([vartxt{II} '(abs(' vartxt{II} ')>10^30)=nan;']);
   netcdf.close(ncid);
end
end

else
   %load /raid/yuchiao/runoff/EC_ORAS4/MAT/ENSO/enso_region.mat
   eval(['load ' mfile])
end


if (FLAG_check == 1);

   figure;
   pcolor(lon,lat,nanmean(temp(:,:,1,1:end),4)');shading flat;
   colorbar;caxis([20 30]);

   figure;
   pcolor(lon(I_W:I_E),lat(I_S:I_N),nanmean(thetao(:,:,end-11:end),3)');shading flat;
   colorbar;caxis([20 30]);

   figure;
   diff_thetao=nanmean(thetao(:,:,end-11:end),3)-nanmean(temp(I_W:I_E,I_S:I_N,1,1:end),4);
   pcolor(lon(I_W:I_E),lat(I_S:I_N),diff_thetao');shading flat;
   colorbar;

end

if (FLAG_matsave == 1);
   display('Saving .mat file')
   clear FLAG_matsave FLAG_check FLAG_run
   %save /raid/yuchiao/runoff/EC_ORAS4/MAT/ENSO/enso_region.mat
   eval(['save ' mfile])
end

