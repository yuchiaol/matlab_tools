function [eof_output PC EXPVAR] = eof_simple(lon,lat,TS_field,pc_number)

% TS_field, time should be in the first dimension
field_tmp = squeeze(mean(TS_field,1));
mask_field = ones(size(TS_field,2),size(TS_field,3));
mask_field(isnan(squeeze(field_tmp(:,:)))==1) = 0;

%pcolor(squeeze(TS_field(1,:,:))');shading flat;colorbar;

method_op = 4;
G = map2mat(mask_field,TS_field);
disp('=====> variables in eof_simple.m');
%pcolor(double(isnan(G)));shading flat;colorbar;
%size(G)
%sum(sum(isnan(G)))

[E PC EXPVAR] = caleof(G,pc_number,method_op);
eof_output = mat2map(mask_field,E);

whos

if 0
figure;
subplot(2,2,1);
pcolor(lon,lat,squeeze(eof_output(1,:,:))');shading flat;%colorbar;
title(['1st EOF (' num2str(EXPVAR(1)) '%)']);
subplot(2,2,2);
pcolor(lon,lat,squeeze(eof_output(2,:,:))');shading flat;%colorbar;
title(['2nd EOF (' num2str(EXPVAR(2)) '%)']);
subplot(2,2,3);
plot(PC(1,:));
subplot(2,2,4);
plot(PC(2,:));
end

return;
