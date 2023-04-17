function [acc_mean,acc_max,C_max,D_max] = kmeansTestM6(Y1,gt_map)
%KMEANSTESTM6 此处显示有关此函数的摘要
%   此处显示详细说明
[m,n,d]=size(Y1);
data1=reshape(Y1,m*n,d);
gt=reshape(gt_map,m*n,1);
f0=find(gt==0);
 gt(f0)=[];
 data1(f0,:)=[];
acc1=[];
acc2=[];
kappa=[];
nmi=[];
addpath('.\ClusteringMeasure');
k=length(unique(gt));
disp(k);
C=zeros([100,k,d]);
D=zeros([100,length(gt)]);

for i=1:20

[result C(i,:,:)] = kmeans(data1,k,'maxiter',1000,'replicates',20,'EmptyAction','singleton');
%re=reshape(result,m*n,1);
%acc1(i)=Accuracy(re,double(gt));
[acc1(i) acc2(i) kappa(i) D(i,:)]=Accuracy(result,gt);
[A nmi(i) avgent] = compute_nmi(gt,result);
end
[max_acc1 index]=max(acc1);
C_max=C(index,:,:);
D_max=D(index,:);
disp('avg acc and max acc');
disp([mean(acc1) max_acc1]);
% disp('avg AA and max AA');
% disp([mean(acc2) acc2(index)]);
disp('avg kappa and max kappa');
disp([mean(kappa) kappa(index)]);
disp('avg nmi and max nmi');
disp([mean(nmi) nmi(index)]);
acc_mean=mean(acc1);
acc_max=max(acc1);
end




