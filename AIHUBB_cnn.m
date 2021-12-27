%  CNN 입력셋 가공 
%  Grey 이미지 셋으로 변환 (4차원 데이터 셋 ) = 257x 327 x 개수 x Labeling(1,2,3,4)
clear; clc; close all;

[nf bf af] =read_file();
data = horzcat(nf, bf, af);
cnn_set = data;
%%
 % Ball/IR/Normal/OR
%writematrix(cnn_set,"Bearing_Defect.csv")

window = 8000;
stride = 1000;
fs = 4000;

cnt = 0 ;

for l = 1:72
    x = cnn_set(:,l);
    num = length(x)/stride;
    %for i= 1 : num-3
    for i= 1 : num-7
        cnt = cnt +1;

        data = x(1+ stride*(i-1) : window + stride*(i-1) );
        [s,f,t]= stft(data,fs,'Window',kaiser(256,5),'OverlapLength',220,'FFTLength',512,'FrequencyRange',"onesided");
        I = abs(s);
        J = filter2(fspecial('sobel'),I);
        I = mat2gray(J);
        image = flip(I);
        %check = (image- min(image,[],'all')) /(max(image,[],'all') - min(image,[],'all'));

        data_set_x(:,:,1,cnt) = normalize(image); % 4차원 변수 257x 327 x 개수 x cnt(총 데이터 개수 )  
       % data_set_x(:,:,1,cnt) = check; % 4차원 변수 257x 327 x 개수 x cnt(총 데이터 개수 )  

        data_set_y(cnt) = ceil(l/24) ;% 올림을 통해 Index 1,2,3,4 대입함 
    end
end
%%
stft(data,fs,'Window',kaiser(256,5),'OverlapLength',220,'FFTLength',512,'FrequencyRange',"onesided");

%% 데이터 셋 -->grey 그림 셋으로 만들기 
% Train =  [257, 327, 1, cnt ]
% Test  =  [cnt x 1 ]

PD = 0.80;
N =cnt;
idx = randperm(N);
train_index = idx(1:round(N*PD));
test_index  = idx(round(N*PD)+1:end);

X_Ptrain = data_set_x(:,:,1,train_index);
X_Ptest = data_set_x(:,:,1,test_index);

Y_Ptrain = data_set_y(train_index);
Y_Ptrain= categorical(Y_Ptrain).';

Y_Ptest = data_set_y(test_index);
Y_Ptest= categorical(Y_Ptest).';

%%
num =100
Y_Ptrain(num)

sf = 12000;
T  = 1/sf ;
L  = length(data);
X  = data - mean(data) 
f = (sf/L)* (0:L/2) ;

y= fft(x);
y_1= abs(y/L);
figure;
plot(f, y_1(1:L/2+1) )
ylim([0 0.1])


%%
layers = [
    imageInputLayer([257 216 1])
    convolution2dLayer(9,9,'NumFilters',9,'Stride',2)
    reluLayer
    dropoutLayer(0.2)
    convolution2dLayer(9,9,'NumFilters',9,'Stride',2)
    reluLayer
    dropoutLayer(0.2)

    averagePooling2dLayer(4)
    
    convolution2dLayer(16,16,'NumFilters',28,'Stride',2)
    reluLayer
    globalAveragePooling2dLayer
    fullyConnectedLayer(3)
    reluLayer
    softmaxLayer
    classificationLayer

    ];


miniBatchSize  = 50;
validationFrequency = floor(numel(data_set_y)/miniBatchSize);
options = trainingOptions('sgdm', ...
    'MiniBatchSize',miniBatchSize, ...
    'MaxEpochs',30, ...
    'ValidationData',{X_Ptest,Y_Ptest}, ...
    'Plots','training-progress', ...
    'Verbose',false);

net = trainNetwork(X_Ptrain,categorical(Y_Ptrain).',layers,options);
%net = trainNetwork(X_Ptrain,Y_Ptrain,layers,options);

%%
x = find(uint16(Y_Ptest) == 3)   
        
        cnt = x(5)
        X = X_Ptest(:,:,1,cnt);

        inputSize = net.Layers(1).InputSize(1:2); 
        X = imresize(X,inputSize);
        
        %show me the stft     
        figure
        x_axis = linspace(0,1,257);
        y_axis = linspace(0,6,327);img= imshow(X) ;
        imwrite(X,'temp.png');
        A = imread('temp.png');

        imagesc(x_axis,y_axis,flip(A));

        set(gca,'YDir','normal')
        title('STFT','FontSize',12)
        xlabel('Time[sec]') ;
        ylabel('Frequency[Khz]') ;
        
        %show me the Gradcam     
        label = classify(net,X);
        [scoreMap,featureLayer,reductionLayer] = gradCAM(net,X,label);

        figure(3)
        x_axis = linspace(0,1,257);
        y_axis = linspace(0,6,327);
        colorbar;
        imwrite(scoreMap,'tempg.png');
        A = imread('tempg.png');

        imagesc(x_axis,y_axis,flip(A));

        set(gca,'YDir','normal')
        title('Grad Cam','FontSize',22)
        ax.FontSize = 50
        xlabel('Time[sec]','FontSize',26) ;
        ylabel('Frequency[Khz]','FontSize',26) ;
        
        %predict 
        pred = classify(net,X)
%% confusion Matrix
X =X_Ptest(:,:,:,:);
pred = classify(net,X);
cm = confusionchart(Y_Ptest,pred)

