function [X,A]=preprocessing(X,A)
%% Preprocessing
%clear all
% Joint segments
% Joint numbers: Hip = 1, LowerSpine = 2, MiddleSpine = 3, Chest = 4, Neck = 5, Head = 6,
% RClavicle = 7, RShoulder = 8, RForearm = 9, RHand = 10,
% LClavicle = 11, LShoulder = 12, LForearm = 13, LHand = 14,
% RThigh = 15, RShin = 16, RFoot = 17,
% LThigh = 18, LShin = 19, LFoot = 20
segment_list = [1 15; 1 18; 1 2;
    15 16; 18 19; 2 3;
    16 17; 19 20; 3 4;
    4 5; 4 7; 4 11;
    5 6; 7 8; 11 12;
    8 9; 12 13;
    9 10; 13 14];
% GOLD: Hip-reference and segment normalization
average_length = cell(length(A),1);
for s =1:length(A)
    A{s} = hip_reference(A{s});
    average_length{s} = get_average_length(A{s},segment_list);
    A{s} = norm_segments(A{s},segment_list,average_length{s});
end

for s =1:size(X,2)
    idx_rs=[(8-1)*3+1:(8-1)*3+3];%indexes rigth shoulder
    idx_ls=[(12-1)*3+1:(12-1)*3+3];%indexes left shoulder
    V_g= A{s}(1,idx_rs) - A{s}(1,idx_ls);
    V_g=V_g./norm(V_g);
    for  n=1:size(X,1)
        if not(isempty(X{n,s}))
            %reference wrt the hip
            X{n,s} = hip_reference(X{n,s});
            %normalize segments to have the same length
            X{n,s} = norm_segments(X{n,s},segment_list,average_length{s});
            %Compute orientation relative to Gold
            V = X{n,s}(1,idx_rs)-X{n,s}(1,idx_ls);
            V=V./norm(V);
            dot=V_g*V';
            theta=acos(dot);%in rads
            R=[cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
            for j=1:floor(size(X{n,s},2)/3)
                X{n,s}(:,(j-1)*3+1:(j-1)*3+3)= X{n,s}(:,(j-1)*3+1:(j-1)*3+3)*R';
            end
        end
    end
end
end
