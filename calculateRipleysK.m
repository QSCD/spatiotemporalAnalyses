function [K, Krand]=calculateRipleysK(NSCs, D, DsP)

%% calculate area of hemispheres via triangulation
tri = delaunay(NSCs(:,1:2));
bCells = bordersOfTriangulation(tri);%to check which cells need to be checked for edge correction
sPhase1Ids=find(ismember(NSCs(:,end),[1,3,4]));
nonSPhase1Ids=find(~ismember(NSCs(:,end),[1,3,4]));%ids to sample from
    P = NSCs(:,1:3);
    %Obtain the edges in each triangle formed by the 'delaunaytriangulation'
    v1 = P(tri(:,2), :) - P(tri(:,1), :);
    v2 = P(tri(:,3), :) - P(tri(:,2), :);
    %Calculating the cross product of the edges in each triangle of the surface
    cp = 0.5*cross(v1,v2);
    %Surface area A of the entire surface is calculated as the sum of the areas of the individual triangles
    A = sum(sqrt(dot(cp, cp, 2)));

sP1count=size(DsP,1);
sP2count=size(DsP,2);
spatial = issymmetric(DsP);
K=discreteRK(D,DsP,A,bCells,sPhase1Ids);
%% randomly sampling for comparison to observed values
Krand=[];
for i = 1:20
    if spatial
        randCellNrs = datasample(nonSPhase1Ids,sP1count,'Replace',false);
        Drand = D(randCellNrs,randCellNrs);
        Krand = [Krand; discreteRK(D,Drand,A,bCells,randCellNrs)];
    else %spatiotemporal
        randCellNrs = datasample(nonSPhase1Ids,sP2count,'Replace',false);
        Drand = D(sPhase1Ids,randCellNrs);
        Krand = [Krand; discreteRK(D,Drand,A,bCells,sPhase1Ids)];
    end
    
end
end
%%
function K=discreteRK(D,DsP,A,bCells,sPhase1Ids)
%%%
%%% K: K value array
%%% N1: number of S-phase 1 cells
%%% N2: number of S-phase 2 cells

K =[];
N1 = size(DsP,1);
N2=size(DsP,2);
DsP(DsP==0)=Inf; % make sure self self distances are not counted
% iterate over increasing radii r
for r = 1:1:150
    k = 0;
    %iterate over S-phase 1 cells
    for j =1: N1
        row = DsP(j,:);
        edgeC = 1;
        % check if edge correction is needed
        if min(D(bCells,sPhase1Ids(j))) < r
            % calculate the hight of the radial segment being outside A
            h=r-min(D(bCells,sPhase1Ids(j)));
            %area of radial segment outside A
            A2=r^2* acos(1-h/r)-(r-h)*sqrt(2*r*h-h^2);
            % calculate proportion of the circle being inside A
            edgeC = (pi*r^2-A2)/(pi*r^2);            
        end
        
        % sum up distances closer than r
        k = k + (sum(row < r))/edgeC;
    end
    % add K value to K array
    K = [K (k/N1)/(N2/A)];
end



end