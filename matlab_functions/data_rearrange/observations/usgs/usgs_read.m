function [TS_out TS_time] = usgs_read;

load /raid/yuchiao/usgs/TS_discharge_usgs.mat;

file = '/raid/yuchiao/usgs/measurements.txt';
fid = fopen(file,'r');
for II = 1:16
   fgetl(fid);
end

AV = 0;
for II = 1:length(discharge_usgs);
AV = AV + 1;
temp=fscanf(fid,'%s',3);
date_ori=fscanf(fid,'%s',1);
time_ori=fscanf(fid,'%s',1);
%temp=fscanf(fid,'%s',5);
%discharge_ori=fscanf(fid,'%s',1);
fgetl(fid);
date_num(AV)=datenum(str2num(date_ori(1:4)),str2num(date_ori(6:7)),str2num(date_ori(9:10)));
end
fclose(fid)

TS_out = discharge_usgs; 
TS_time = date_num';



