%% Polymerisation Data Processing
% A script related to an ongoing project.
%{
Input: 
  - Import data named "rawCHT" as a Numeric Matrix.
  - column 1: CircleID.
  - column 2: X/px.
  - column 3: Y/px.
  - column 4: Radius/px.
  - column 5: Score.
  - column 6: nCirc/frame.
  - column 7: Frame.
Output: 
1 - sortedCHT: 
  - each frame sorted by increasing value in column 2.
  - columns 1 - 7 as for rawCHT.
  - column 8: pairwise seperation in pixels.
  - column 9: pairwise seperation in nanometres.
  - column 10: 1 if column 9 greater than distance_threshold_1, else 0
  - column 11: 1 if column 9 greater than distance_threshold_2, else 0
  - Columns 9&10: [1 1] = greater than distance_threshold_1; [1 0] =intermediate value; [0 0] = less than distance_threshold_2
2 - FrameData: 
  - column 1: frame number 
  - column 2: total number of species in frame, as sum of sortedCHT column 10
  - column 3: degree of polymerisation for frame.
  - column 4: fraction of monomer converted (p) for frame.
  - column 5: 1 / [(1-p^2) -1]
  - column 6: number of unreacted pairs in frame, based on thresholds values
  - column 7: number of intermediate pairs in frame, based on thresholds values
  - column 8: number of reacted pairs in frame, based on thresholds values
  - column 9: number average
  - column 10: mass average
  - column 11: polydispersity index
  - column 12: left empty for cumlative fluence
3 - oligomerCount: 
  - matrix where each row corresponds to a frame, and each element to how many oligomers of that lengths are in the frame. 
  - e.g. element (22,4) = 1 means there is 1 oligomer of length 4 in frame 22
4 - adjMat: 
  - Gives 3D matrix where each 2D matrix is an adjacency matrix for that frame of the series.
  - Can be used to plot a graph of monomer connectivity for a given frame.
5 - noOligomers: 
  - Total number of oligomers per frame.

Notes: 
  - Needs testing to make sure it matches reality
  - Graph section is WIP until above tests are done
%}

% Define these variables 
number_of_fullerenes_at_start = 19; % total number of fullerenes at the start of the reaction
fullerene_mass = 720; % in Da, where 1 Da = 1.66053906660×10−27 kg
pixel_calibration = 0.0196633; % pixel size in nm 
distance_threshold_1 = 0.84; % distance between pairs above which they are seperate 
distance_threshold_2 = 0.92; % distance between pairs above which they are seperate 


%% Data processing starts here
start_num = 1;
noFrames = rawCHT(length(rawCHT),7);
sortedCHT = rawCHT;

% sorting frames by increasing x coordinate
for x = 1:1:noFrames
    test = sortedCHT(:,7) == x;
    num = sum(test);
    sortedCHT(start_num:(start_num + num -1),:) = sortrows(sortedCHT(start_num:(start_num + num -1),:),2);
    start_num = start_num + num;
end

pythag = zeros(length(sortedCHT),3);

% calculating distance between adjacent pairs
for x = 1 : (length(sortedCHT)-1)
    pythag(x,1) = sqrt((sortedCHT(x+1,2) - sortedCHT(x,2))^2 + (sortedCHT(x+1,3) - sortedCHT(x,3))^2);
end

% calculating calibrated distance and comparing to thresholds
pythag(:,2) = pythag(:,1)*pixel_calibration;
pythag(:,3) = pythag(:,2) > distance_threshold_1; % check < or >
pythag(:,4) = pythag(:,2) > distance_threshold_2; % check < or >
sortedCHT = [sortedCHT, pythag];

% counting number of unreacted, intermediates, and reacted per frame
count_intermediates = zeros(length(rawCHT),3);
for x = 1:length(pythag)
    if pythag(x,3:4) == [1, 1]
        count_intermediates(x,1) = 1;
    elseif pythag(x,3:4) == [1, 0]
        count_intermediates(x,2) = 1;
    elseif pythag(x,3:4) == [0, 0]
        count_intermediates(x,3) = 1;
    end
end

FrameData = zeros(noFrames,12); 
FrameData(:,1) = 1:1:noFrames;

start_num = 1;
for x = 1:1:noFrames
    test = sortedCHT(:,7) == x;
    num = sum(test);
    FrameData(x,6) = sum(count_intermediates(start_num:(start_num + num -1),1));
    FrameData(x,7) = sum(count_intermediates(start_num:(start_num + num -1),2));
    FrameData(x,8) = sum(count_intermediates(start_num:(start_num + num -1),3));
    start_num = start_num + num;
end

% calculating statistical quantities
start_num = 1;
for x = 1:1:noFrames
    test = sortedCHT(:,7) == x;
    num = sum(test);
    FrameData(x,2) = sum(sortedCHT(start_num:start_num + num -1,10), 1);
    FrameData(x,3) = number_of_fullerenes_at_start/FrameData(x,2); %Degree of polymerisation as a simple number ratio
    if FrameData(x,3) == Inf
        FrameData(x,3) = -1;
    end
    FrameData(x,4) = 1 - (FrameData(x,2)/number_of_fullerenes_at_start); %fraction of monomer converted
    FrameData(x,5) = 1 / ((1 - FrameData(x,4)^2) - 1);
    start_num = start_num + num;
end

% counting number and type of olgiomer per frame
oligomerCount = zeros(noFrames, 23);
start_num = 1;
for x = 1:1:noFrames
    test = sortedCHT(:,7) == x;
    num = sum(test);
    oligioLength = 1;
    for y = start_num : 1 : (start_num+num-1)
        if sortedCHT(y, 9) <= distance_threshold_1
            oligioLength = oligioLength +1;
        else
            oligomerCount(x,oligioLength) = oligomerCount(x,oligioLength) + 1;
            oligioLength = 1;
        end
    end
    start_num = start_num + num;
end

% calculating means and polydispersity index
oligomer_mass = zeros(1,width(oligomerCount));
for x = 1:width(oligomerCount)
    oligomer_mass(x) = x*fullerene_mass;
end
oligomer_mass_squared = oligomer_mass.^2;

for x = 1:1:noFrames
    FrameData(x,9) = sum(oligomer_mass .*oligomerCount(x,:)) / sum(oligomerCount(x,:)); % number average molecular weight
    FrameData(x,10) = sum(oligomer_mass_squared .*oligomerCount(x,:)) / sum(oligomer_mass .*oligomerCount(x,:)); % mass average molecular weight
    FrameData(x,11) = FrameData(x,10) / FrameData(x,9); %polydispersity index
end

clear oligomer_mass oligomer_mass_squared

% Create output table

%{
Output = array2table(FrameData);
Output.Properties.VariableNames(1) = "Frame_num";
Output.Properties.VariableNames(2) = "Num_in_frame";
Output.Properties.VariableNames(3) = "DoP";
Output.Properties.VariableNames(4) = "Frac_converted";
Output.Properties.VariableNames(5) = "idk_name";
Output.Properties.VariableNames(6) = "Unreacted";
Output.Properties.VariableNames(7) = "Intermediate";
Output.Properties.VariableNames(8) = "Reacted";
Output.Properties.VariableNames(9) = "Num_av";
Output.Properties.VariableNames(10) = "Mass_av";
Output.Properties.VariableNames(11) = "PDI";
Output.Properties.VariableNames(12) = "Fluence";
%}


% making adjacency matrix for oligomers per frames
start_num = 1;
adjMat = zeros(1,1);
coords = zeros(23,2);
coords(:,1) = 2:1:24;
coords(:,2) = 1;
for x = 1:1:noFrames
    test = sortedCHT(:,7) == x;
    num = sum(test);
    z = 1;
    for y = start_num : 1 : (start_num+num-1)
        if sortedCHT(y, 9) <= distance_threshold_1
            adjMat(z+1,z,x) = 1;
            adjMat(z,z+1,x) = 1;
        else
            adjMat(z,z+1,x) = 0;
            adjMat(z+1,z,x) = 0;
        end
        z = z+1;
    end
    %coords(1:num,:,x) = sortedCHT(start_num:num,2:3)
    start_num = start_num + num;
end

%{
x = 65;
G = graph(adjMat(:,:,x));% G_plot = plot(G);
G_plot=plot(G,'XData',coords(:,1),'YData',coords(:,2));
G_plot.NodeColor=1/255*[59, 82, 139];
G_plot.EdgeColor=1/255*[33, 145, 140];
G_plot.EdgeAlpha=1;
G_plot.LineWidth = 3;
G_plot.MarkerSize=12;
pbaspect([3 1 1])
ylim([0.5, 1.5])
xlim([1, 21])
ylabel('y-coordinate / px','FontSize',36,'FontName','Calibri');
xlabel('x-coordinate / px','FontSize',36,'FontName','Calibri');
title('Frame 20','FontSize',20,'FontName','Calibri')
%}

%noOligomers = sum(oligomerCount,2); %total number of species per frame

clear pythag noFrames start_num num pixel_calibration test distance_threshold_1 distance_threshold_2 number_of_fullerenes_at_start x y z
clear oligioLength count_intermediates fullerene_mass