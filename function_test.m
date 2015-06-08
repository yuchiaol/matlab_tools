clear all;close all;

addpath('/export/home/yuchiaol/matlab_tools/matlab_functions/data_rearrange/');

A = [3 3 3;4 4 4;5 5 5;6 7 8];
B = [nan 1 nan; 1 1 1; nan 1 1;1 nan 1];

[BB] = map2line(B,A);
[AA] = line2map(B,BB);

A
AA
