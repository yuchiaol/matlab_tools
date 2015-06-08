function eof_plot(lon,lat,tt,eof,PC,EXPVAR,eof_N);

addpath('/export/home/yuchiaol/matlab_tools/figure_setting');
addpath('/export/home/yuchiaol/matlab_tools/matlab_functions/plot_scripts');
load /data9/jinyi/yuchiaol/data/coastline/GSHHS_COAST220HL1.mat;
load /export/home/yuchiaol/matlab_tools/colorbar/color_test.mat;

% NPSH
lat_s_NPSH = 23; lat_n_NPSH = 45;
lon_w_NPSH = 180+(180-165); lon_e_NPSH = 180+(180-121);
% WNPSH
lat_s_WNPSH = 15; lat_n_WNPSH = 25;
lon_w_WNPSH = 110; lon_e_WNPSH = 150;
% calculate corresponding indices
[x1_WNPSH x2_WNPSH y1_WNPSH y2_WNPSH] = lon_lat_index_find(lon,lat,lon_w_WNPSH,lon_e_WNPSH,lat_s_WNPSH,lat_n_WNPSH);
[x1_NPSH x2_NPSH y1_NPSH y2_NPSH] = lon_lat_index_find(lon,lat,lon_w_NPSH,lon_e_NPSH,lat_s_NPSH,lat_n_NPSH);

% variance (nomalized eigenvalue) plot
figure;
plot([1:eof_N],EXPVAR(1:eof_N),'x','markersize',10,'linewidth',2);
hold on;
plot([1:eof_N],EXPVAR(1:eof_N),'k-');
grid on;
set(gca,'fontsize',14,'fontweight','b');
ylabel('Explained Variance (%)','fontsize',14,'fontweight','b');
xlabel('Eigenvalue');
set(gca,'xlim',[1 eof_N]);
hold off;
print('-depsc2','-r400','exp_var');

% eof spatial pattern plot with principle component
figure_create(60,30);

for II = 1:4;

subplot('position',[0.04+(II-1)*0.24 0.6 0.21 0.3]);
pcolor(lon,lat,squeeze(eof(II,:,:))');shading flat;%colorbar;
caxis([-0.1 0.1]);
hold on;
plot(GSHHS_COAST220HL1(:,1),GSHHS_COAST220HL1(:,2),'k-');
title(['EOF Mode ' num2str(II) ' (' num2str(EXPVAR(II)) ' %)']);
set(gca,'ytick',[20:10:60]);
if II == 1;
set(gca,'yticklabel',{'20N','30N','40N','50N','60N'});
else;
set(gca,'yticklabel',{'','','','',''});
end;
set(gca,'xtick',[120:30:240]);
set(gca,'xticklabel',{'120E','150E','180','150W','120W'});
set(gca,'fontsize',8);
set(gca,'tickdir','out');
if II == 4;
h=colorbar('hori');
set(h,'position',[0.04 0.53 0.93 0.02]);
end
colormap(GRAD);
plot_box(lon,lat,x1_WNPSH,x2_WNPSH,y1_WNPSH,y2_WNPSH,'k-',2);
plot_box(lon,lat,x1_NPSH,x2_NPSH,y1_NPSH,y2_NPSH,'k-',2);
hold off;
subplot('position',[0.04+(II-1)*0.24 0.13 0.21 0.3]);
plot(tt,PC(II,:),'k-');
PC_smoothed = smoothts(PC(II,:),'b',13);
hold on;
plot(tt,PC_smoothed,'r-','linewidth',2);
title(['PC ' num2str(II)]);
set(gca,'ylim',[min(PC_smoothed)-20 max(PC_smoothed)+20]);
set(gca,'xlim',[tt(1) tt(end)]);
set(gca,'xtick',[1950:10:2010]);
set(gca,'xticklabel',{'50','60','70','80','90','00','10'});
set(gca,'fontsize',8);
hold off;

end;

print('-depsc2','-r400','eof_1_4');

if 0
figure_create(60,30);

for II = 1:4;

subplot('position',[0.04+(II-1)*0.24 0.6 0.21 0.3]);
pcolor(lon,lat,squeeze(eof(II+4,:,:))');shading flat;%colorbar;
caxis([-0.1 0.1]);
hold on;
plot(GSHHS_COAST220HL1(:,1),GSHHS_COAST220HL1(:,2),'k-');
title(['EOF Mode ' num2str(II+4) ' (' num2str(EXPVAR(II+4)) ' %)']);
set(gca,'ytick',[20:10:60]);
if II == 1;
set(gca,'yticklabel',{'20N','30N','40N','50N','60N'});
else;
set(gca,'yticklabel',{'','','','',''});
end;
set(gca,'xtick',[120:30:240]);
set(gca,'xticklabel',{'120E','150E','180','150W','120W'});
set(gca,'fontsize',8);
set(gca,'tickdir','out');
if II == 4;
h=colorbar('hori');
set(h,'position',[0.04 0.53 0.93 0.02])
end
colormap(GRAD)
hold off;

subplot('position',[0.04+(II-1)*0.24 0.13 0.21 0.3]);
plot(tt,PC(II,:),'k-');
PC_smoothed = smoothts(PC(II+4,:),'b',13);
hold on;
plot(tt,PC_smoothed,'r-','linewidth',2);
title(['PC ' num2str(II+4)]);
set(gca,'ylim',[min(PC_smoothed)-20 max(PC_smoothed)+20]);
set(gca,'xlim',[tt(1) tt(end)]);
set(gca,'xtick',[1950:10:2010]);
set(gca,'xticklabel',{'50','60','70','80','90','00','10'});
set(gca,'fontsize',8);
hold off;

end;

end;
%print('-depsc2','-r400','eof_5_8');

return;
