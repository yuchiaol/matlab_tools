function [output_map] = line2map(mask_map,input_line)
%
map_dim = size(mask_map);
output_line = squeeze(zeros(1,prod(map_dim)));
mask_line = reshape(mask_map,1,[]);

ipt = 0;
for II = 1:length(mask_line);
   if (mask_line(II)==0);
      output_line(II) = nan;
   else;
      ipt = ipt + 1;
      output_line(II) = input_line(ipt);
   end;
end;

output_map = reshape(output_line,map_dim);

return;
