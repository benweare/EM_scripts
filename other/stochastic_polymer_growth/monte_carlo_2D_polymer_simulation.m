% Some code from my PhD for creating a model lattice stochastically. 
% If you're curious and/or very bored, check my thesis.
% I haven't looked at this in a long time so can't speak to it being accurate and/or useful.
% There is probably a better way to do this via Python.
% This is version 7.
%% Notes
%this version writes data directly to a graph object, and assigns absolute node coordinates
%this version uses a lookup table to suppress nodes being placed on top of
%each other more effciently
%This version attempts to make a 3D model polymer
%Can add other nucleation points

%groupcounts(CoOrdMat(:,3)) for how many nodes in each layer

% view(0,45) azimuth elivation
%AC= 90,135
%ZZ = 0,45
%FO=0,90
%SO=0,0

%% Bugs
%Check that angle between edges is 120 degrees
%Weird behaviour when different nucleation sites get near to each other
tic
%% On/Off variables
RingForming = 1; %1=on, 0 = off
workingGraph = 0;
plotting = 1;
colourCoding = 1;
StatisticalAnalysis = 1;
FullClosure = 1; % 1 = most possible bonds, 0 = some defects in bulk

%% Probability Control
RingProbability = 2; %2= ring forming, -1 = never ring forming, 1 to 0 is varying probability
AdsorptionProbability = 0.1; %0 = no adsorption, 1 = always adsorb
NoiseOn = 0; %1 = on, 0 = off

%% Bond length factors
%Use to change arbitrary coordinates to realisitic atomic coorindates
%yFactor = 1.426;
%xFactor = yFactor; %graphite
%zFactor = 3.395; %graphite
yFactor = 1;
xFactor = 1;
zFactor = 1;
widthFactor = 0.01;
%% Random Noise Control
%adds noise to the position of each point as a random addition to the
%position of the x, y, z coordinates
randLowerLimit = -0.1;
randUpperLimit = -randLowerLimit;

%% Setup
noMonomers=1500; %number of monomers
covalency=3; %covalency of monomers
CoOrdMat = zeros(noMonomers,10);
CoordCheck = 0;
CurrentCoord = [0 0 0];
CovBonMat=zeros(noMonomers,noMonomers); %covalent bonding matrix
CovBonGraph=graph; %graph object that will be a visual representation of the polymer
max=noMonomers+1; 
rowSum = sum(CoOrdMat(:,5:7)>=1,2);
CoOrdLUT = zeros(noMonomers,15);%LUT for which nodes are next to each node
NodesLUT = (1:noMonomers);
NodesLUT = NodesLUT.';%LUT for all nodes in script, for Covalent Bonding
AdsorptionNodesLUT = NodesLUT;%LUT for all nodes in script, for Adsorption
adjacentNode = 0;

%% Nucleation points
CoOrdMat(1,1:3) = [10,10,0]; CoOrdMat(2,8) = 1;
CoOrdMat(2,1:3) = [10,-10,0]; CoOrdMat(2,8) = 2;
CoOrdMat(3,1:3) = [-10,10,0]; CoOrdMat(2,8) = 3;
CoOrdMat(4,1:3) = [-10,-10,0]; CoOrdMat(2,8) = 4;
min = 5;

%% Start of while loop
CoOrdMat(1,8) = 1;
while min<max
    CoOrdMat(min,8) = min;
    rowSum(min) = sum(CoOrdMat(min,:)>=1,2);

   %% Picking where to add new node
   %This randomly chooses whether to add a new node by adsorption or
   %covalent bond
   if rand < AdsorptionProbability
       Adsorption = 1;
   else
       Adsorption = 0;
   end

   %This randomly picks a node from the LUT to add a new edge to
  if Adsorption == 0 %for covalent bonds
   AvailNodesLUT = NodesLUT; %this requires the LUT be sorted in order

            for LUTCreation = 1:1:numel(AvailNodesLUT)
               if AvailNodesLUT(LUTCreation) == min
                   AvailNodesLUT(LUTCreation) = [];
                   deletionPoint = LUTCreation-1;
                   break
               end
           end

           AvailNodesLUT = AvailNodesLUT(1:deletionPoint);

   NoNodesAvailable = numel(AvailNodesLUT); %Number of Nodes Available, find out the size of the LUT
   randPick = randperm(NoNodesAvailable,1); %Picks a random number based on the size of the LUT
   selectedNode = AvailNodesLUT(randPick); %Matches the random pick to an entry in the LUT
           
   rowSum(selectedNode) = sum(CoOrdMat(selectedNode,5:7)>=1);
  else
         AvailNodesLUT = AdsorptionNodesLUT; %this requires the LUT be sorted in order
            for LUTCreation = 1:1:numel(AvailNodesLUT)
               if AvailNodesLUT(LUTCreation) == min
                   AvailNodesLUT(LUTCreation) = [];
                   deletionPoint = LUTCreation-1;
                   break
               end
            end
           AvailNodesLUT = AvailNodesLUT(1:deletionPoint);
   NoNodesAvailable = numel(AvailNodesLUT); %Number of Nodes Available, find out the size of the LUT
   randPick = randperm(NoNodesAvailable,1); %Picks a random number based on the size of the LUT
   selectedNode = AvailNodesLUT(randPick); 
  end
        
        %% Assigning Coordinates to nodes
        %x plane is the horizontal plane of the screen, y plane is the verticle plane of the screen
        CurrentCoord(1) = CoOrdMat(selectedNode,1); %read current coordinates to calculate new coordinates from
        CurrentCoord(2) = CoOrdMat(selectedNode,2); %read current coordinates to calculate new coordinates from
        CurrentCoord(3) = CoOrdMat(selectedNode,3); %read current coordinates to calculate new coordinates from
       
        rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
        rowSum(selectedNode) = sum(CoOrdMat(selectedNode,5:7)>=1);
        %rowSum(min)=sum(CovBonMat(min,:)); %recalculate rowSum 
        %rowSum(selectedNode) = sum(CovBonMat(selectedNode,:));
        % FOR ALL NODES rowSum = sum(CoOrdMat(:,5:7)>=1,2) 
        % FOR ONE NODE  rowSum = sum(CoOrdMat(1,5:7)>=1)

        if min == 5
            NewCoOrd = [10 10 0]; min = 1; CoOrdMat(min,4) = randperm(2,1);
            SetAdjacentNodes(min, NewCoOrd, CoOrdMat, CoOrdLUT, yFactor, xFactor, zFactor)
            NewCoOrd = [10 -10 0]; min = 2; CoOrdMat(min,4) = randperm(2,1);
            SetAdjacentNodes(min, NewCoOrd, CoOrdMat, CoOrdLUT, yFactor, xFactor, zFactor)
            NewCoOrd = [-10 10 0]; min = 3; CoOrdMat(min,4) = randperm(2,1);
            SetAdjacentNodes(min, NewCoOrd, CoOrdMat, CoOrdLUT, yFactor, xFactor, zFactor)
            NewCoOrd = [-10 -10 0]; min = 4; CoOrdMat(min,4) = randperm(2,1);
            SetAdjacentNodes(min, NewCoOrd, CoOrdMat, CoOrdLUT, yFactor, xFactor, zFactor)
            min = 5;
        end

         if CoOrdMat(selectedNode,4) == 1 && Adsorption == 0
                CoOrdMat(min,4) = 2; 
         elseif CoOrdMat(selectedNode,4) == 2 && Adsorption == 0
                CoOrdMat(min,4) = 1; %checks whether it is bound to an up or down node and sets it as the opposite
         else
             CoOrdMat(min,4) = CoOrdMat(selectedNode,4); %Same up/down for adsorped nodes
         end

%% Selecting bonding site
%bondCheck is a 3 x 1 matrix which contains the bonding info for the 3
%bonding sites. If rowSum tells you how many bonds that node has
        %bondCheck = cat(2,CoOrdMat(selectedNode,5),CoOrdMat(selectedNode,6),CoOrdMat(selectedNode,7));
        bondCheck = CoOrdMat(selectedNode,5:7)>=1;
        bondPick = randperm(2,1); %randomly picks between 2 and 1

        if Adsorption == 1 && CoOrdMat(selectedNode,9) == 0 %picks to adsorb above or below
                CoordCheck = 4; %new node above
        elseif Adsorption == 1 && CoOrdMat(selectedNode,10) == 0
            CoordCheck = 5; %new node below
        elseif Adsorption == 1
            if randperm(2,1) == 1 %50:50 between above and below
                CoordCheck = 4;
            else 
                CoordCheck = 5;
            end
        
        elseif rowSum(selectedNode) == 0 && Adsorption == 0
            CoordCheck = randperm(3,1); %randomly pick where the bond is being formed, for the first bond in the matrix
        elseif rowSum(selectedNode) == 1 && Adsorption == 0%randomly pick from two available bonding sites
            if bondCheck(1) == 1 %pick randomly bewteen 2 and 3
                if bondPick == 1
                CoordCheck = 2;
                else 
                CoordCheck = 3;
                end
            elseif bondCheck(2) == 1  %pick randomly between 1 and 3
                if bondPick == 1
                CoordCheck = 1;
                else 
                CoordCheck = 3;
                end
            else %pick randomly between 1 and 2
                if bondPick == 1
                CoordCheck = 1;
                else 
                CoordCheck = 2;
                end
            end
        elseif rowSum(selectedNode) == 2 && Adsorption == 0 %only 1 place where new bond can form
            if bondCheck(1) == 0
                CoordCheck = 1; %bond up
            elseif bondCheck(2) == 0
                CoordCheck = 2; %bond left
            else 
                CoordCheck = 3; %bond right
            end
        end
        
%% Working out coordinates for new Node
%works out if the new node is up or down, and it's relative position to the
%selected node
          if Adsorption == 1 && CoordCheck == 4
              CoordChange = [0 0 1]*zFactor;%Code to make new z coordinate +1 otherwise the same
                site = 9;%has a node below it
                siteRec=10;%has a node above it
          elseif Adsorption == 1 && CoordCheck == 5
              site = 10;%has a node above it
                siteRec=9;%has a node below it
                CoordChange = [0 0 -1]*zFactor;
               
            elseif CoOrdMat(min,4) == 1%up
            if CoordCheck == 1
                %new point directly above current pont
                CoordChange = [0 cosd(0) 0]*yFactor; %matrix containing new coordinates in the form [x y z]#
                site = 5;
                siteRec=5;
            elseif CoordCheck == 2
                %new point down and left
                CoordChange = [-cosd(120) -sind(120) 0]*xFactor; %sine of 60 degrees = 0.866
                site = 6;
                siteRec=7;
            else %CoordCheck == 3
                %new point down and right
                CoordChange = [cosd(120) -sind(120) 0]*xFactor;
                site = 7;
                siteRec=6;
            end
        else %UpDownCheck = 2, down
             if CoordCheck == 1
                %new point directly below current pont
                CoordChange = [0 -cosd(0) 0]*yFactor; %matrix containing new coordinates in the form [x y z]
                site = 5;
                siteRec=5;%reciprocal bonding site on new node
             elseif CoordCheck == 2
                %new point up and left
                %CoordChange = [-0.5 sin((60/360)*2*pi) 0]; %changing polarity here caused weird graph shapes
                CoordChange = [-cosd(120) sind(120) 0]*xFactor; 
                site = 6;
                siteRec=7;
            else %CoordCheck == 3
                %new point up and right
                CoordChange = [cosd(120) sind(120) 0]*xFactor; %using non-interger coordinates can lead to rounding errors and incorrect node placement
                site = 7;
                siteRec=6;
            end
           end 

        NewCoOrd = round((CurrentCoord + CoordChange),3); %matrix addition to give new coordinates matrix
        %rounds new coordinate to 3 decimal places

%% Working out coordinates for adjacent nodes
        %CoOrdLUT(min,1:3) = NewCoOrd;%Updates coordinates LUT
       if CoOrdMat(min,4) == 2 %up
             CoOrdLUT(min,1:3) = NewCoOrd + [0 cosd(0) 0]*yFactor; %CoOrdMat(min,1:3 )= NewCoOrd; u/d
             CoOrdLUT(min,4:6) = NewCoOrd + [-cosd(120) -sind(120) 0]*xFactor;%l
             CoOrdLUT(min,7:9) = NewCoOrd + [cosd(120) -sind(120) 0]*xFactor;%r
       else %down
             CoOrdLUT(min,1:3) = NewCoOrd + [0 -cosd(0) 0]*yFactor; %CoOrdMat(min,1:3 )= NewCoOrd;
             CoOrdLUT(min,4:6) = NewCoOrd + [-cosd(120) sind(120) 0]*xFactor;
             CoOrdLUT(min,7:9) = NewCoOrd + [cosd(120) sind(120) 0]*xFactor;
       end
       CoOrdLUT(min,10:12) = NewCoOrd + [0 0 1]*zFactor;%above
       CoOrdLUT(min,13:15) = NewCoOrd + [0 0 -1]*zFactor;%below
       CoOrdLUT(min,:)=round(CoOrdLUT(min,:),3);

%% Updating bonding matrix
if Adsorption == 0
        CovBonMat(min,selectedNode) = 1; %(row,column), indicating a bond between monomers
        CovBonMat(selectedNode,min) = 1; %marks the bond in the appropriate column, row (mirror)

        rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
        rowSum(selectedNode) = sum(CoOrdMat(selectedNode,5:7)>=1);
         CoOrdMat(selectedNode,site) = 1; %tracks which bonding sites are used, 0 for unused and 1 for used
        CoOrdMat(min,siteRec) = 1; %tracks which bonding sites are used, 0 for unused and 1 for used, site reciprocal
        CovBonGraph=addedge(CovBonGraph,selectedNode,min);%makes edges between new node and selected node

end

        CoOrdMat(min,1:3 )= NewCoOrd;
        CovBonGraph=addnode(CovBonGraph,1); %adds one new node to graph

%% Finding Adjacent Nodes in z direction
    if CoOrdMat(min,9) == 0 %check to see if there is a bond here or not. u/d
        for x = 1:min-1
            if ((CoOrdMat(x,1:3) <= CoOrdLUT(min,10:12) + widthFactor) & CoOrdLUT(min,10:12) - widthFactor <= CoOrdMat(x,1:3))
                CoOrdMat(min,9) = 1;%marks selected node as having an a node below it
                CoOrdMat(x,10) = 1;%marks adjacent node as having a node above it
                rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
                rowSum(x) = sum(CoOrdMat(x,5:7)>=1);
                break
            end
        end
    end
    if CoOrdMat(min,10) == 0 %check to see if there is a bond here or not. u/d
        for x = 1:min-1
            if ((CoOrdMat(x,1:3) <= CoOrdLUT(min,13:15) + widthFactor) & CoOrdLUT(min,13:15) - widthFactor <= CoOrdMat(x,1:3))
                CoOrdMat(min,10) = 1;%marks selected node as having an a node below it
                CoOrdMat(x,9) = 1;%marks adjacent node as having a node above it
                break
            end
        end
    end

%% Finding Adjacent Nodes in x/y plane
    if CoOrdMat(min,5) == 0 %check to see if there is a bond here or not. u/d
        for x = 1:min-1
            if ((CoOrdMat(x,1:3) <= CoOrdLUT(min,1:3) + widthFactor) & CoOrdLUT(min,1:3) - widthFactor <= CoOrdMat(x,1:3))
                disp('lol')
                CoOrdMat(min,5) = 2;%marks selected node as having an adjacent node with no bond
                CoOrdMat(x,5) = 2;%marks adjacent node as being next to selected node with no bond
                rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
                rowSum(x) = sum(CoOrdMat(x,5:7)>=1);
         if rowSum(x) == 3 %updating LUT for to remove node 
           for nodeDeletion = 1:1:numel(NodesLUT)-1
               if NodesLUT(nodeDeletion) == x
                   NodesLUT(nodeDeletion) = [];
               end
           end
        end
                break
            end
        end
    end
    if CoOrdMat(min,6) == 0 %left
        for x = 1:min-1
            if ((CoOrdMat(x,1:3) <= CoOrdLUT(min,4:6) + widthFactor) & CoOrdLUT(min,4:6) - widthFactor <= CoOrdMat(x,1:3))
                CoOrdMat(min,6) = 2;%marks selected node as having an adjacent node with no bond
                CoOrdMat(x,7) = 2;%marks adjacent node as being next to selected node with no bond
                rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
                rowSum(x) = sum(CoOrdMat(x,5:7)>=1);
         if rowSum(x) == 3
           for nodeDeletion = 1:1:numel(NodesLUT)-1
               if NodesLUT(nodeDeletion) == x
                   NodesLUT(nodeDeletion) = [];
               end
           end
        end
                break
            end
        end
    end
    if CoOrdMat(min,7) == 0 %right
        for x = 1:min-1
            if ((CoOrdMat(x,1:3) <= CoOrdLUT(min,7:9) + widthFactor) & CoOrdLUT(min,7:9) - widthFactor <= CoOrdMat(x,1:3))
                CoOrdMat(min,7) = 2;%marks selected node as having an adjacent node with no bond
                CoOrdMat(x,6) = 2;%marks adjacent node as being next to selected node with no bond
                rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
                rowSum(x) = sum(CoOrdMat(x,5:7)>=1);
        if rowSum(x) == 3
           for nodeDeletion = 1:1:numel(NodesLUT)-1
               if NodesLUT(nodeDeletion) == x
                   NodesLUT(nodeDeletion) = [];
               end
           end
       end
                break
            end
        end
    else
    end

%% Updating node LUT to remove nodes that cannot take a new bond
%Adsorption LUT
    if sum(CoOrdMat(min,9:10)==2)
        for nodeDeletion = 1:1:numel(AdsorptionNodesLUT)-1
               if AdsorptionNodesLUT(nodeDeletion) == min
                   AdsorptionNodesLUT(nodeDeletion) = [];
               end
         end
    end
    if sum(CoOrdMat(selectedNode,9:10))==2
        for nodeDeletion = 1:1:numel(AdsorptionNodesLUT)-1
               if AdsorptionNodesLUT(nodeDeletion) == selectedNode
                   AdsorptionNodesLUT(nodeDeletion) = [];
               end
         end
    end

%Covalent bonding LUT
    rowSum(min) = sum(CoOrdMat(min,5:7)>=1);
    rowSum(selectedNode) = sum(CoOrdMat(selectedNode,5:7)>=1);

       if rowSum(selectedNode) == 3
           for nodeDeletion = 1:1:numel(NodesLUT)-1
               if NodesLUT(nodeDeletion) == selectedNode
                   NodesLUT(nodeDeletion) = [];
               end
           end
       end

       if rowSum(min) == 3
           for nodeDeletion = 1:1:numel(NodesLUT)-1
               if NodesLUT(nodeDeletion) == min
                   NodesLUT(nodeDeletion) = [];
               end
           end
       end

%% Ring Forming
        if RingForming == 1
            %draws a number bewteen 0 and 1, if greater forms a ring
            if rand <= RingProbability 

           selectedNode = min;
           bondCheck = CoOrdMat(selectedNode,5:7)==2;

           %these statements work out where to put new bond
           if sum(bondCheck) == 1 %1 place bond can form.
               if bondCheck(1) == 1
                   site =5;
                   siteRec=5;
               elseif bondCheck(2) == 1
                   site=6;
                   siteRec=7;
               else %bondCheck(3) == 1
                   site=7;
                   siteRec=6;
               end

           elseif sum(bondCheck)==2 && FullClosure == 1 %this picks both sites
                if bondCheck(1) == 0
                       site = 6;
                       siteRec = 7;
                       site2 = 7;
                       siteRec2 = 6;
               elseif bondCheck(2) ==0
                       site = 5;
                       siteRec = 5;
                       site2 = 7;
                       siteRec2 = 6;
                else %bondCheck(3) ==0
                       site = 5;
                       siteRec = 5;
                       site2 = 6;
                       siteRec2 = 7;
                end

           elseif sum(bondCheck)==2
               bondPick = randperm(2,1);%randomly pick between the two sites
               if bondCheck(1) == 0
                   if bondPick == 1
                       site = 6;
                       siteRec = 7;
                   else
                       site = 7;
                       siteRec = 6;
                   end
               elseif bondCheck(2) ==0
                   if bondPick ==1
                       site = 5;
                       siteRec = 5;
                   else
                       site = 7;
                       siteRec = 6;
                   end
               else %bondCheck(3) == 0
                   if bondPick == 1
                       site = 5;
                       siteRec = 5;
                   else
                       site = 6;
                       siteRec = 7;
                   end
               end
           else %if sum(BondCheck) == 0 or == 3
               site = 0;
           end

           %these statements work out which nodes the bond is between
           if site == 5
               adjacentNodeCoOrds = CoOrdLUT(selectedNode,1:3);
           elseif site == 6
               adjacentNodeCoOrds = CoOrdLUT(selectedNode,4:6);
           elseif site == 7
               adjacentNodeCoOrds = CoOrdLUT(selectedNode,7:9);
           end

           if site ~= 0 %adds new node if there is one to add

           for x = 1:min
               if CoOrdMat(x,1:3) == adjacentNodeCoOrds
                   adjacentNode = CoOrdMat(x,8);
                   break
               end
           end

         % Updating bonding matrix
        CovBonMat(adjacentNode,selectedNode) = 1; %(row,column), indicating a bond between monomers
        CovBonMat(selectedNode,adjacentNode) = 1; %marks the bond in the appropriate column, row (mirror)

        rowSum(adjacentNode) = sum(CoOrdMat(adjacentNode,5:7)>=1);
        rowSum(selectedNode) = sum(CoOrdMat(selectedNode,5:7)>=1);

        CoOrdMat(selectedNode,site) = 1; %tracks which bonding sites are used, 0 for unused and 1 for used
        CoOrdMat(adjacentNode,siteRec) = 1; %tracks which bonding sites are used, 0 for unused and 1 for used, site reciprocal

        CovBonGraph=addedge(CovBonGraph,selectedNode,adjacentNode);%makes edges between new node and selected node
           
        %These statements are for a second ring closure
           if sum(bondCheck)==2 && FullClosure == 1
           if site2 == 5
               adjacentNodeCoOrds2 = CoOrdLUT(selectedNode,1:3);
           elseif site2 == 6
               adjacentNodeCoOrds2 = CoOrdLUT(selectedNode,4:6);
           elseif site2 == 7
               adjacentNodeCoOrds2 = CoOrdLUT(selectedNode,7:9);
           end
           for x = 1:min
               if CoOrdMat(x,1:3) == adjacentNodeCoOrds2
                   adjacentNode2 = CoOrdMat(x,8);
                   break
               end
           end
        CovBonMat(adjacentNode2,selectedNode) = 1; %(row,column), indicating a bond between monomers
        CovBonMat(selectedNode,adjacentNode2) = 1; %marks the bond in the appropriate column, row (mirror)
        rowSum(adjacentNode2) = sum(CoOrdMat(adjacentNode2,5:7)>=1);
        rowSum(selectedNode) = sum(CoOrdMat(selectedNode,5:7)>=1);
        CoOrdMat(selectedNode,site2) = 1; %tracks which bonding sites are used, 0 for unused and 1 for used
        CoOrdMat(adjacentNode2,siteRec2) = 1; %tracks which bonding sites are used, 0 for unused and 1 for used, site reciprocal
        CovBonGraph=addedge(CovBonGraph,selectedNode,adjacentNode2);%makes edges between new node and selected node
           end

           end
           end
        end

%% Working graph
if workingGraph == 1
WorkingGraph=plot(CovBonGraph,'XData',CoOrdMat(1:min-1,1),'YData',CoOrdMat(1:min-1,2),'ZData',CoOrdMat(1:min-1,3)); %uncomment and add a pause to plot a graph at each step 
ylim([-10,10])
xlim([-10,10])
axis square
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
set(gca,'FontName','Calibri')
ylabel('y-coordinate','FontSize',36,'FontName','Calibri');
xlabel('x-coordinate','FontSize',36,'FontName','Calibri');
WorkingGraph.NodeColor = 1/255*[255 0 0];
WorkingGraph.EdgeColor = 1/255*[0 0 0];
WorkingGraph.EdgeAlpha = 1;
end

%CoOrdMatPrevious = CoOrdMat;%preserves previous graph state CoOrdMat for debugging
%AvailNodesLUTPrevious = AvailNodesLUT;

%% Next interation of while loop
    min=min+1;
    disp(selectedNode);
end %end of while loop

%% Colour coding nodes
if colourCoding == 1
rowSum = sum(CovBonMat,2);
a=1;
b=1;
c=1;
oneBond = zeros(sum(rowSum ==1),1);
twoBond = zeros(sum(rowSum ==2),1);
threeBond = zeros(sum(rowSum ==3),1);
for x=1:1:noMonomers
    if rowSum(x) == 1
        oneBond(a) = x;
        a=a+1;
    elseif rowSum(x) == 2
         twoBond(b) = x;
        b=b+1;
    elseif rowSum(x) ==3
         threeBond(c) = x;
        c=c+1;
    end
end
clear a b c x
end

%% Statistics on graph
% This quantifies which segment of the x-y plane the polymer is growing in
% the most, doubly counts those on boundaries
if StatisticalAnalysis == 1
    GrowthDirection = zeros(1,8);
    for loop = 1:1:length(CoOrdMat) %elseif statements were not working so 4 if statements
        if CoOrdMat(loop,1) <= 0 && CoOrdMat(loop,2) <= 0 && CoOrdMat(loop,3) <= 0 %all negative
            GrowthDirection(1,1) = GrowthDirection(1,1)+1;
        end
        if CoOrdMat(loop,1) >= 0 && CoOrdMat(loop,2) >= 0 && CoOrdMat(loop,3) >= 0 %all positive
            GrowthDirection(1,2) = GrowthDirection(1,2)+1;
        end
        if CoOrdMat(loop,1) <= 0 && CoOrdMat(loop,2) >= 0 && CoOrdMat(loop,3) >= 0 %nx, py, pz
            GrowthDirection(1,3) = GrowthDirection(1,3)+1;
        end
        if CoOrdMat(loop,1) >= 0 && CoOrdMat(loop,2) >= 0 && CoOrdMat(loop,3) >= 0 %nx, ny, pz
            GrowthDirection(1,4) = GrowthDirection(1,4)+1;
        end
        if CoOrdMat(loop,1) >= 0 && CoOrdMat(loop,2) >= 0 && CoOrdMat(loop,3) <= 0 %px, py, nz
            GrowthDirection(1,5) = GrowthDirection(1,5)+1;
        end
        if CoOrdMat(loop,1) >= 0 && CoOrdMat(loop,2) <= 0 && CoOrdMat(loop,3) >= 0 %px, ny, pz
            GrowthDirection(1,6) = GrowthDirection(1,6)+1;
        end
        if CoOrdMat(loop,1) >= 0 && CoOrdMat(loop,2) <= 0 && CoOrdMat(loop,3) <= 0 %px, ny, nz
            GrowthDirection(1,7) = GrowthDirection(1,7)+1;
        end
        if CoOrdMat(loop,1) <= 0 && CoOrdMat(loop,2) >= 0 && CoOrdMat(loop,3) <= 0 %nx, py, nz
            GrowthDirection(1,8) = GrowthDirection(1,8)+1;
        end
    end
end
clear StatistialAnalysis loop
%yline(0)
%xline(0)

%% Results table, add so it can write multiple runs into the same table
Results = table;
Results.Var1 = noMonomers;
Results.Var2 = covalency;
Results.Var3 = noMonomers*covalency;
Results.Var4 = sum(CovBonMat,'all')/2;
Results.Var5 = sum(CovBonMat,'all')/noMonomers;
Results.Var6 = 0;
if StatisticalAnalysis == 1
Results.Var7 = GrowthDirection(1); %-x -y
Results.Var8 = GrowthDirection(2);%+x +y
Results.Var9 = GrowthDirection(3);%-x +y
Results.Var10 = GrowthDirection(4);%+x -y
Results.Var11 = GrowthDirection(5);%+x -y
Results.Var12 = GrowthDirection(6);%+x -y
Results.Var13 = GrowthDirection(7);%+x -y
Results.Var14 = GrowthDirection(8);%+x -y
Results.Var15 = length(oneBond);
Results.Var16 = length(twoBond);
Results.Var17 = length(threeBond);
Results.Var18 = numel(AdsorptionNodesLUT)/numel(NodesLUT);
Results.Var19 = mean(groupcounts(CoOrdMat(:,3)));%average nodes per layer
Results.Var20 = length(groupcounts(CoOrdMat(:,3)));%number of layers
end

%% Adding random noise
if NoiseOn == 1
    CoOrdMat_10_noise=CoOrdMat_0_noise;
    for x = 1:1:length(CoOrdMat)
    CoOrdMat_10_noise(x,1) = (CoOrdMat(x,1)) + ((randUpperLimit-randLowerLimit)*rand() + randLowerLimit);
    CoOrdMat_10_noise(x,2) = (CoOrdMat(x,2)) + ((randUpperLimit-randLowerLimit)*rand() + randLowerLimit);
    CoOrdMat_10_noise(x,3) = (CoOrdMat(x,3)) + ((randUpperLimit-randLowerLimit)*rand() + randLowerLimit);
    end
disp('Adding noise')
end

%% Plotting graphics
if plotting == 1
GraphPlotting(CovBonMat, CoOrdMat,colourCoding,oneBond,twoBond,threeBond);
end

clear adjacentNode adjacentNodeCoOrds AvailNodesLUT bondPick bondCheck CoordChange CoordCheck CoOrdLUT
clear covalency CurrentCoord deletionPoint LUTCreation max min NewCoOrd nodeDeletion NoNodesAvailable
clear randPick rowSum selectedNode site siteRec x CovBonGraph_plot noMonomers
clear CovBonGraph colourCheck colourCoding RingForming plotting workingGraph 
clear RingProbability ans FullClosure StatisticalAnalysis oneBond twoBond threeBond
clear adjacentNode2 adjacentNodeCoOrds2 site2 siteRec2 NodesLUT
clear Adsorption AdsorptionProbability AdsorptionNodesLUT GrowthDirection xFactor zFactor randLowerLimit randUpperLimit
clear NoiseOn

Results.Var6 = toc;
disp(Results.Var6)

function SetAdjacentNodes(min, NewCoOrd, CoOrdMat, CoOrdLUT, yFactor, xFactor, zFactor)
        if CoOrdMat(min,4) == 2 %pp
             CoOrdLUT(min,1:3) = NewCoOrd + [0 cosd(0) 0]*yFactor; %CoOrdMat(min,1:3 )= NewCoOrd; u/d
             CoOrdLUT(min,4:6) = NewCoOrd + [-cosd(120) -sind(120) 0]*xFactor;%l
             CoOrdLUT(min,7:9) = NewCoOrd + [cosd(120) -sind(120) 0]*xFactor;%r
       else %down
             CoOrdLUT(min,1:3) = NewCoOrd + [0 -cosd(0) 0]*yFactor; %CoOrdMat(min,1:3 )= NewCoOrd;
             CoOrdLUT(min,4:6) = NewCoOrd + [-cosd(120) sind(120) 0]*xFactor;
             CoOrdLUT(min,7:9) = NewCoOrd + [cosd(120) sind(120) 0]*xFactor;
       end
       CoOrdLUT(min,10:12) = NewCoOrd + [0 0 1]*zFactor;%above
       CoOrdLUT(min,13:15) = NewCoOrd + [0 0 -1]*zFactor;%below
       CoOrdLUT(min,:)=round(CoOrdLUT(min,:),3);
end 


function GraphPlotting(CovBonMat,CoOrdMat,colourCoding,oneBond,twoBond,threeBond)
disp("plotting graph");
CovBonGraph=graph(CovBonMat);
CovBonGraph_plot=plot(CovBonGraph,'XData',CoOrdMat(:,1),'YData',CoOrdMat(:,2),'ZData',CoOrdMat(:,3));
CovBonGraph_plot.NodeColor=1/255*[0 0 255];
CovBonGraph_plot.EdgeColor=1/255*[0 0 0];
CovBonGraph_plot.EdgeAlpha=1;
CovBonGraph_plot.MarkerSize=5;
ylabel('y-coordinate','FontSize',36,'FontName','Calibri');
xlabel('x-coordinate','FontSize',36,'FontName','Calibri');
zlabel('z-coordinate','FontSize',36,'FontName','Calibri');
%xlim([-noMonomers,noMonomers]);
%ylim([-noMonomers,noMonomers]);
axis square
if colourCoding == 1
highlight(CovBonGraph_plot,oneBond,'NodeColor',1/255*[255 0 0])
highlight(CovBonGraph_plot,twoBond,'NodeColor',1/255*[0 0 255])
highlight(CovBonGraph_plot,threeBond,'NodeColor',1/255*[128 128 128])
else
highlight(CovBonGraph_plot,NodesLUT,'NodeColor',1/255*[255 0 0])
end
view(0,90);
end