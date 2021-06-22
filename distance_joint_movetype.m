function [d, IX, IY, Dist] = distance_joint_movetype(X,G,MoveType)
[d, IX, IY ] = dtw(X(:,4:end)',G(:,4:end)');
Njoints = floor(size(X,2)/3);
M = size(MoveType,1);
Dist=zeros(Njoints,M);
for t=1:M %move type
    fi= find(IY<=MoveType(t,1),1,'last');%initial frame
    fl= find(IY<=MoveType(t,2),1,'last');%last frame
    for k=1:Njoints%joints
        idx = 1 +3*(k-1):3*k;
        for j=fi:fl%frames
            Dist(k,t) = Dist(k,t)+ norm (G(IY(j),idx)-X(IX(j),idx));%joint k
        end
    end
    Dist(:,t)=Dist(:,t)./(sqrt(3)*length(fi:fl));
end
end