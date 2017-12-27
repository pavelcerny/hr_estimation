function [ corners ] = getIVTcorners( T )
paramEst= T.param.est;
sz = T.sz;

M = [paramEst(1) paramEst(3) paramEst(4); paramEst(2) paramEst(5) paramEst(6)];

w=sz(1);
h=sz(2);

corners = [ 1,-w/2,-h/2; 1,w/2,-h/2; 1,w/2,h/2; 1,-w/2,h/2; 1,-w/2,-h/2 ]';
corners = M * corners;
corners = corners(:,1:4);

end