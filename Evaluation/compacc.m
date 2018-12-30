function [acc] = compacc(idx,gnd)
%inputs:
%      idx -- the clustering results
%      gnd -- the groudtruth clustering results
%outputs:
%      acc -- segmentation accuracy (or classification accuracy)
if size(idx,2)>1
    idx = idx';
end
if size(gnd,2)>1
    gnd = gnd';
end

uids = unique(idx);
idx = idx;
for i=1:length(uids)
    uid = uids(i);
    inds = abs(idx-uid)<0.1;
    vids = gnd(inds);
    uvids = unique(vids);
    vf = 0;
    for j=1:length(uvids)
        vfj = sum(abs(vids-uvids(j))<0.1);
        if vfj>vf;
            vid = uvids(j);
            vf = vfj;
        end
    end
    idx(inds) = vid;
end
acc = sum(abs(idx-gnd)<0.1)/length(gnd);