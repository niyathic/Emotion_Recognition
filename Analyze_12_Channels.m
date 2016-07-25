function [X,Z]=Analyze_12_Channels(A,b)
n_channels=5;
n_func=n_channels-2;
Aeq=ones(1,n_func);
beq=[1];
VLB=zeros(1,n_func);
VUB=ones(1,n_func);
init=[1;zeros(n_func-1,1)];
%init is the initial vector. A bad one can result in local optima, but since the problem itself is not complex, it might be ok...
[X,Z]=fmincon(@(x)Target(x,A,b),init,[],[],Aeq,beq,VLB,VUB);