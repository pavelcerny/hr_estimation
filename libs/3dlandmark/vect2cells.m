function  [C] = vect2cells(X);

C = cell(1,size(X,2));
for i=1:size(X,2);
    C{i} = X(:,i);
end