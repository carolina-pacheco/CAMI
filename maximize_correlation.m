function [CAMI,W,p] = maximize_correlation(X,Y,K)
corr_old = 0;
w=ones(K,1)./K;

for j=1:length(X)
    X{j} = X{j}(:,1:K);
    N(j)=length(Y{j});
    I{j}=(X{j}-ones(N(j),1)*ones(1,N(j))*X{j}./N(j))'*(Y{j}-mean(Y{j}))./(std(Y{j})*(N(j)-1));
    Sm{j}=(X{j}-ones(N(j),1)*ones(1,N(j))*X{j}./N(j))'*(X{j}-ones(N(j),1)*ones(1,N(j))*X{j}./N(j))./(N(j)-1);
    corr_old = corr_old + w'*I{j}./sqrt(w'*Sm{j}*w);
end
corr_old=corr_old/3;
corr_new=inf;
eps=0.01;
w_old=w;
w_new=zeros(K,1);
while corr_new > corr_old
    w_best=w_old;
    for i=1:K
        dw =0;
        for j=1:size(X,2)
            dw = dw + (I{j}(i)*w_old'*Sm{j}*w_old-w_old'*I{j}*w_old'*Sm{j}(:,i))./(w_old'*Sm{j}*w_old)^(1.5);
        end
        w_new(i) = w_old(i) +eps*dw/size(X,2);
    end
    corr_old = 0;
    for j=1:size(X,2)
        corr_old = corr_old+w_old'*I{j}./sqrt(w_old'*Sm{j}*w_old);
    end
    corr_old=corr_old./size(X,2);
    w_old = w_new;
    corr_new = 0;
    for j=1:size(X,2)
        corr_new = corr_new+w_old'*I{j}./sqrt(w_old'*Sm{j}*w_old);
    end
    corr_new=corr_new./size(X,2);
end
p=zeros(length(X),1);
for j=1:length(X)
    pred{j}=X{j}*w_best;
    P{j} = corrcoef(Y{j},pred{j});
    p(j)=P{j}(1,2);
end
W=w_best';
p=p';
CAMI = pred;
end
