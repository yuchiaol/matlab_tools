function plot_USA_1x1(lon,lat,enso_map,avg_dim,colorlevel,unit_name,x1,y1,x_ratio,y_ratio,FLAG_title,title_name,ttest_map,FLAG_xaxis,FLAG_yaxis,FLAG_colorbar,case_txt)

load /home/yuchiao/matlab_tools/coastline/GSHHS_COAST220HL1.mat;
load conus.mat;

%addpath('/home/yuchiao/matlab_tools/figure_setting')

subplot('position',[x1 y1 x_ratio y_ratio])
if avg_dim==0;
   pcolor(lon,lat,squeeze(enso_map)');shading interp;   
else
   pcolor(lon,lat,(squeeze(nanmean(enso_map,avg_dim)))');shading interp;
end

if (FLAG_colorbar==1);
   h=colorbar('hori');set(h,'position',[x1 y1-0.055 x_ratio 0.01]);
   %set(h,'xtick',[-2:2]);
   %set(h,'xticklabel',{'-2','-1','0','1','2'})
   %set(h,'fontweight','b')
   xlabel(h,unit_name,'fontsize',7,'fontweight','b')
end
caxis(colorlevel);
if (FLAG_title==1);
   ht=title(title_name,'fontsize',7,'fontweight','b');
   %pos = get(ht,'Position');
   %set(ht,'Position',[pos(1) pos(2)+0.5 pos(3)])
   %text(-110,59,title_name,'fontsize',7,'fontweight','b');
end;
%set(h,'position',[x1+0.16 y1 0.01 y_ratio])
%xlabel(h,unit_name,'fontsize',8)
set(gca,'tickdir','out');

hold on;
plot(GSHHS_COAST220HL1(:,1)-360,GSHHS_COAST220HL1(:,2),'k-');hold on;
plot(GSHHS_COAST220HL1(:,1),GSHHS_COAST220HL1(:,2),'k-');hold on;
%plot(statelon,statelat,'k-');hold on;
%plot(gtlakelon,gtlakelat,'k-');hold on;
%plot(uslon,uslat,'k-');hold on;

for JJ = 1:length(lat);
   plot(lon+0.5,ttest_map(:,JJ)*lat(JJ)+0.5,'k.','Markersize',1,'linewidth',3)
end

set(gca,'ytick',[-60:20:60]);
if (FLAG_yaxis==1);
   set(gca,'yticklabel',{'60S','40S','20S','0','20N','40N','60N'});
elseif (FLAG_yaxis==0)
   set(gca,'yticklabel',{'','','','','','',''});
end
set(gca,'xtick',[-150:75:150]);
if (FLAG_xaxis==1);
   set(gca,'xticklabel',{'150W','75W','0','75E','150E'}); 
elseif (FLAG_xaxis==0)
   set(gca,'xticklabel',{'','','','',''});
end

set(gca,'fontsize',7);
set(gca,'fontweight','b')

%axis([-125 -65 25 50])
text(-150,96,case_txt,'fontsize',5.5,'fontweight','b')

