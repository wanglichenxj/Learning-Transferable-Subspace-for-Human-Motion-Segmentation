% =====================
% Learning Transferable Subspace for Human Motion Segmentation
% =====================
% Author: Lichen Wang
% Date: Nov. 12, 2018
% E-mail: wanglichenxj@gmail.com

% Cite:
% @inproceedings{TSS_Lichen,
% 	author = {Lichen Wang and Zhengming Ding and Yun Fu},
% 	title = {Learning Transferable Subspace for Human Motion Segmentation},
% 	conference = {AAAI Conference on Artificial Intelligence},
% 	year = {2018},
% }
% =====================

clc;
clear all;
close all;
rand('state',123);

% Evaluation and clustering code
addpath('Evaluation');
addpath('Evaluation/ncut');
% Features of Keck and Weizmann datasets
addpath('Datasets');

% ==============
% Set Weizmann as source and Keck as target video
disp('==== Weizmann-Source Keck-Target ====');
ACC_res=[];
NMI_res=[];
for i=1:4
    % Load source video
    [sourceFeature,~]=load_Weiz(2);
    % Load i-th target video
    [targetFeature, targetLabel]=load_Keck(i);
    % Video segmentation and output performance evaluation
    [acc, nmi]=TSS(sourceFeature,targetFeature,targetLabel);
    disp(['Person = ',num2str(i),'  ACC = ',num2str(acc),'  NMI = ',num2str(nmi)]);
    ACC_res=[ACC_res acc];
    NMI_res=[NMI_res nmi];
end
% Get average performance
mean_acc=mean(ACC_res);
mean_nmi=mean(NMI_res);
disp(['Mean ACC = ',num2str(mean_acc),' Mean NMI = ',num2str(mean_nmi)]);

% ==============
% Set Keck as source and Weizmann as target video
disp('==== Weizmann-Target Keck-Source ====');
ACC_res=[];
NMI_res=[];
for i=1:9
    % Load source video
    [sourceFeature,~]=load_Keck(4);
    % Load target video
    [targetFeature, targetLabel]=load_Weiz(i);
    
    % Video segmentation and output performance evaluation
    [acc, nmi]=TSS(sourceFeature,targetFeature,targetLabel);
    disp(['Person = ',num2str(i),'  ACC = ',num2str(acc),'  NMI = ',num2str(nmi)]);
    ACC_res=[ACC_res acc];
    NMI_res=[NMI_res nmi];
end
% Get average performance
mean_acc=mean(ACC_res);
mean_nmi=mean(NMI_res);
disp(['Mean ACC = ',num2str(mean_acc),' Mean NMI = ',num2str(mean_nmi)]);
