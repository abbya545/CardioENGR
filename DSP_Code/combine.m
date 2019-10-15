function [vector] = combine(filename, noise)
    %just a reminder of which column is what
    load(filename);
    header={'Time' 'ACG' 'ECG'};
    data=[];
    for i = 1:n
        temp=eval(sprintf('b%d',i));

        %my own detrend since Matlab's was doing nothing
        for j=2:3
            t=temp(:,1);
            p=polyfit(t,temp(:,j),100);
            f=polyval(p,t);
            temp(:,j)=temp(:,j)-f;
        end
        
        %combine all the b intervals into one vector
        data=vertcat(data,temp);    
    end
    
    %invert ACG per Abby's git notes
    data(:,2)=-1*data(:,2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %plot pre- and post- detrend ACG of all b intervals
%     figure
%     subplot(4,1,1)
%     t=b1(:,1);
%     p=polyfit(t,b1(:,2),100);
%     f1=polyval(p,t);
%     plot(t, b1(:,2)-f1, t, b1(:,2))
%     title({'ACG', 'Trial 1'})
% 
%     subplot(4,1,2)
%     t=b2(:,1);
%     p=polyfit(t,b2(:,2),100);
%     f1=polyval(p,t);
%     plot(t, b2(:,2)-f1, t, b2(:,2))
%     title('Trial 2')
%     
%     subplot(4,1,3)
%     t=b3(:,1);
%     p=polyfit(t,b3(:,2),100);
%     f1=polyval(p,t);
%     plot(t, b3(:,2)-f1, t, b3(:,2))
%     title('Trial 3')
%     
%     subplot(4,1,4)
%     t=b4(:,1);
%     p=polyfit(t,b4(:,2),100);
%     f1=polyval(p,t);
%     plot(t, b4(:,2)-f1, t, b4(:,2))
%     title('Trial 4')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %plot pre- and post- detrend ECG of all b intervals
%     figure
%     subplot(4,1,1)
%     t=b1(:,1);
%     p=polyfit(t,b1(:,3),100);
%     f1=polyval(p,t);
%     plot(t, b1(:,3)-f1, t, b1(:,3))
%     title({'ECG', 'Trial 1'})
% 
%     subplot(4,1,2)
%     t=b2(:,1);
%     p=polyfit(t,b2(:,3),100);
%     f1=polyval(p,t);
%     plot(t, b2(:,3)-f1, t, b2(:,3))
%     title('Trial 2')
% 
%     subplot(4,1,3)
%     t=b3(:,1);
%     p=polyfit(t,b3(:,3),100);
%     f1=polyval(p,t);
%     plot(t, b3(:,3)-f1, t, b3(:,3))
%     title('Trial 3')
% 
%     subplot(4,1,4)
%     t=b4(:,1);
%     p=polyfit(t,b4(:,3),100);
%     f1=polyval(p,t);
%     plot(t, b4(:,3)-f1, t, b4(:,3))
%     title('Trial 4')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %init vars for going through data for noisy intervals
    start=[];
    stop=[];
    count(2:3)=1;
    index=[0, 2, 1000];
    threshold=[0, 0.05, 0.75];
    i=1;
    
    %find all intervals of data that are unusable/too noisy
    while i<length(data)-max(index)
%         disp(i/length(data)*100) %display job completion as percentage
        
        %find a value that is greater than threshold for ACG
        if abs(data(i,2))>threshold(2)
            
            %init start and stop indexes of noisy interval
            start(count(2),2)=i;
            stop(count(2),2)=start(count(2),2)+index(2);
            done=0;
            
            while ~done
                %go until average, abs value is < threshold
                if mean(abs(data(stop(count(2),2)-index(2):stop(count(2),2),2)))<threshold(2)
                    done=1;
                else
                    %avoid going to index longer than length of data
                    if stop(count(2),2)==length(data)
                        done=1;
                    else
                        %increment stop index of noisy interval
                        stop(count(2),2)=stop(count(2),2)+1;
                    end
                end
            end
            %inc vars for next loop, avoid recording same interval
            i=stop(count(2),2);
            start(count(2),3)=0;
            stop(count(2),3)=0;
            count(2)=count(2)+1;
            
        %find a value that is greater than threshold for ECG    
        elseif abs(data(i,3))>threshold(3)
            
            %init start and stop indexes of noisy interval
            start(count(3),3)=i;
            stop(count(3),3)=start(count(3),3)+index(3);
            done=0;
            
            while ~done
                %go until average, abs value is < threshold
                if mean(abs(data(stop(count(3),3)-index(3):stop(count(3),3),3)))<threshold(3)
                    done=1;
                else
                    %avoid going to index longer than length of data
                    if stop(count(3),3)==length(data)
                        done=1;
                    else
                        %increment stop index of noisy interval
                        stop(count(3),3)=stop(count(3),3)+1;
                    end
                end
            end
            %inc vars for next loop, avoid recording same interval
            i=stop(count(3),3);
            count(3)=count(3)+1;
        else
            %if value isn't noisy, i++
            i=i+1;
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %make all noisy interval value = noise so it'll be easy to delete
    vector=data;
    for i=1:length(start(:,2))
        if start(i,2)==0
            i=length(start(:,2));
        else
            vector(start(i,2):stop(i,2),2)=noise;
        end
    end
    
    %same thing, for ECG
    for i=1:length(start(:,3))
        if start(i,3)==0
            i=length(start(:,3));
        else
            vector(start(i,3):stop(i,3),3)=noise;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %if ACG or ECG signal has a bad value (noise), delete that row
    %from both vectors. All or none are useful
    for i=length(vector):-1:1
        if abs(vector(i,2))>=noise || abs(vector(i,3))>=noise
            vector(i,:)=[];
        end
    end
end



