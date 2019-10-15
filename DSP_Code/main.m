filename='Abby.mat';

noise=0.5;
% data(1:N,1:3,1:10000)=noise;
% b1=[];
% b2=[];
% b3=[];
% b4=[];
% b5=[];
% for i=1:N
%     %load b intervals from person i
%     clear sprintf
%     load(sprintf('%d.mat',i));
%     
%     %process data and reformat/save into 'data'
%     vector=process(b1, b2, b3, b4, b5, n, noise);
%     data(i,2,1:length(vector(:,2)))=vector(:,2);
%     data(i,3,1:length(vector(:,3)))=vector(:,3);
%     
%     %make b intervals all noise to avoid reusing data
%     clear sprintf
%     for c=1:5
%         sprintf('b%d',c)=noise;
%     end
% end

data = combine(filename, noise);
data(:,2) = FIR(data(:,2), 5, 20);
data(:,3) = FIR(data(:,3), 5, 40);

[P, Q, R, S, T] = ECGpeaks(data(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot all ACG+ECG subplots for each person
names={'Abby' 'Bijay' 'Dr. Tavakolian' 'Parshuram' 'Rabie' 'acg 9.26.19'};
t=linspace(1,length(data),length(data));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting a specific person
figure
subplot(2,1,1)
plot(t,data(:,2))
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