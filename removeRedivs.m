%% find out if successors of divisions at tp1 appear in the tp2 disvisons

function [div1New,div2,doublePos]=removeRedivs(div1,div2,divs,allCells2)
div1New =[];
doublePos=[];
for i = 1:size(div1,1)
    l=findLeaves(div1(i,3),[],divs,[]);
    doublePos=[doublePos;div2(ismember(div2(:,3),l),:)];
    div2(ismember(div2(:,3),l),:)=[]; %remove    
    div1New=[div1New;allCells2(ismember(allCells2(:,2),l),[4,5,2,9])];
end
end

function leavesNew=findLeaves(d1,d2,divs,leaves)
l1=[];
l2=[];
if ismember(d1,divs(:,2))
    id=find(divs(:,2)==d1);
    l1=findLeaves(divs(id,3),divs(id,4),divs,leaves);
else
    l1=d1;
end
if ismember(d2,divs(:,2))
    id=find(divs(:,2)==d2);
    l2=findLeaves(divs(id,3),divs(id,4),divs,leaves);
else
    l2=d2;
end
leavesNew=[leaves;l1;l2];
end