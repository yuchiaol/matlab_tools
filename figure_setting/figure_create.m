function figure_create(X,Y)

%# centimeters units
%X = 42.0;                  %# A3 paper size
%Y = 29.7;                  %# A3 paper size
xMargin = 0.5;               %# left/right margins from page borders
yMargin = 0.5;               %# bottom/top margins from page borders
xSize = X - 2*xMargin;     %# figure size on paper (widht & hieght)
ySize = Y - 2*yMargin;     %# figure size on paper (widht & hieght)

figure;
%# figure size on screen (50% scaled, but same aspect ratio)
set(gcf, 'Units','centimeters','Position',[5 5 xSize ySize]/2)

%# figure size printed on paper
set(gcf, 'PaperUnits','centimeters')
set(gcf, 'PaperSize',[X Y])
%set(gcf, 'PaperPosition',[xMargin yMargin xSize ySize])
set(gcf, 'PaperOrientation','portrait')
