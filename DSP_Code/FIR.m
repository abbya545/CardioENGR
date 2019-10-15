function [out] = FIR(in, Fp, Fc)
    Astop = 45;
    Apass = 5;
    Fs = 100;
    n=30;
    Wn = [(2/Fs)*Fp, (2/Fs)*Fc];
    b = fir1(n, Wn);
    out=filter(b, 1, in);
end