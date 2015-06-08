function [output_line] = map2line(mask_map,input_map)

map_dim = size(input_map);

output_line = zeros(prod(map_dim));
input_line = reshape(input_map,1,[]);
mask_line = reshape(mask_map,1,[]);

ipt = 0;

for II = 1:length(output_line)
   if (mask_line(II)==1);
      ipt = ipt + 1;
      output_line(ipt) = squeeze(input_line(II));
   end
end
output_line = squeeze(output_line(1:ipt));

return;
