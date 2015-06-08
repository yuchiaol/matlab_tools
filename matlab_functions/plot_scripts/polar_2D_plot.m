function polar_2D_plot(cover_temp,lon,lat,crange,view_angle)

cover = [cover_temp cover_temp(:,1)];

coast = load('coast');
figure('Color','w');
axesm('eqaazim','MapLatLimit',view_angle);
axis off; framem on; gridm on; mlabel on; plabel on;
setm(gca,'MLabelParallel',0);
geoshow(coast.lat,coast.long,'DisplayType','polygon');
Ref = georasterref('RasterSize', size(cover),'Latlim', [lat(1) lat(end)], 'Lonlim', [lon(1) lon(end)+2.5]);
geoshow(cover(1:end,1:end),Ref,'DisplayType','texturemap');
colorbar;
caxis(crange);

