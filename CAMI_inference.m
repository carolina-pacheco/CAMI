function [CAMI] = CAMI_inference(X,A,frame_segments)
%%%%%%%%% Inference of CAMI scores %%%%%%%%%%%
%based on Tunçgenç, B., Pacheco, C., Rochowiak, R., Nicholas, R.,
%Rengarajan, S., Zou, E., ... & Mostofsky, S. H. (2021). 
%Computerized Assessment of Motor Imitation as a Scalable Method for Distinguishing 
%Children With Autism. Biological Psychiatry: Cognitive Neuroscience and Neuroimaging, 6(3), 321-328.

%%%% arguments %%%%
% X: Subjects data.
%    N cells, where N corresponds to the number of subjects
%    Each cell X{n} is a matrix with rows corresponding to time steps 
%    and 3J cols corresponding to (x,y,z) positions of J joints.
% A: Target data.
%    Matrix with rows corresponding to time steps and 3J columns 
%    corresponding to (x,y,z) position of joints. 
%    They contain skeletal data for the target sequences.
%    Columns of A and X{n} matrices should be ordered as follows or
%    segment_list variable in "preprocessing.m" script should be modified.
%    [Hip_xyz, LowerSpine_xyz, MiddleSpine_xyz, Chest_xyz, 
%    Neck_xyz, Head_xyz, RClavicle_xyz, RShoulder_xyz, RForearm_xyz, 
%    RHand_xyz, LClavicle_xyz, LShoulder_xyz, LForearm_xyz, LHand_xyz,
%    RThigh_xyz, RShin_xyz, RFoot_xyz, LThigh_xyz, LShin_xyz, LFoot_xyz]
%    frame_segments: a matrix with 2 cols, indicating start and end frames 
%    of movetypes in matrix A.

%%%% outputs %%%%
% CAMI: Nx1 matrix containing CAMI scores for the N subjects. 
%       It contain NaNs when input data is missing.

%%parameters
lambda = 0.0270;
W = [0.7200, -0.5137, -0.4667];

%% Preprocessing 
A_cell = cell(1);
A_cell{1} = A;
frames = cell(1);
frames{1} = frame_segments;
[X_pp,A_pp] = preprocessing(X,A_cell);
%% Feature extraction
[W_DTW, t_delay, t_advance] = feature_extraction(X_pp,A_pp,frames);
%% Inference CAMI scores
%From Weighted DTW to Scores
Scores = NaN(size(X));
for s=1:size(X,2)
    idx_aux = find(~isnan(W_DTW(:,s)));
    sd = std(W_DTW(idx_aux,s));
    Scores(idx_aux,s) = exp(-lambda.*W_DTW(idx_aux,s).^2./(sd)^2);
end

CAMI = [Scores,t_delay,t_advance]*W';
end