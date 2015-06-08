function [ctr_M co2x2_M H lon lat lev] = essgcm_read(num_year,num_month,var,layer,dim,FLAG_ttest,data_type); 

addpath('/export/home/yuchiaol/matlab_tools/matlab_functions/data_rearrange/');
addpath('/export/home/yuchiaol/matlab_tools/matlab_functions/average/');

dirname_ctr = '/data9/jinyi/yuchiaol/data/climate_change_co2x2/essgcm14/';
dirname_co2x2 = '/data9/jinyi/yuchiaol/data/climate_change_co2x2/essgcm15/';


filename = 'essgcm14.cam2.h0.0001-12.nc';
[T] = nc_var_read([dirname_ctr filename],'T','double');
[lat] = nc_var_read([dirname_ctr filename],'lat','double');
[lon] = nc_var_read([dirname_ctr filename],'lon','double');
[lev] = nc_var_read([dirname_ctr filename],'lev','double');
[area] = lon_lat_area_average_uniform(lon,lat);

if 0
II = 0;
for NY = 1:21;for NM = 1:12;
II = II +1
filename = ['essgcm14.cam2.h0.00' num2str(NY-1,'%2.2d') '-' num2str(NM,'%2.2d') '.nc'];
[Temp] = nc_var_read([dirname_ctr filename],var,data_type);
TS_Temp_ctr(II) = nansum(nansum(Temp(:,:,layer).*area))/nansum(nansum(area));
filename = ['essgcm15.cam2.h0.00' num2str(NY-1,'%2.2d') '-' num2str(NM,'%2.2d') '.nc'];
[Temp] = nc_var_read([dirname_co2x2 filename],var,data_type);
TS_Temp_co2x2(II) = nansum(nansum(Temp(:,:,layer).*area))/nansum(nansum(area));
end;end;
TS_time = [1:length(TS_Temp_ctr)];
figure;
plot(TS_time,TS_Temp_ctr-273.15,'b-',TS_time,TS_Temp_co2x2-273.15,'r-');
end

num_M = num_month(end) - num_month(1) + 1;
II = 0;
for NY = num_year(1):num_year(2);
for NM = num_month(1):num_month(2);
II = II +1
filename = ['essgcm14.cam2.h0.00' num2str(NY-1,'%2.2d') '-' num2str(NM,'%2.2d') '.nc'];
[V_temp] = nc_var_read([dirname_ctr filename],var,data_type);
if dim == 3;
   V_ctr(:,:,:,II)=V_temp(:,:,layer(1):layer(end));clear V_temp;
elseif dim == 2;
   V_ctr(:,:,II)=V_temp(:,:);clear V_temp;
end;
filename = ['essgcm15.cam2.h0.00' num2str(NY-1,'%2.2d') '-' num2str(NM,'%2.2d') '.nc'];
[V_temp] = nc_var_read([dirname_co2x2 filename],var,data_type);
if dim == 3
   V_co2x2(:,:,:,II)=V_temp(:,:,layer(1):layer(end));clear V_temp;
elseif dim == 2
   V_co2x2(:,:,II)=V_temp(:,:);clear V_temp;
end
end;
if dim == 3
ctr_M(:,:,:,NY-num_year(1)+1) = nanmean(V_ctr(:,:,:,(NY-num_year(1))*num_M+1:(NY-num_year(1)+1)*num_M),4);
co2x2_M(:,:,:,NY-num_year(1)+1) = nanmean(V_co2x2(:,:,:,(NY-num_year(1))*num_M+1:(NY-num_year(1)+1)*num_M),4);
elseif dim ==2
ctr_M(:,:,NY-num_year(1)+1) = nanmean(V_ctr(:,:,(NY-num_year(1))*num_M+1:(NY-num_year(1)+1)*num_M),3);
co2x2_M(:,:,NY-num_year(1)+1) = nanmean(V_co2x2(:,:,(NY-num_year(1))*num_M+1:(NY-num_year(1)+1)*num_M),3);
end
end;
size(ctr_M)
size(co2x2_M)

if FLAG_ttest == 1
for II = 1:size(ctr_M,1);for JJ = 1:size(ctr_M,2); for KK = 1:size(ctr_M,3);
[H(II,JJ,KK) P(II,JJ,KK)]=ttest2(ctr_M(II,JJ,KK,:),co2x2_M(II,JJ,KK,:),0.1);
end;end;end;
H(H==0)=nan;
end
H=0;
