clear;
close all;
clc;
%% input the data

img_name='PaviaU';
addpath(genpath('.\'));
R=importdata(['.\data\' img_name '_corrected.mat']);
% X=importdata(['.\code_SS-RLRA\data\' img_name '_corrected_ss.mat']);
gt=importdata(['.\data\' img_name '_gt.mat']);



[m,n,d]=size(R);
opts.alpha=1; % the negative low rnak term  
opts.lambda=0.01; % the error term
% X=R./max(R(:));
%% parameter settings
if(strcmp(img_name,'Salinas'))
    [idxx,idxy,idxz]=split_tensor(m,n,d,10,5,d);
    opts.alpha=0.1;
    opts.lambda=0.0001;
end
if(strcmp(img_name,'Indian_pines'))
    [idxx,idxy,idxz]=split_tensor(m,n,d,6,6,d);
    opts.alpha=2;
    opts.lambda=0.001;
end
if(strcmp(img_name,'PaviaU'))
    [idxx,idxy,idxz]=split_tensor(m,n,d,8,4,d);
    opts.alpha=1;
    opts.lambda=0.01;
end
opts.mu = 1e-3;
opts.tol = 1e-8;
opts.rho = 1.1;
opts.max_iter = 500;
opts.DEBUG = 1;
opts.idxx=idxx;
opts.idxy=idxy;
opts.idxz=idxz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        [Y1,E1,Y2,E2,obj] = method(R,opts);
        save('Y.mat','Y1');
        Y1=double(Y1);
        if(strcmp(img_name,'Salinas'))
            rng(200);
        end
        if(strcmp(img_name,'Indian_pines'))
            rng(220);
        end
       if(strcmp(img_name,'PaviaU'))
            rng(11);
        end
        [acc1,acc2,C,D]=kmeans_clustering(Y1,gt);
        