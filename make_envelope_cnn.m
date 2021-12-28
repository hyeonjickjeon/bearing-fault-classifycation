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

