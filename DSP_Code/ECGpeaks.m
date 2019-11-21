%%%%%%%%%%%%%%%%%%%%
% Created by:
%     Nathan Ruprecht
% Last edited on:
%     19 October 2019
% Purpose:
%     Eh
%%%%%%%%%%%%%%%%%%%%
function [P_wave, Q_wave, R_wave, S_wave, T_wave] = ECGpeaks(data)
    Fs = 100;
    bpm = 200;
    P_wave=[];
    Q_wave=[];
    S_wave=[];
    T_wave=[];
    
    [~, all_max] = findpeaks(data);
    thresh = prctile(data(all_max),90);
    ticks = round(Fs*60/bpm);
    [~, R_wave] = findpeaks(data,'MinPeakHeight',thresh,...
        'MinPeakDistance',ticks);
    [~, minimas] = findpeaks(-data);

    all_min = sort(vertcat(R_wave, minimas));
    
%     index=min(length(all_min), length(all_max));
    
    for i=3:length(all_max)-2
        %is the element we're looking at an R peak?
        if ismember(all_max(i), R_wave)            
            %tallest peak of 2 candidates to the left of R, so P wave
            R_max = max([data(all_max(i-1)), data(all_max(i-2))]);
            if R_max == data(all_max(i-1))
                i_max = all_max(i-1);
            else
                i_max = all_max(i-2);
            end
            P_wave = vertcat(P_wave, i_max);
            
            %tallest peak of 3 candidates to the right of R, so T wave
            R_max = max([data(all_max(i+1)), data(all_max(i+2))]);
            if R_max == data(all_max(i+1))
                i_max = all_max(i+1);
            else
                i_max = all_max(i+2);
            end
%             T_wave = vertcat(T_wave, i_max);
            T_wave = vertcat(T_wave, all_max(i+1));
        end
    end
    
    for i=3:length(all_min)-2
        if ismember(all_min(i),R_wave)
            min_idx= find(R_wave==all_min(i));
            
            %%%%%%%%Q minima
            R_min = min([data(minimas(i-min_idx)),...
                data(minimas(i-min_idx-1))]);
            if R_min == data(minimas(i-min_idx))
                i_min = all_min(i-1);
            else
                i_min = all_min(i-2);
            end
            Q_wave = vertcat(Q_wave, i_min);
            
            %%%%%%%% S minima            
            R_min = min([data(minimas(i-min_idx+1)),...
                data(minimas(i-min_idx+2))]);
            if R_min == data(minimas(i-min_idx+1))
                i_min = all_min(i+1);
            else
                i_min = all_min(i+2);
            end
            S_wave = vertcat(S_wave, i_min);
        end
    end
end