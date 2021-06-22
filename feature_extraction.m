function [W_DTW, t_delay, t_advance] = feature_extraction(X,A,frame_segments)
%% Weighted DTW approach
%find weights for each joint within each move type
W = cell(length(A),1);
for s = 1:length(A)
    W{s} = get_displacement_weights(frame_segments{s},A{s});
end
%Get DTW distance for each kid
D = cell(size(X));
IX = cell(size(X));
IY = cell(size(X));
DTW = zeros(size(X));
W_DTW = zeros(size(X));%weighted DTW
for n = 1:size(X,1)
    for s = 1:size(X,2)
        if not(isempty(X{n,s}))
             [DTW(n,s), IX{n,s}, IY{n,s}, D{n,s}] = distance_joint_movetype(X{n,s},A{s},frame_segments{s});
             W_DTW(n,s) = mean(sum(W{s}.*D{n,s}));
        else
            W_DTW(n,s)= NaN;
        end
    end
end
[t_delay,t_advance,t_sync] = time_measurements(IX,IY);
end