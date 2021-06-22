function [t_delay, t_advance, t_sync] = time_measurements(IX,IY)
N = size(IX,1);
T = size(IX,2);
t_delay=zeros(N,T);
t_advance=zeros(N,T);
t_sync=zeros(N,T);

for i=1:N
    for j=1:T
        if not(isempty(IX{i,j}))
            x=IX{i,j};
            y=IY{i,j};
            W=[x y];
            dW=diff(W,1);
            for k=1:size(dW,1)
                if dW(k,:)== [1 0]
                    t_delay(i,j)=t_delay(i,j)+1;
                else if dW(k,:)==[0 1]
                        t_advance(i,j)=t_advance(i,j)+1;
                    else t_sync(i,j)=t_sync(i,j)+1;
                    end
                end
            end
            t_delay(i,j)=t_delay(i,j)./x(end);
            t_advance(i,j)=t_advance(i,j)./y(end);
            t_sync(i,j)=t_sync(i,j)./(min(x(end),y(end)));
            clearvars -except i k j t_delay t_advance t_sync IX IY T
        else
        t_delay(i,j)=NaN;
        t_advance(i,j)=NaN;
        t_sync(i,j)=NaN;
        end
    end
end
end
