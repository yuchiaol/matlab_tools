function GLDAS_3x1plot_ttest(lon,lat,cpenso,epenso,avg_dim,colorlevel1,colorlevel2,unit_name,x1,y1,x_ratio,y_ratio,FLAG_title,mttest1,mttest2)

addpath('/home/yuchiao/matlab_tools/figure_setting')
load /home/yuchiao/matlab_tools/coastline/GSHHS_COAST220HL1.mat;
load conus.mat

%x1 y1 x_ratio y_ratio
subplot('position',[x1 y1 x_ratio y_ratio])
pcolor(lon,lat,(squeeze(nanmean(cpenso,avg_dim)))'.*mttest1');shading flat;
caxis(colorlevel1);
if (FLAG_title==1);title('CP');end;
hold on;plot(GSHHS_COAST220HL1(:,1)-360,GSHHS_COAST220HL1(:,2),'k-');hold on;
plot(statelon,statelat,'k-');hold on;
plot(gtlakelon,gtlakelat,'k-');hold on;
plot(uslon,uslat,'k-');hold off;
set(gca,'tickdir','out');

subplot('position',[x1+0.29 y1 x_ratio y_ratio])
pcolor(lon,lat,(squeeze(nanmean(epenso,avg_dim)))'.*mttest2');shading flat;
h=colorbar;caxis(colorlevel1);
if (FLAG_title==1);title('EP');end;
set(h,'position',[x1+0.56 y1 0.01 y_ratio])
xlabel(h,unit_name)
hold on;plot(GSHHS_COAST220HL1(:,1)-360,GSHHS_COAST220HL1(:,2),'k-');hold on;
plot(statelon,statelat,'k-');hold on;
plot(gtlakelon,gtlakelat,'k-');hold on;
plot(uslon,uslat,'k-');hold off;
set(gca,'tickdir','out');

subplot('position',[x1+0.63 y1 x_ratio y_ratio])
diff_enso=(squeeze(nanmean(cpenso,3))-squeeze(nanmean(epenso,avg_dim)));
pcolor(lon,lat,diff_enso');shading flat;h=colorbar;
caxis(colorlevel2);
if (FLAG_title==1);title('CP minus EP');end;
set(h,'position',[x1+0.9 y1 0.01 y_ratio])
%cmap=colormap;colormap(flipud(cmap));
%set(h,'ytick',[-3:3]);
%set(h,'yticklabel',{'-3','-2','-1','0','1','2','3'});
xlabel(h,unit_name)
hold on;plot(GSHHS_COAST220HL1(:,1)-360,GSHHS_COAST220HL1(:,2),'k-');hold on;
plot(statelon,statelat,'k-');hold on;
plot(gtlakelon,gtlakelat,'k-');hold on;
plot(uslon,uslat,'k-');hold off;
set(gca,'tickdir','out');

