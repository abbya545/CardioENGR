function [temp,fi,fw]=find_interval(data, A, C, E, P, Q, R, S, T, RFW, SFW)
    window=5;
    % temp=data(R(i):R(window),:);
    idx=1;
    exit=0;
    temp=[];
    stop=min([length(A),length(C),length(E),...
        length(P),length(Q),length(R),...
        length(S),length(T)]);
    while ~exit
        mu=[];
        sub=[];
        sub(1,:)=diff(A(idx:idx+window));
        mu(1,1)=mean(data(A(idx:idx+window),2));
        mu(1,2)=mean(sub(1,:));
        sigma(1)=std(data(A(idx:idx+window),2));

        sub(2,:)=diff(C(idx:idx+window));
        mu(2,1)=mean(data(C(idx:idx+window),2));
        mu(2,2)=mean(sub(1,:));
        sigma(2)=std(data(C(idx:idx+window),2));

        sub(3,:)=diff(E(idx:idx+window));
        mu(3,1)=mean(data(E(idx:idx+window),2));
        mu(3,2)=mean(sub(1,:));
        sigma(3)=std(data(E(idx:idx+window),2));
        
        sub(4,:)=diff(RFW(idx:idx+window));
        mu(4,1)=mean(data(RFW(idx:idx+window),2));
        mu(4,2)=mean(sub(4,:));
        sigma(4)=std(data(RFW(idx:idx+window),2));
        
        sub(5,:)=diff(SFW(idx:idx+window));
        mu(5,1)=mean(data(SFW(idx:idx+window),2));
        mu(5,2)=mean(sub(5,:));
        sigma(5)=std(data(SFW(idx:idx+window),2));
        
        for i=1:window
            for j=1:3
                if sub(j,i)<mu(j,2)-50 | sub(j,i)>mu(j,2)+50
                    flag_move=1;
                end
            end
            if data(A(idx+i-1),2)>mu(1,1)+2*sigma(1) |...
                    data(A(idx+i-1),2)<mu(1,1)-2*sigma(1)
                flag_move=1;
            end
            if data(C(idx+i-1),2)>mu(2,1)+2*sigma(3)
                flag_move=1;
            end
            if data(E(idx+i-1),2)>mu(3,1)+2*sigma(3)
                flag_move=1;
            end
            if data(RFW(idx+i-1),2)>mu(4,1)+2*sigma(4) |...
                    data(RFW(idx+i-1),2)<mu(4,1)-2*sigma(4)
                flag_move=1;
            end
            if data(SFW(idx+i-1),2)>mu(5,1)+2*sigma(5) |...
                    data(SFW(idx+i-1),2)<mu(5,1)-2*sigma(5)
                flag_move=1;
            end
        end
        if flag_move
            flag_move=0;
            idx=idx+1;
        else
            temp=data(A(idx):A(idx+window),:);
            fi=A(idx);
            fw=A(idx+window);
            idx=1;
            window=window+1;
        end

        if idx+window>=stop
            idx=1;
            window=window+1;
        end

        if window>20
            exit=1;
        end
    end
end