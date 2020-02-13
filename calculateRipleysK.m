function [K, Krand]=calculateRipleysK(NSCs, D, Dsp)

%% calculate area of hemispheres via triangulation
tri = delaunay(NSCs(:,1:2));
bCells = bordersOfTriangulation(tri);%to check which cells need to be checked for edge correction
sPhase1Ids=find(ismember(NSCs(:,4),[1,3,4]));
nonSPhase1Ids=find(~ismember(NSCs(:,4),[1,3,4]));%ids to sample from
P = NSCs(:,1:3);
%Obtain the edges in each triangle formed by the 'delaunaytriangulation'
v1 = P(tri(:,2), :) - P(tri(:,1), :);
v2 = P(tri(:,3), :) - P(tri(:,2), :);
%Calculating the cross product of the edges in each triangle of the surface
cp = 0.5*cross(v1,v2);
%Surface area A of the entire surface is calculated as the sum of the areas of the individual triangles
A = sum(sqrt(dot(cp, cp, 2)));

sP1count=size(Dsp,1);
sP2count=size(Dsp,2);
spatial = issymmetric(D);
K=ripleysK(D,DsP,A,bCells,sPhase1Ids);
%% randomly sampling for comparison to observed values
for i = 1:20
    if spatial
        randCellNrs = datasample(nonSPhase1Ids,sP1count,'Replace',false);
        Drand = D(randCellNrs,randCellNrs);
        
    else %spatiotemporal
        randCellNrs = datasample(nonSPhase1Ids,sP2count,'Replace',false);
        Drand = D(sPhase1Ids,randCellNrs);

    end
    Krand = [Krand; ripleysK(D,Drand,A,bCells,sPhase1Ids)];
end
end
%% 
function K=ripleysK(D,DsP,A,bCells,sPhase1Ids)

K =[];
maxT = 150;
N1 = size(DsP,1);
N2=size(DsP,2);
lambda = N1/A;
tStep = 1;

for t = 1:tStep:maxT
    r = 0;
    for j =1: N1
        row = D(j,:);
        cut = 1;

        if min(Dall(bCells,sPhase1Ids(j))) < t            
            R = t;
            h=R-min(Dall(bCells,sPhase1Ids(j)));
            %area of segment
            A2=R^2* acos(1-h/R)-(R-h)*sqrt(2*R*h-h^2);
            cut = (pi*R^2-A2)/(pi*R^2);

        end
        correctionTerm = 1;
        if ~issymmetric(round(D))
           correctionTerm =0; 
        end
        % distances lower t but exclude self dist
       r = r + (sum(row < t) -correctionTerm)/cut; 
    end
    K = [K (r/N2)/lambda];
end

t = 1:tStep:maxT;

end