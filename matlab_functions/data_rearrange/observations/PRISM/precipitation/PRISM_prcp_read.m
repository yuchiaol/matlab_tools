function [prcp lon lat] = PRISM_prcp_read(year,FLAG_run,FLAG_check,FLAG_matsave,latS,latN,lonW,lonE,mfile)

if (FLAG_run == 1);
stmonth=1;edmonth=12; 
nmonth=edmonth-stmonth+1;
dirname = '/raid/yuchiao/PRISM/precipitation/';

fid = fopen([dirname 'us_ppt_1983.10.asc'],'r');
temp = fgetl(fid);nx = str2num(temp(end-3:end));
temp = fgetl(fid);ny = str2num(temp(end-2:end));
temp = fgetl(fid);lonWW = str2num(temp(end-16:end));
temp = fgetl(fid);latSS = str2num(temp(end-17:end));
temp= fgetl(fid); cellsize = str2num(temp(end-9:end));
fgetl(fid);
temp = fscanf(fid,'%f',[1 inf]);
prcp = reshape(temp,nx,ny);
prcp(:,:) = 0;
clear temp;
fclose(fid);

%if (ENSO_type == 'CP');
%enso_year = [1969 1978 1991 1995 2002 2003 2005]
%elseif (ENSO_type == 'EP');
%enso_year = [1964 1966 1970 1973 1977 1980 1983 1987 1988 1991 1998 2004]
%elseif (ENSO_type == 'NO');
%enso_year = year
%end

AV = 0;
for NY = 1:length(year);
   for NM = stmonth:edmonth;
      AV = AV + 1;
      [year(NY) NM]
      %fid = fopen([dirname 'us_ppt_1983.10.asc','r'])
      eval(['fid=fopen(''' dirname 'us_ppt_' num2str(year(NY)) '.' num2str(NM,'%2.2d') '.asc'',''r'');'])
      for II = 1:6;fgetl(fid);end;     
      temp = fscanf(fid,'%f',[1 inf]);
      prcp_tmp = reshape(temp,nx,ny);
      prcp_tmp(abs(prcp_tmp)==9999)=nan;
      prcp_tmp = fliplr(prcp_tmp)*0.01;
      prcp(:,:,AV)=prcp_tmp;
   end
end

for II = 1:nx
   lon(II)=lonWW + (cellsize)*(II-1);
end

for II = 1:ny
   lat(II)=latSS + (cellsize)*(II-1);
end

if (FLAG_matsave==1);eval(['save -v7.3 ' mfile]);end;

else
display('loading .mat file')
eval(['load ' mfile ' ''lon'' ''lat'' ''prcp''']);

end

