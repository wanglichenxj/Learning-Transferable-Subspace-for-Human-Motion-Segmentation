function [ACC_res NMI_res]=TSS(sourceFeature,targetFeature,targetLabel)
% =====================
% Learning Transferable Subspace for Human Motion Segmentation
% =====================
% Author: Lichen Wang
% Date: Nov. 12, 2018
% E-mail: wanglichenxj@gmail.com

% Input: Source video frame-level feature (d*N_s), each column is a feature
%        Target video frame-level feature (d*N_t), each column is a feature
%        Target video label (1*N_t) for evaluation
% =====================
lambda1 = 0.015;
lambda2 =12;
psize = 80; % Number of dictionary dimension
ksize = 7; % Neighbor number of the generated graph W
maxIter = 12; % Iteration time

alpha = 0.5;
beta = 0.5;
rho = 0.001; % Step size

ACC_res=zeros(maxIter,1);
NMI_res=zeros(maxIter,1);

Xs=normalize(sourceFeature);
Xt=normalize(targetFeature);

X=[Xs Xt]; % Comcatenate source and target feature

[m_xs n_xs]=size(Xs);
[m_xt n_xt]=size(Xt);
[m_x n_x]=size(X);
num_Cluster = length(unique(targetLabel));

% ===== Generate W =====
k2 = (ksize-1)/2;
W = zeros(n_x, n_x);
for i = 1:n_x
    W(i, max(1,i-k2):min(n_x,i+k2)) = 1;
end
for i = 1:n_x
    W(i,i) = 0;
end
DD = diag(sum(W));
Lw = DD - W;

% Initialize all variables
Z = rand(n_xs,n_x);
V = zeros(n_xs,n_x);
Y1 = zeros(n_xs,n_x);

% Start optimization all variables
for loop = 1:maxIter
    
    % Update P
    H = eye(n_x)-1/(n_x)*ones(n_x,n_x);
    tempX=(X-Xs*V);
    [P,~] = eigs(tempX*(tempX')+lambda1*eye(m_xs),tempX*H*(tempX'),psize,'SM');
    % Update V (Lyap function: AX+XB+C=0)
    leftA=((2*lambda1+alpha)*diag(ones(1,n_xs))+(((P')*Xs)')*((P')*Xs));
    rightB=2*lambda2*Lw;
    leftC=-((((P')*Xs)')*(P')*X+alpha*Z-Y1);
    V=lyap(leftA,rightB,leftC);
    % Update Z
    Z = V + Y1 / beta;
    Z(Z<0) = 0;
    Y1 = Y1 + rho*alpha*(V - Z);
    
    % Start segmentation (for evaluation)
    Zt=Z(:,n_xs+1:n_x); % Obtain the learned target representation
    vecNorm = sum(Zt.^2);
    W2 = (Zt'*Zt)./(vecNorm'*vecNorm + 1e-6);
    [oscclusters,~,~] = ncutW(W2,num_Cluster); % NCut for clustering
    clusters = denseSeg(oscclusters, 1);
    clusters = buMissClass(clusters,num_Cluster);
    acc_loop = compacc(clusters, targetLabel); % accuracy result
    nmi_loop = nmi(targetLabel, clusters'); % NMI result
    
    % Save results
    ACC_res(loop)=acc_loop;
    NMI_res(loop)=nmi_loop;
    
end

% Get average clustering performance
ACC_res=mean(ACC_res(6:end));
NMI_res=mean(NMI_res(6:end));
end
