function [output] = month_arrange_to_season(input)

output_tmp = reshape(input,12,length(input)/12);

for II = 1:4;
if II == 1;
   output(II,:) = (output_tmp(1,:)+output_tmp(2,:)+output_tmp(12,:))/3.;
else;
   output(II,:) = (output_tmp((II-1)*3,:)+output_tmp((II-1)*3+1,:)+output_tmp((II-1)*3+2,:))/3.;
end;
end;

return;
