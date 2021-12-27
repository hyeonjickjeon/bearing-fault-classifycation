clear; clc; close all;

[nf bf af] =read_file();
data = horzcat(nf, bf, af);


%%
result=[]
for i = 1:72;
       
        col = make_sample_(data(:,i),5,i,3);                            %%% (DE측정 ,FE측정 ,만들 샘플 수,Class_Number)
        result = vertcat(result,col);
end



%%
y = result(:,66);
x = result(:,1:65);
x = normalize(x);
PD = 0.8;
N =360;


idx = randperm(N);
train_index = idx(1:round(N*PD));
test_index  = idx(round(N*PD)+1:end);

X_Ptrain = x(train_index,:);
X_Ptest = x(test_index,:);

Y_Ptrain = y(train_index);
Y_Ptrain= categorical(Y_Ptrain).';

Y_Ptest = y(test_index);
Y_Ptest= categorical(Y_Ptest).';
%


x_stati_train = X_Ptrain(:,1:13);
x_WPE_train = X_Ptrain(:,14:29);
x_EN_train = X_Ptrain(:,30:65);
global_train = X_Ptrain;

x_stati_test = X_Ptest(:,1:13);
x_WPE_test = X_Ptest(:,14:29);
x_EN_test = X_Ptest(:,30:65);
global_test = X_Ptest;
%%
x_train  = X_Ptrain;
x_test   = x_EN_test;


%% 

fun = @(XT,yT,Xt,yt)loss(fitcknn(XT,yT, 'NumNeighbors', 10, 'Standardize', 1),Xt,yt, 'Lossfun', 'binodeviance');
c = cvpartition(Y_Ptrain,'k',10);
opts = statset('Display','iter');
[fs,history] = sequentialfs(fun,x_train,Y_Ptrain.','cv',c,'options',opts)


%% KNN/ AUC score 

    
Mdl = fitcknn(x_train,Y_Ptrain,'NumNeighbors',5,'Standardize',1);
cvMdl = crossval(Mdl); % Performs stratified 10-fold cross-validation
cvtrainError = kfoldLoss(cvMdl) ;
1-cvtrainError

[label,Score] = resubPredict(Mdl);
[X,Y,T,AUC] = perfcurve(Y_Ptrain,Score(:,num),num);
AUC

%% SVM 
 

Mdl = fitcecoc(x_train,Y_Ptrain);
cvMdl = crossval(Mdl); % Performs stratified 10-fold cross-validation
cvtrainError = kfoldLoss(cvMdl) ;
1-cvtrainError

[label,Score] = resubPredict(Mdl);
[X,Y,T,AUC] = perfcurve(Y_Ptrain,Score(:,num),num);
AUC


%%

c = cvpartition(y,'k',10);
opts = statset('Display','iter');
fun = @(XT,yT,Xt,yt)loss(fitcecoc(XT,yT),Xt,yt);

[fs,history] = sequentialfs(fun,x,y,'cv',c,'options',opts)



%% confusion Matrix
pred = predict(Mdl,x_test);
cm = confusionchart(Y_Ptest,pred)

%% 파일 저장법 


filename = 'AI_HUB_xtrain.xlsx';
writematrix(X_Ptrain,filename,'Sheet',1)

filename = 'AI_HUB_ytrain.xlsx';
writematrix(Y_Ptrain,filename,'Sheet',1)
