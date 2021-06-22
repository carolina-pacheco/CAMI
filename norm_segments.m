function M_normalized = norm_segments(M,segment_list,a)
S=size(segment_list,1);
M_normalized=M;
for j=1:size(M,1) %each frames
    for i=1:S %for each segment
        p_start = M(j,3*(segment_list(i,1)-1)+1:3*(segment_list(i,1)-1)+3)';
        p_end = M(j,3*(segment_list(i,2)-1)+1:3*(segment_list(i,2)-1)+3)'; 
        d = [p_end-p_start];
        d_prime = a(i)./norm(d).*d;
        p_start_prime = M_normalized(j,3*(segment_list(i,1)-1)+1:3*(segment_list(i,1)-1)+3)';
        p_end_prime = p_start_prime + d_prime;
        M_normalized(j,3*(segment_list(i,2)-1)+1:3*(segment_list(i,2)-1)+3)=p_end_prime';     
    end
end
end