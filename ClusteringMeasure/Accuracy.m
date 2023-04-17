function [OA,AA,KAPPA,C] = Accuracy(C,gt)
 C = bestMap(gt,C);
 OA = length(find(gt == C))/length(gt);
len=max(gt);
x1=[];
x2=[];
x3=[];
for ii=1:len
    x1(ii)=length(find(gt==ii));
    x2(ii)=length(find(C==ii));
    x3(ii)=length(find(gt == C&gt==ii))/x1(ii);
end
AA=mean(x3);
pe=sum(x1.*x2)/(length(gt)^2);
KAPPA=(OA-pe)/(1-pe);
end