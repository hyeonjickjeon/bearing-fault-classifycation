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

