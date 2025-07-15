# Polymer data processing

Some code related to an ongoing but glacial project. 

## Input: 
  - Import data named "rawCHT" as a Numeric Matrix.
  - column 1: CircleID.
  - column 2: X/px.
  - column 3: Y/px.
  - column 4: Radius/px.
  - column 5: Score.
  - column 6: nCirc/frame.
  - column 7: Frame.
## Output: 
### sortedCHT: 
  - each frame sorted by increasing value in column 2.
  - columns 1 - 7 as for rawCHT.
  - column 8: pairwise seperation in pixels.
  - column 9: pairwise seperation in nanometres.
  - column 10: 1 if column 9 greater than distance_threshold_1, else 0
  - column 11: 1 if column 9 greater than distance_threshold_2, else 0
  - Columns 9&10: \[1 1\] = greater than distance_threshold_1; \[1 0] =intermediate value; \[0 0] = less than distance_threshold_2
### FrameData: 
  - column 1: frame number 
  - column 2: total number of species in frame, as sum of sortedCHT column 10
  - column 3: degree of polymerisation for frame.
  - column 4: fraction of monomer converted (p) for frame.
  - column 5: 1 \/ \[(1-p^2) -1]
  - column 6: number of unreacted pairs in frame, based on thresholds values
  - column 7: number of intermediate pairs in frame, based on thresholds values
  - column 8: number of reacted pairs in frame, based on thresholds values
  - column 9: number average
  - column 10: mass average
  - column 11: polydispersity index
  - column 12: left empty for cumlative fluence
### oligomerCount: 
  - matrix where each row corresponds to a frame, and each element to how many oligomers of that lengths are in the frame. 
  - e.g. element (22,4) = 1 means there is 1 oligomer of length 4 in frame 22
### adjMat: 
  - Gives 3D matrix where each 2D matrix is an adjacency matrix for that frame of the series.
  - Can be used to plot a graph of monomer connectivity for a given frame.
### noOligomers: 
  - Total number of oligomers per frame.

### Notes: 
  - Needs testing to make sure it matches reality
  - Graph section is WIP until above tests are done
