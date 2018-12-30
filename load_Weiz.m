function [feature, label]=load_Weiz(num)
% load the Weizmann dataset
name=['wei_person_',num2str(num),'.mat'];
load(['Datasets/Weiz_feature/',name]);
feature=weiAllFeatureOnePerson;
label=labelOnePerson;