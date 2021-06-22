function [CAMI,W,p] = CAMI_correlation_maximization(Scores, t_delay,t_advance,HOC)
K = 3;
W = zeros(1,K);
S = size(HOC,2);
X = cell(S,1);
Y = cell(S,1);
for s = 1:S
    idx = find(~isnan(HOC(:,s)));
    X{s} = [Scores(idx,s) t_delay(idx,s) t_advance(idx,s)];
    Y{s} = HOC(idx,s);
end
%max correlation
[CAMI,W,p] = maximize_correlation(X,Y,K);
end