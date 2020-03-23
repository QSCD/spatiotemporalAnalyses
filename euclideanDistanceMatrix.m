function D=euclideanDistanceMatrix(v,w)
%% returns distance matrix between two vectors
D = zeros(size(v,1),size(w,1));
for i = 1:size(v,2)
    for j = 1: size(w,2)
        D(i,j) = sqrt((v(1,i)-w(1,j))^2+(v(2,i)-w(2,j))^2);
    end
end