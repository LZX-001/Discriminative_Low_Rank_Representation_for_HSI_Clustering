

function [Y1,E1,Y2,E2,obj] = method(X,opts)
[m,n,p]=size(X);
% I=eye(m*n);

%%

idxx=opts.idxx;
idxy=opts.idxy;
idxz=opts.idxz;
lambda=opts.lambda;
alpha=opts.alpha;
tol = 1e-8; 
max_iter = 500;
rho = 1.1;
mu = 1e-4;
max_mu = 1e10;
dim = size(X);
L = zeros(dim);
Y1 = L;
Y2 =L;
E1 = L;
E2=L;

Lambda1=L;

iter = 0;
obj=[];
for iter = 1 : max_iter
    disp(iter);
    % update Y1
    Temp=(X-E1+(Lambda1)/mu);
    for i=1:length(idxx)-1
        for j=1:length(idxy)-1
             Y1(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:)=t2m_rpca(Temp(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:),1/(mu*2));
        end
    end
    
    Lvector=reshape(Y1,m*n,p);
    Tvector=reshape(Temp,m*n,p);
    for iii=1:5
%         Lvector=(S1-Lambda21/mu+beta*Grd_sub/mu);
        Grd_sub =cal_subgradient_nuclear(Lvector);
        Tvector=Tvector+(alpha)*Grd_sub/(mu);
%         Lvector=(Lvector+beta*Grd_sub/mu);
    end
    Temp=reshape(Tvector,m,n,p);
    %%%%%%%%%%%%%%%%%%%
    for i=1:length(idxx)-1
        for j=1:length(idxy)-1
%             S1(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:)=...
%                 prox_tnn(Temp(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:),w1/(mu*2));
             Y1(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:)=t2m_rpca(Temp(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:),1/(mu*2));
        end
    end
     
    
    

   
    
    % update E1
   Temp=(X-Y1+(Lambda1)/mu);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i=1:length(idxx)-1
        for j=1:length(idxy)-1
            E1(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:)=...
                prox_l1(Temp(idxx(i):idxx(i+1)-1,idxy(j):idxy(j+1)-1,:),(lambda)/(mu*2));
        end
   end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
  
    
    d1=(X-Y1-E1);
    disp([max(X(:)) max(Y1(:)) max(E1(:)) mean(X(:)) mean(Y1(:)) mean(E1(:))]);
    

    chg = max([ max(abs(d1(:)))]);
    obj(iter)=chg;
    disp(chg);
    if chg < tol
        disp(iter);
        disp(chg);
        disp(mu);
        break;
    end 
    
    Lambda1=Lambda1+mu*d1;
    mu = min(rho*mu,max_mu);
end

% obj = tnnL+lambda*norm(S(:),1);
% err = norm(dY(:));
