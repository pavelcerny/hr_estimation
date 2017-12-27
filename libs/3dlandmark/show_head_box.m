function h = show_box(P, msg, varargin)
%SHOW_BOX
%
% show_box(P, varara);
%
%  P - camera matrix P = K*[R,t]
%

if isempty(varargin)
    varargin = {'c'};
end
        

% %lendamarks redetected, reprojected
% plot(C{p}.x(1,:),C{p}.x(2,:),'g+');
% plot(xr(1,:),xr(2,:),'rx');
%         
% 
% %axis frame
% Y = [0,0,0;
%     1,0,0;
%     0,1,0;
%     0,0,1]';
% y = p2e(P*e2h(Y));
% plot([y(1,2),y(1,1)],[y(2,2),y(2,1)],'b');
% plot([y(1,3),y(1,1)],[y(2,3),y(2,1)],'b');
% plot([y(1,4),y(1,1)],[y(2,4),y(2,1)],'b');
% plot([y(1,2),y(1,2)],[y(2,2),y(2,2)],'bo');
        
B1 = [-1,-1,0]';
B2 = [1,-1,0]';
B3 = [1,1,0]';
B4 = [-1,1,0]';
%
B5 = [-1,-1,-3]';
B6 = [1,-1,-3]';
B7 = [1,1,-3]';
B8 = [-1,1,-3]';

B = [B1,B2,B3,B4,B5,B6,B7,B8];
b = p2e(P*e2h(B));

h1=plot([b(1,1),b(1,2),b(1,3),b(1,4),b(1,1),b(1,4),b(1,8),b(1,7),b(1,3),b(1,7),b(1,6),b(1,2)], ...
    [b(2,1),b(2,2),b(2,3),b(2,4),b(2,1),b(2,4),b(2,8),b(2,7),b(2,3),b(2,7),b(2,6),b(2,2)],varargin{:});
h2=plot([b(1,1),b(1,5),b(1,6),b(1,5),b(1,8)], ...
    [b(2,1),b(2,5),b(2,6),b(2,5),b(2,8)],varargin{:});
h3=plot(b(1,1), b(2,1), [varargin{1},'o'], 'markerfacecolor', varargin{1});

x0=min(b(1,:))+10;
y0=max(b(2,:))+40;

h4=[];
for i=1:numel(msg)
    h4(i)=text(x0, y0+21*(i-1),msg{i},'color',varargin{1},'fontsize',20);
end

h = [h1(:);h2(:);h3(:);h4(:)];
        