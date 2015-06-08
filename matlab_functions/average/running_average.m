function [TS_out] = running_average(TS_in,window_size)

% window_size should be odd number

N1 = (window_size-1)/2;
TS_out = ones(1,length(TS_in));
TS_out(:) = nan;

for II = N1+1:length(TS_in)-N1;
   TS_out(II) = mean(TS_in(II-N1:II+N1));
end;

return;
