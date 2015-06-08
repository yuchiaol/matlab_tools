function GLDAS_plot(lon,lat,cpenso,epenso,colorlevel1,colorlevel2,unit_name)

addpath('/home/yuchiao/matlab_tools/figure_setting')

figure_create(60,13);

subplot('position',[0.03 0.3 0.25 0.3])
pcolor(lon,lat,(squeeze(nanmean(cpenso,3)))');shading flat;
caxis(colorlevel1);title('cp');

subplot('position',[0.32 0.3 0.25 0.3])
pcolor(lon,lat,(squeeze(nanmean(epenso,3)))');shading flat;
h=colorbar;caxis(colorlevel1);title('ep');
set(h,'position',[0.59 0.3 0.01 0.3])
xlabel(h,unit_name)

subplot('position',[0.66 0.3 0.25 0.3])
diff_enso=(squeeze(nanmean(cpenso,3))-squeeze(nanmean(epenso,3)));
pcolor(lon,lat,diff_enso');shading flat;h=colorbar;
caxis(colorlevel2);title('cp-ep');
set(h,'position',[0.93 0.3 0.01 0.3])
cmap=colormap;colormap(flipud(cmap));
%set(h,'ytick',[-3:3]);
%set(h,'yticklabel',{'-3','-2','-1','0','1','2','3'});
xlabel(h,unit_name)

