function [GRAD]=BRcolor
%grad1=colorGradient([0.5 0.8 1],[1 1 1],128);grad2=colorGradient([1 1 1],[1 0 0],128);
grad1=colorGradient([0 0.21 1],[1 1 1],128);grad2=colorGradient([1 1 1],[1 0 0],128);

GRAD=[grad1;grad2];

