# 매틀랩 코드 


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
- make_sample_은  3초의 신호를 샘플 생성을 위해 분해 후 각 raw data 들을 statical feature / enevelope  feature/ wavelet feature 모두 생성시켜서 66개를 생성시킨다 
- - make sample 입력값(입력 데이터 , 3초 데이터를 몇개로 쪼갤 것인지,72행 중 1개 선택  )

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
-  다음은 순차적으로 통계적 추출기법, Wavelet Packet, Envelope 함수이다. (참고)



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
















