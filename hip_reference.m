function M_ref= hip_reference(M)
N_joints=floor(size(M,2)/3);
M_ref=zeros(size(M));
M_ref(:,1)=M(:,1);

for j=1:size(M,1)
refx=M(j,1);
refy=M(j,2);
refz=M(j,3);
    for i=1:N_joints
        M_ref(j,3*(i-1)+1) = M(j,3*(i-1)+1)-refx; %x
        M_ref(j,3*(i-1)+2) = M(j,3*(i-1)+2)-refy; %y
        M_ref(j,3*(i-1)+3) = M(j,3*(i-1)+3)-refz; %z       
    end
end

end