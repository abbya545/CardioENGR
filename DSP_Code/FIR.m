%%%%%%%%%%%%%%%%%%%%
% Created by:
%     Nathan Ruprecht
% Last edited on:
%     19 October 2019
% Purpose:
%     Uses a Hamming, finite impulse response (FIR) window filter both
%     forward and reverse
%%%%%%%%%%%%%%%%%%%%
function [out] = FIR(in, Fp, Fc)
    Astop = 45;
    Apass = 5;
    Fs = 100;
    n=30;
    Wn = [(2/Fs)*Fp, (2/Fs)*Fc];
    b = fir1(n, Wn);
    out=filter(b, 1, in);
    
    %reverse filter to remove time delays
    out=fliplr(out);
    out=filter(b, 1, out);
    out=fliplr(out);
    
    
end