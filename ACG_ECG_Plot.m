for i = 1:n
    data = eval(sprintf('b%d',i));
    figure
    subplot(2,1,1);
    time = data(:,1);
    ACG = data(:,2);
    ECG = data(:,3);
    plot(time, ACG);
    title(sprintf('ACG Trial %d', i));
    subplot(2,1,2);
    plot(time, ECG);
    title(sprintf('ECG Trial %d', i));
end