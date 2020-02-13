function calculateRipleysK

%% calculate area of hemispheres via triangulation
tri = delaunay(cells(:,1:2));
P = cells(:,1:3);
%Obtain the edges in each triangle formed by the 'delaunaytriangulation'
v1 = P(tri(:,2), :) - P(tri(:,1), :);
v2 = P(tri(:,3), :) - P(tri(:,2), :);
%Calculating the cross product of the edges in each triangle of the surface
cp = 0.5*cross(v1,v2);
%Surface area A of the entire surface is calculated as the sum of the areas of the individual triangles
A = sum(sqrt(dot(cp, cp, 2)));

cellCount=size(D,1);
sP1count=size(Dsp,1);
intra = issymmetric(D);
%% randomly sampling for comparison to observed values
for i = 1:20
    if intra
        randCellNrs = datasample(1:cellCount,sP1count,'Replace',false);
        Drand = D(randCellNrs,randCellNrs);
        
    else %inter
        randCellNrs = datasample(1:(size(allCells,2)-numel(doublePositiveCells)-numel(doublePositiveCells4)),numel(doublePositiveCells4),'Replace',false);
        Dc3 = Din(end-numel(doublePositiveCells)-numel(doublePositiveCells4)+1:end-numel(doublePositiveCells4),randCellNrs);
        if ~(round(Dc3(1,2)) ==Dc3(1,2))
            randCells=allCells(randCellNrs);
            Dc3 = computeDistMatrix([[doublePositiveCells.x]' [doublePositiveCells.y]' [doublePositiveCells.z]'],'approx',0,0,p,zg,[[randCells.x]' [randCells.y]' [randCells.z]']);
        end
    end
    KcsrSC = [KcsrSC; ripleysK(mAll, m3New, Dc3,Din,idx,zg,p,A)];
end

%% 
function ripleysK(D,DsP,A)

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

        if min(Dall(b,idx(j))) < t            
            R = t;
            h=R-min(Dall(b,idx(j)));
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