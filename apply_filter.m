clear; clc; close all;
result =[];
fs = 12000
% Machine Condition : Ball_DE_021 / (1) DE Measure, (2) FE Measure 
cnt= 20 

[x1,x2]= temp_load();
%%
for i = 1:13;
        DE = bandpass(x1(:,i),[2000 4000],fs);
        FE = bandpass(x2(:,i),[2000 4000],fs);
        col = make_sample(DE,FE,cnt,i);                            %%% (DE측정 ,FE측정 ,만들 샘플 수,Class_Number)
        result = vertcat(result,col);
end
%%

y = result(:,131);
x_global = result(:,1:130);
x_global = normalize(x_global);

PD = 0.9;

N =13 * cnt;
idx = randperm(N);
train_index = idx(1:round(N*PD));
test_index  = idx(round(N*PD)+1:end);

X_Ptrain = x_global(train_index,:);
X_Ptest = x_global(test_index,:);

Y_Ptrain = y(train_index);
Y_Ptrain= categorical(Y_Ptrain).';

Y_Ptest = y(test_index);
Y_Ptest= categorical(Y_Ptest).';
%


x_stati = X_Ptrain(:,1:26);
x_WPE = X_Ptrain(:,27:103);
x_EN = X_Ptrain(:,104:end);


%% 

fun = @(XT,yT,Xt,yt)loss(fitcknn(XT,yT, 'NumNeighbors', 10, 'Standardize', 1),Xt,yt, 'Lossfun', 'binodeviance');
c = cvpartition(y,'k',10);
opts = statset('Display','iter');
[fs,history] = sequentialfs(fun,X_Ptrain,Y_Ptrain,'cv',c,'options',opts)

%% SVM 


Mdl = fitcecoc(X_Ptrain,Y_Ptrain)
cvMdl = crossval(Mdl); % Performs stratified 10-fold cross-validation
cvtrainError = kfoldLoss(cvMdl) 

%% confusion Matrix
cnt= 1
X =X_Ptest;
pred = predict(Mdl,X_Ptest);
cm = confusionchart(Y_Ptest,pred)

%% KNN
x_Knn = result(:,1:130);

Mdl = fitcknn(X_Ptrain,Y_Ptrain,'NumNeighbors',1,'Standardize',1)
cvMdl = crossval(Mdl); % Performs stratified 10-fold cross-validation
cvtrainError = kfoldLoss(cvMdl) 


%%

c = cvpartition(y,'k',10);
opts = statset('Display','iter');
fun = @(XT,yT,Xt,yt)loss(fitcecoc(XT,yT),Xt,yt);

[fs,history] = sequentialfs(fun,x_global,y,'cv',c,'options',opts)



