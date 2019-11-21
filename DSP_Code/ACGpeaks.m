%%%%%%%%%%%%%%%%%%%%
% Created by:
%     Nathan Ruprecht
% Last edited on:
%     30 October 2019
% Purpose:
%     Eh
%%%%%%%%%%%%%%%%%%%%
function [A, C, E, N2, O, RFW, SFW] = ACGpeaks(data, num)
    Fs = 100;
    bpm = 200;
    A=[];
    C=[];
    N1=[];
    E=[];
    N2=[];
    O=[];
    F=[];
    RFW=[];
    SFW=[];

    [~, all_max] = findpeaks(data);
    thresh = prctile(data(all_max),num);
    ticks = round(Fs*60/bpm);
    [~, E] = findpeaks(data,'MinPeakHeight',thresh,...
        'MinPeakDistance',ticks);
    [~, minimas] = findpeaks(-data);

    for i=3:length(all_max)
        if ismember(all_max(i), E)            
            A_max = max([data(all_max(i-1)), data(all_max(i-2))]);
            if A_max == data(all_max(i-1))
                i_max = all_max(i-1);
            else
                i_max = all_max(i-2);
            end
            A = vertcat(A, i_max);
        end
    end

    % E=sort(E);
    % A=sort(A);

    all = sort(vertcat(minimas, A, E));

    for i=2:length(all)-1    
        if ismember(all(i-1), A) & ismember(all(i+1), E)
            C=vertcat(C,all(i));
        end

        if ismember(all(i),E)
           min_idx = find(E==all(i));
           if i-min_idx<length(minimas)

%                O_min = min([data(minimas(i-min_idx)),...
%                    data(minimas(i-min_idx+1))]);
%                if O_min == data(minimas(i-min_idx))
%                    i_min = all(i+1);
%                else
%                    i_min = all(i+2);
%                end
%                O = vertcat(O, i_min); %Should be this
               O = vertcat(O, all(i+2)); %Works if ACG interval lasts entire ECG interval
               RFW=vertcat(RFW, all(i+3));
               SFW=vertcat(SFW, all(i+4));

               N2=vertcat(N2, all(i+1));
           end
        end
    end
end