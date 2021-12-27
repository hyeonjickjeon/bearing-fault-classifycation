
function x1 = cnn_load_temp()

load('Ball_DE_0007.mat');                                               %%% label 1 
x1(:,1) = X118_DE_time(1:120000);
load('Ball_DE_0014.mat');                                               %%% label 1 
x1(:,2) = X185_DE_time(1:120000);
load('Ball_DE_0021.mat');                                               %%% label 1 
x1(:,3) = X222_DE_time(1:120000);
load('Ball_FE_0007.mat');                                               %%% label 1 
x1(:,4) = X282_FE_time(1:120000);
load('Ball_FE_0014.mat');                                               %%% label 1 
x1(:,5) = X286_FE_time(1:120000);
load('Ball_FE_0021.mat');                                               %%% label 1 
x1(:,6) = X290_FE_time(1:120000);


load('IR_DE_0007.mat');                                               %%% label 1 
x1(:,7) = X105_DE_time(1:120000);
load('IR_DE_0014.mat');                                               %%% label 1 
x1(:,8) = X169_DE_time(1:120000);
load('IR_DE_0021.mat');                                               %%% label 1 
x1(:,9) = X209_DE_time(1:120000);
load('IR_FE_0007.mat');                                               %%% label 1 
x1(:,10) = X278_FE_time(1:120000);
load('IR_FE_0014.mat');                                               %%% label 1 
x1(:,11) = X274_FE_time(1:120000);
load('IR_FE_0021.mat');                                               %%% label 1 
x1(:,12) = X270_FE_time(1:120000);


load('OR_DE_0007.mat');                                               %%% label 1 
x1(:,13) = X130_DE_time(1:120000);
load('OR_DE_0014.mat');                                               %%% label 1 
x1(:,14) = X197_DE_time(1:120000);
load('OR_DE_0021.mat');                                               %%% label 1 
x1(:,15) = X234_DE_time(1:120000);
load('OR_FE_0007.mat');                                               %%% label 1 
x1(:,16) = X294_FE_time(1:120000);
load('OR_FE_0014.mat');                                               %%% label 1 
x1(:,17) = X313_FE_time(1:120000);
load('OR_FE_0021.mat');                                               %%% label 1 
x1(:,18) = X315_FE_time(1:120000);




load('NORMAL.mat');
x1(:,19) = X097_DE_time(1:120000); 
load('NORMAL_2.mat');
x1(:,19) = X097_DE_time(1:120000); 
load('NORMAL_3.mat');
x1(:,19) = X097_DE_time(1:120000); 
load('NORMAL_4.mat');
x1(:,19) = X097_DE_time(1:120000); 
end 
