function [CAMI,W,p] = CAMI_training(X,A,HOC,frame_segments)
%%%%%%%%% Training of CAMI scores %%%%%%%%%%%
%based on Tunçgenç, B., Pacheco, C., Rochowiak, R., Nicholas, R.,
%Rengarajan, S., Zou, E., ... & Mostofsky, S. H. (2021). 
%Computerized Assessment of Motor Imitation as a Scalable Method for Distinguishing 
%Children With Autism. Biological Psychiatry: Cognitive Neuroscience and Neuroimaging, 6(3), 321-328.

%%%% arguments %%%%
% X: Subjects data.
%    NxS cells, where N corresponds to the number of subjects, and S
%    corresponds to the number of trials to learn from.
%    Each cell X{n,s} is a matrix with rows corresponding to time steps 
%    and 3J cols corresponding to (x,y,z) positions of J joints.
% A: Target data.
%    S cells, each one contains a matrix with rows corresponding to time 
%    steps and 3J columns corresponding to (x,y,z) locations of J joints. 
%    They contain skeletal data for the target sequences.
%    Columns of A{s} and X{n,s} matrices should be ordered as follows or
%    segment_list variable in "preprocessing.m" script should be modified.
%    [Hip_xyz, LowerSpine_xyz, MiddleSpine_xyz, Chest_xyz, 
%    Neck_xyz, Head_xyz, RClavicle_xyz, RShoulder_xyz, RForearm_xyz, 
%    RHand_xyz, LClavicle_xyz, LShoulder_xyz, LForearm_xyz, LHand_xyz,
%    RThigh_xyz, RShin_xyz, RFoot_xyz, LThigh_xyz, LShin_xyz, LFoot_xyz]
% HOC: NxS matrix containing human observation codes (ground truth) for the
%    N subjects in the S sequences. It supports NaNs for missing annotations.
% frame_segments: S cells, each one containing a matrix with 2 cols,
%    indicating frames of A{s} in which there is a change of movement type.

%%%% outputs %%%%
% CAMI: NxS matrix containing CAMI scores for the N subjects in the S
%       sequences. It contain NaNs when input data is missing.
% W: 1x3 vector containing weights that maximize the correlation of the 
%       CAMI and HOC scores ( CAMI = [DTW_scores, t_delay,t_adv]*W')
% p: 1xS vector with the correlation coefficients between CAMI and HOC
%       scores for each one of the sequences.
%% Preprocessing 
disp('Step 1/3: Preprocessing')
[X_pp,A_pp] = preprocessing(X,A);
disp('Step 1/3 complete')
disp('Step 2/3: Feature extraction')
%% Feature extraction
[W_DTW, t_delay, t_advance] = feature_extraction(X_pp,A_pp,frame_segments);
disp('Step 2/3 complete')
%% Learning CAMI scores
%From Weighted DTW to Scores
disp('Step 3/3: Learning scores')
[lambda, sd] = score_parameters(W_DTW,HOC);
Scores = NaN(size(X));
for s=1:size(X,2)
    idx_aux = find(~isnan(W_DTW(:,s)));
    Scores(idx_aux,s) = exp(-lambda.*W_DTW(idx_aux,s).^2./(sd(s))^2);
end
[CAMI,W,p] = CAMI_correlation_maximization(Scores, t_delay,t_advance,HOC);
disp('Step 3/3 complete')
end