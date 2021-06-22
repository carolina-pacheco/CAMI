function a=get_average_length(M,segment_list)
S=size(segment_list,1);
a = zeros(S,1);

for i=1:S %for each segment
    j_start=segment_list(i,1);
    j_end=segment_list(i,2);
    for j=1:size(M,1) %sum the length across all frames
        a(i)=a(i)+ norm(M(j,3*(j_start-1)+1:3*(j_start-1)+3)-M(j,3*(j_end-1)+1:3*(j_end-1)+3));
    end
        a(i)=a(i)./size(M,1);%divide by number of frames to get average
end


end

