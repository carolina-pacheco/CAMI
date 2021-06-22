function [lambda, sd] = score_parameters(W_DTW,HOC)
alphas=0:0.001:0.1;
c = zeros(length(alphas),1);
sd = zeros(1,size(HOC,2));
for t = 1:length(alphas)
    for j=1:size(HOC,2)
        idx = find(W_DTW(:,j)>0);
        idx_in = find(~isnan(HOC(idx,j)));
        idx_train = idx(idx_in);
        X1 = W_DTW(idx_train,j);
        B = HOC(idx_train,j);
        S1 = exp(-alphas(t).*X1.^2/std(X1)^2);
        P = corrcoef(S1,B);
        c(t)=c(t)+P(1,2);
        sd(1,j)=std(X1);
    end
end
c = c./3;
lambda = alphas(find(c==max(c),1,'first'));
end
