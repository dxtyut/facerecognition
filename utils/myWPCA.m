function [xwpca,WPCAProj,MeanImage] = myWPCA(x,K)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  x:  D x N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% [disc_set,disc_value,~]  =  Eigenface_f(x,K);
[disc_set,disc_value,MeanImage]  =  Eigenface_f(x,K);
u = disc_set;
s = diag(disc_value);

%%
% epsilon = 0.1;
epsilon = 1e-10;
WPCAProj = diag(1./sqrt(diag(s(1:K,1:K))+epsilon))*u(:,1:K)';

xwpca = WPCAProj*bsxfun(@minus,x,MeanImage);



