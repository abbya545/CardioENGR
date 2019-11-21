%%%%%%%%%%%%%%%%%%%%
% Created by:
%     Nathan Ruprecht
% Last edited on:
%     19 October 2019
% Purpose:
%     Take in a recording of heart signals, detrend, filter, delete noisy
%     intervals, then find peaks respective to the type of signal.
%%%%%%%%%%%%%%%%%%%%
clc
clearvars

filename='Brad_ACG100119.mat'; %has intervals, code detects 8 intervals
% filename='Bijay11_7.mat'; %has intervals, code not detecting
% filename='Kouhyar_ACG100119.mat'; %has intervals, code not detecting

noise=0.5;
data = combine(filename, noise);

Fc=8;
Fs=100;
filterOrder=20;
[b,a]=butter(filterOrder, Fc/(Fs/2));

% %lowpass() uses minimum order filtering and seems to help
% %with finding more ACG minimas
% data(:,2) = FIR(data(:,2), 0.01, 8); %ACG filter
% data(:,2)=filtfilt(b,a,data(:,2));
data(:,2)=lowpass(data(:,2),Fc,Fs);
% temp2=data(:,2);

% data(:,2) = FIR(data(:,2), 5, 20); %PCG filter
data(:,3) = FIR(data(:,3), 5, 40);

[A, C, E, N2, O, RFW, SFW] = ACGpeaks(data(:,2), 75);
[P, Q, R, S, T] = ECGpeaks(data(:,3));

% % Find X streak of clean signal intervals
% [data,idx,window]=find_interval(data, A, C, E, P, Q, R, S, T, RFW, SFW);
% [A, C, E, N2, O, RFW, SFW] = ACGpeaks(data(:,2),60);
% [P, Q, R, S, T] = ECGpeaks(data(:,3));
    
t=linspace(1,length(data),length(data));
figure
subplot(2,1,1)
hold on
plot(t,data(:,2))
plot(A,data(A,2),'rs','MarkerFaceColor','g')
plot(C,data(C,2),'rv','MarkerFaceColor','b')
plot(E,data(E,2),'rs','MarkerFaceColor','r')
plot(N2,data(N2,2),'rv','MarkerFaceColor','r')
plot(O,data(O,2),'rv','MarkerFaceColor','g')
plot(RFW,data(RFW,2),'rs','MarkerFaceColor','r')
plot(SFW,data(SFW,2),'rv','MarkerFaceColor','r')
title(filename);
ylabel({'ACG' 'Amp(mV)'})

subplot(2,1,2)
hold on
plot(t, data(:,3))
plot(P,data(P,3),'rv','MarkerFaceColor','b')
plot(Q,data(Q,3),'rs','MarkerFaceColor','g')
plot(R,data(R,3),'rv','MarkerFaceColor','r')
plot(S,data(S,3),'rs','MarkerFaceColor','b')
plot(T,data(T,3),'rv','MarkerFaceColor','g')
xlabel('Time (s)')
ylabel({'ECG' 'Amp(mV)'})

linkaxes([subplot(2,1,1),subplot(2,1,2)],'x');

% figure
% subplot(2,1,1)
% t=linspace(1,window-idx,window-idx);
% plot(t,temp(idx:window-1))
% subplot(2,1,2)
% plot(t,temp2(idx:window-1))