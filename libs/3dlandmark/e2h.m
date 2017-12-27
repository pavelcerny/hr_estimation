function [Ph] = e2h(Pe);
% prevod z  euklidovskych souradnic na homogenni
%
% [Ph] = e2h(Pe);
%
%  - Pe...(nx2,nx3) Matice bodu (vektoru) v euklid. souradnicich
%  ->Ph...(nx3,nx4) Matice bodu (vektoru) v homog. souradnicich
%

[r,c]=size(Pe);

if (r==2 | r==3) & ~(c==2 | c==3),
   cas=2;
else
   cas=1;
end

if cas==1,
	n=size(Pe,1); %n...pocet bodu 
	o1=ones(n,1);
   Ph = [Pe, o1];
else
	n=size(Pe,2); %n...pocet bodu 
	o1=ones(1,n);
   Ph = [Pe; o1];
end


