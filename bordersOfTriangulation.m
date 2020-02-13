function b = bordersOfTriangulation(tri)
uni =containers.Map();
noUnique = containers.Map();
tri = sort(tri,2);
for i = 1: size(tri,1)
    if (~isKey(noUnique,sprintf('%i,%i', tri(i,1),tri(i,2))))
        if (~isKey(uni,sprintf('%i,%i', tri(i,1),tri(i,2))))
              uni(sprintf('%i,%i', tri(i,1),tri(i,2))) = [tri(i,1);tri(i,2)];
        else
            remove(uni,sprintf('%i,%i', tri(i,1),tri(i,2)));
           noUnique(sprintf('%i,%i', tri(i,1),tri(i,2))) = true;
        end
    end
    if (~isKey(noUnique,sprintf('%i,%i', tri(i,1),tri(i,3))))
        if (~isKey(uni,sprintf('%i,%i', tri(i,1),tri(i,3))))
              uni(sprintf('%i,%i', tri(i,1),tri(i,3))) = [tri(i,1);tri(i,3)];
        else
            remove(uni,sprintf('%i,%i', tri(i,1),tri(i,3)));
           noUnique(sprintf('%i,%i', tri(i,1),tri(i,3))) = true;
        end
    end
    if (~isKey(noUnique,sprintf('%i,%i', tri(i,2),tri(i,3))))
        if (~isKey(uni,sprintf('%i,%i', tri(i,2),tri(i,3))))
              uni(sprintf('%i,%i', tri(i,2),tri(i,3))) = [tri(i,2);tri(i,3)];
        else
            remove(uni,sprintf('%i,%i', tri(i,2),tri(i,3)));
           noUnique(sprintf('%i,%i', tri(i,2),tri(i,3))) = true;
        end
    end
    
end
edges = cell2mat(values(uni));
points = [];
idx = 1;
idy= 1;
while size(edges,2) >0
    p1 = edges(idy,idx);
    if (idy==1)
    p2 = edges(2,idx);
    else
        p2 = edges(1,idx);
    end
    points = [points p1];
    edges(:,idx) = [];
    [idy,idx] = find(edges == p2);
end
b = points;