
function x1 = cnn_load_init()

load('Ball_DE_0007.mat');                                             %%% label 1 
x1(:,1) = X118_DE_time(1:120000);


load('IR_DE_0007.mat');                                               %%% label 2 
x1(:,2) = X105_DE_time(1:120000);


load('OR_DE_0007.mat');                                               %%% label3
x1(:,3) = X130_DE_time(1:120000);


load('NORMAL.mat');                                                   %%% label4
x1(:,4) = X097_DE_time(1:120000); 


end 
