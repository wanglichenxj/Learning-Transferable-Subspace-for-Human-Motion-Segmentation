function [feature, label]=load_Keck(num)
% load the Keck dataset
name=['keck_person_',num2str(num),'.mat'];
load(['Datasets/Keck_feature/',name]);
feature=keck_feature;
label=keck_label;