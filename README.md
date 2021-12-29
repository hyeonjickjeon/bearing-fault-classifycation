# 준비 자료 및 데이터 
## 필요 사항 

- Matlab 
- matlab library file(m file)
- open dataset(git 파일 첨부되어있음/아래 링크 참조)

## Youtube Explanation about Research 

https://studio.youtube.com/video/wTNGG8p30rI/edit

## 논문 : 
[1] Rauber, Thomas W.; de Assis Boldt, Francisco; Varejao, Flavio Miguel (2015). Heterogeneous Feature Models and Feature Selection Applied to Bearing Fault Diagnosis. IEEE Transactions on Industrial Electronics, 62(1), 637–646.

[2] Chen, Han-Yun; Lee, Ching-Hung (2020). Vibration Signals Analysis by Explainable Artificial Intelligence (XAI) Approach: Application on Bearing Faults Diagnosis. IEEE Access, (), 1–1.

## 공유 데이터 셋 : https://aihub.or.kr/aidata/30748

# 매틀랩 코드 설명

### 각 section 별 기능 설명을 제공함(세세한 변수 설명은 일부 생략) 
### 하위 설명은 main 문 중심이며 중간에 func 설명과 함께 진행됨


## 매틀랩 코드[1]

### AI_main 문 
```Matlab

[nf bf af] =read_file();
data = horzcat(nf, bf, af);
```

- read_file: AI_hub data set 업로드 
- nf,bf,af : normal data, Bearing fault data, misalignment data Upload
- data     : 각 데이터 수평 통합  


```Matlab
result=[]
for i = 1:72;
       
        col = make_sample_(data(:,i),5,i,3);                           
        result = vertcat(result,col);
end
```
- i는 정상, 베어링 결함, 축 결함 각각 24개씩 총 72개임 
- make_sample_은  3초의 신호를 샘플 생성을 위해 분해 후 각 raw data 들을 statical feature / enevelope  feature/ wavelet feature 모두 생성시켜서 66개를 생성시 
- (입력 데이터 , 3초 데이터를 몇개로 쪼갤 것인지,72행 중 1개 선택  )

```Matlab

function col = make_sample_(x1,sample,Class_Number,n) % (DE,FE,만들 sample 수 ,Class_Number)
hz = 4000;
sec = 3;
Npoint = hz* sec ; 
interval = Npoint / sample;
col = [];
%col = make_column(x1,x2);ㅌ

    for i = 1: sample;
         a1 = x1(interval*(i-1)+1 : interval*i);
         col(i,:) = make_column_cnn(a1,Class_Number,n);
    end
    
end
```

- 3초 데이터 5개 샘플로 신호 분해 
- make_column_cnn을 활용하여 statical feature / enevelope  feature/ wavelet feature

```Matlab
function col = make_column_cnn(x1,Class_Number,n) % (DE,FE,Class_Number)
temp =[];
col = make_statical_cnn(x1); %13
temp = horzcat(temp,col);
col = make_WPE_cnn(x1); % 16
temp = horzcat(temp,col);
col = make_envelope_cnn(x1); % 36
temp = horzcat(temp,col);
col =temp;
a =[1,2,3];
    if n ==1
        col(66) = ceil(Class_Number/50);
    elseif n ==2 
        col(66) = randi(3);
    elseif n ==3 
        col(66) =ceil(Class_Number/24) ;
    end
end 
```
-  분해된 신호가 입력이 되면 개별 feature extraction 함수로 입력된 후 반환 받은 값들을 col 에 통합시킴
-  col 66번째 열은 class number 이다. class 는 1,2,3 으로 지정하였음 (1 : normal, 2: bearing fault, 3 : shaft misalignment )
-  다음은 순차적으로 통계적 추출기법, Wavelet Packet, Envelope 함수이다.  



```Matlab
function col = make_statical_cnn(x1)
data = x1;
sf = 4000;
L=length(data);
f = (sf/L)* (0:L/2);
col = [];
 % 주파수 영역에서의 Magnitude 값 * sf 
        x = data;
        y= fft(x);
        y_1= abs(y/L)* sf;

        RMS             = rms(x);
        sra             = square_root_amp(x);
        kur             = kurtosis(x);
        skw             = skewness(x);
        ppv             = peak2peak(x);
        crest           = peak2rms(x);
        impulse_f       = impulse_F(x);
        margin_f        = margin_F(x);
        shape_f         = shape_F(x);
        kur_f           = kur_F(x);
        fc              = frequency_c(y_1);   
        rMS_F           = rms(y_1);
        rvf             = root_vari_fre(x);
        col = [RMS, sra, kur, skw, ppv, crest, impulse_f, margin_f, shape_f ,kur_f, fc, rMS_F, rvf]; 
end
```

```Matlab
function E = make_WPE_cnn(x1)
wpt = wpdec(x1,4,'db4','shannon');
E = wenergy(wpt); 
end 
```


```Matlab
function col = make_envelope_cnn(x1)
data = x1;
fref_range = [5.4152, 3.5848, 4.7135, 4.9469, 3.053, 3.9874];
fs = 4000;
R_speed = 1765 / 60 ;

num = 1 ;
col = [] ;

x = data;

    for n = 1: 6 ;
        %%% 특징주파수 선정 
        char_freq = fref_range(n);
        for N_harm = 1:6;
            %%% 에너지 영역 구하기

            bpfo = char_freq * N_harm * R_speed ;
            l_percent = bpfo * 0.01;
            energy_fre_min = bpfo - l_percent;
            energy_fre_max = bpfo + l_percent;

            %%%  신호의 포락선 분석 
            [q,f,e,te] = envspectrum(x,fs);
            q  = q * length(x);

            %%%  에너지 영역 주파수 값 구하기 
            binary      = f > energy_fre_min & f < energy_fre_max;
            energy_index= find(binary);
            energy_fre  = q(energy_index);

            %%% RMS 값 보기 3차원 구조 : (결함유형, 고조파, 결함 주파수) 
            ENERGY(num) = rms(energy_fre);
            num = num + 1 ;
        end 

    end
col = ENERGY;
end
```



```matlab
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
```
- randperm 을 통해 random index 생성 
- random 하게 훈련 셋과 테스트 셋을 생성 
- 분류 모델 훈련을 위해 y (labeling) 값은 categorical 시행해야함

```matlab
fun = @(XT,yT,Xt,yt)loss(fitcknn(XT,yT, 'NumNeighbors', 10, 'Standardize', 1),Xt,yt, 'Lossfun', 'binodeviance');
c = cvpartition(Y_Ptrain,'k',10);
opts = statset('Display','iter');
[fs,history] = sequentialfs(fun,x_train,Y_Ptrain.','cv',c,'options',opts)
```
- Feature selecotion 수행 (based on knn) 


```matlab
Mdl = fitcknn(x_train,Y_Ptrain,'NumNeighbors',5,'Standardize',1);
cvMdl = crossval(Mdl); % Performs stratified 10-fold cross-validation
cvtrainError = kfoldLoss(cvMdl) ;
1-cvtrainError

[label,Score] = resubPredict(Mdl);
[X,Y,T,AUC] = perfcurve(Y_Ptrain,Score(:,num),num);
AUC
```
- knn 훈련 
- cross validation 통해 성능 비교 
- Accuracy : 1- cvtrainError
- AUC : AUC ROC score 

```matlab
Mdl = fitcecoc(x_train,Y_Ptrain);
cvMdl = crossval(Mdl); % Performs stratified 10-fold cross-validation
cvtrainError = kfoldLoss(cvMdl) ;
1-cvtrainError

[label,Score] = resubPredict(Mdl);
[X,Y,T,AUC] = perfcurve(Y_Ptrain,Score(:,num),num);
AUC
```
- SVM 훈련 (과정 knn 과 동일)

## 매틀랩 코드[2]
### AIHUBB_cnn 문 
### 훈련 및 테스트 셋 분류 [1] 설명 참고  

```matlab

clear; clc; close all;

[nf bf af] =read_file();
data = horzcat(nf, bf, af);
cnn_set = data;
```
- Data 불러오기 [1]동일 방식 


```matlab
window = 8000;
stride = 1000;
fs = 4000;
cnt = 0 ;
```
- CNN 을 위한 window size, sliding legth, sampling frequency 초기 선언 


```matlab
for l = 1:72
    x = cnn_set(:,l);
    num = length(x)/stride;
    for i= 1 : num-7
        cnt = cnt +1;

        data = x(1+ stride*(i-1) : window + stride*(i-1) );
        [s,f,t]= stft(data,fs,'Window',kaiser(256,5),'OverlapLength',220,'FFTLength',512,'FrequencyRange',"onesided");
        I = abs(s);
        J = filter2(fspecial('sobel'),I);
        I = mat2gray(J);
        image = flip(I);
        data_set_x(:,:,1,cnt) = normalize(image); % 4차원 변수 257x 327 x 개수 x cnt(총 데이터 개수 )  
        data_set_y(cnt) = ceil(l/24) ;% 올림을 통해 Index 1,2,3,4 대입함 
    end
end
```

- 입력 데이터 window 만들기 & Sliding 하기 
- STFT 시행하여 CNN 이미지 만들기
- Grey scale 로 변환 
- Data normalization
- ceil(l/24) 를 통해 24개씩 Labeling 시행 (1,2,3)


```matlab

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
```
- CNN layer 층 생성 및 hyperparameter 선언 
- 생성 및 변수 값 생성 근거는 [2] 참고함


```matlab

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
 ```
 
 - Gradcam 결과 보기 
 - classify 함수를 통해 CNN 모델의 예측 결과 값 도출
 - gradCAM 함수에 (모델, 입력변수, 예측 결과) 입력을 통해 scoremap 도출 
 - scoremap 이미지 저장 후 다시 불러와서 사용자에게 표시 
