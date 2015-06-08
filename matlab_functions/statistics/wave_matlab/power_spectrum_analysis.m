function power_spectrum_analysis(TS,xlim,dt,ref_year,period_interval,title1,title2,title3,title4,ylabel1,units,period_position)
% this function is modified from wavetest.m 10/30/2014.
% normalize by standard deviation (not necessary, but makes it easier
% to compare with plot on Interactive Wavelet page, at
% "http://paos.colorado.edu/research/wavelets/plot/"

variance = std(TS)^2;
TS = (TS-mean(TS))/sqrt(variance);

n = length(TS);
% dt uses unit 'year', dt = 0.25 mean 3 season or seasonal length.
%dt = 0.25 ; % seasonal time length
time = [0:length(TS)-1]*dt + ref_year;  % construct time array
%xlim = [1870,2000];  % plotting range
pad = 1;      % pad the time series with zeroes (recommended)
dj = 0.25;    % this will do 4 sub-octaves per octave
s0 = 2*dt;    % this says start at a scale of 6 months
j1 = 7/dj;    % this says do 7 powers-of-two with dj sub-octaves each
lag1 = 0.72;  % lag-1 autocorrelation for red noise background
mother = 'Morlet';

% Wavelet transform:
[wave,period,scale,coi] = wavelet(TS,dt,pad,dj,s0,j1,mother);
power = (abs(wave)).^2 ;        % compute wavelet power spectrum

% Significance levels: (variance=1 for the normalized SST)
[signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,-1,-1,mother);
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = power ./ sig95;         % where ratio > 1, power is significant

% Global wavelet spectrum & significance levels:
global_ws = variance*(sum(power')/n);   % time-average over all times
dof = n - scale;  % the -scale corrects for padding at edges
global_signif = wave_signif(variance,dt,scale,1,lag1,-1,dof,mother);

% Scale-average between El Nino periods of 2--8 years
avg = find((scale >= 2) & (scale < 8));
Cdelta = 0.776;   % this is for the MORLET wavelet
scale_avg = (scale')*(ones(1,n));  % expand scale --> (J+1)x(N) array
scale_avg = power ./ scale_avg;   % [Eqn(24)]
scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,-1,[2,7.9],mother);

%whos

%------------------------------------------------------ Plotting

%--- Plot time series
figure;

subplot('position',[0.1 0.75 0.65 0.2]);
plot(time,TS);
set(gca,'XLim',xlim(:));
%xlabel('Time (year)')
ylabel([ylabel1 ' (' units ')']);
%title('a) NINO3 Sea Surface Temperature (seasonal)')
title(title1);
hold off;

%--- Contour plot wavelet power spectrum
subplot('position',[0.1 0.37 0.65 0.28]);
levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16];
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
contour(time,log2(period),log2(power),log2(levels),'k');  %*** or use 'contourfill'
%imagesc(time,log2(period),log2(power));  %*** uncomment for 'image' plot
hold on;
contourf(time,log2(period),log2(power),log2(levels));
load spine;map = flipdim(map,1);colormap(map);
%xlabel('Time (year)');
ylabel('Period (years)');
%title('b) NINO3 SST Wavelet Power Spectrum');
title(title2);
set(gca,'XLim',xlim(:));
set(gca,'YLim',log2(period_interval),'YDir','reverse');
set(gca,'ytick',[log2(period_interval(1)):log2(period_interval(end))]);
set(gca,'yticklabel',2.^[log2(period_interval(1)):log2(period_interval(end))]);
%  Original y-axis setting
if 0;
set(gca,'YLim',log2([min(period),max(period)]),'YDir','reverse','YTick',log2(Yticks(:)),'YTickLabel',Yticks);
end;
% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
hold on;
contour(time,log2(period),sig95,[-99,1],'k');
hold on;
% cone-of-influence, anything "below" is dubious
plot(time,log2(coi),'k');
hold off;


%--- Plot global wavelet spectrum
subplot('position',[0.77 0.37 0.2 0.28]);
plot(global_ws,log2(period));
N = 0;
for II = 2:length(global_ws)-1;
   if global_ws(II)>=global_ws(II+1) & global_ws(II)>=global_ws(II-1);
      N = N + 1;
      mark_index(N) = II;
   end;
end;
%period(mark_index)
hold on;
plot(global_signif,log2(period),'--');
hold off;grid on;
xlabel(['Power (' units '^2)']);
%[period(mark_index(1))+0.5,mark_index(1)]
for II = 1:3
text(global_ws(mark_index(II))+period_position,log2(period(mark_index(II))),[num2str(period(mark_index(II)),'%.2f')]);
end
%title('c) Global Wavelet Spectrum')
%title({title3;['Period: ' num2str(period(mark_index(1)),'%.1f') ', ' num2str(period(mark_index(2)),'%.1f') ', ' num2str(period(mark_index(3)),'%.1f') ' (yr)']});
title(title3);
set(gca,'YLim',log2(period_interval),'YDir','reverse');
set(gca,'ytick',[log2(period_interval(1)):log2(period_interval(end))]);
set(gca,'yticklabel','');
% Original y-axis setting
if 0;
set(gca,'YLim',log2([min(period),max(period)]),'YDir','reverse','YTick',log2(Yticks(:)),'YTickLabel','');
end;
set(gca,'XLim',[0,1.25*max(global_ws)]);

if 0;
%--- Plot 2--8 yr scale-average time series
subplot('position',[0.1 0.07 0.65 0.2]);
plot(time,scale_avg);
set(gca,'XLim',xlim(:));
xlabel('Time (year)');
ylabel(['Avg variance (' units '^2)']);
%title('d) 2-8 yr Scale-average Time Series')
title(title4);
hold on;
plot(xlim,scaleavg_signif+[0,0],'--');
hold off;

end;

return;
% end of code


