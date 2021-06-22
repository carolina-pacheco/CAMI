function W = get_displacement_weights(MoveType,X)

M=size(MoveType,1);
Njoints = floor(size(X,2)/3);
D=zeros(Njoints,M);
    for i=1:Njoints
        idxj = 1+3*(i-1):3*i;%indexes joint
        for j=1:M
            for k=MoveType(j,1):MoveType(j,2)-1%move along frames within move type 
                D(i,j) = D(i,j)+ norm(X(k+1,idxj)-X(k,idxj));
            end            
        end
    end
    D_norm=D./max(D);
    beta=1./std(D_norm(:));
    W=zeros(size(D));
    for m=1:M
        for j=1:Njoints
            W(j,m)= 1-exp(-beta*D_norm(j,m));
        end
        W(:,m)=W(:,m)./sum(W(:,m));
    end
end