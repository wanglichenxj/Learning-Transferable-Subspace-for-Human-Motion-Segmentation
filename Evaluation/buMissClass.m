% if the number of class is not enough
% add on class in the missing part

function clusterRes=buMissClass(cluster,nClass)

tempCluster=cluster; % copy the cluster
NumInputClass=length(unique(cluster)); % count the number of class;



[m ~]=size(cluster);
if NumInputClass~=nClass
%     disp(['ncutW only have ',num2str(NumInputClass),' ..bushang']);
    tempCluster(m,1)=nClass;
end
clusterRes=tempCluster;
    
    



