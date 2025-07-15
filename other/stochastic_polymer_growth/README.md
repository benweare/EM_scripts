# Stochastic Graph Polymer Model Version Notes

Some code from my PhD for creating a model lattice stochastically, in the context of covalent organic frameworks (and not having access to any existing modelling software). Primarily it was a reason to get into scripting. If you're curious and/or very bored, the details are in my thesis. 

I haven't looked at this in a long time so can't speak to it being accurate and/or useful for it's original purpose. It if you need to generate a graph stochastically you can indeed use MATLAB, but nowdays I'd probably use Python. If you find a use for this code I'd be astounded, let me know.

##Version 1:
- Creates a graph using nodes of arbitary covalency without assigned coordinates

##Version 2: 
- Creates a graph using nodes of arbitary covalency without assigned coordinates
- Adds simple ring closing based on a walk between nodes

##Version 3: 
- Adds absolute node coordinates, but nodes can be placed on top of one another

#Version 4: 
- Stops nodes being places on top of each other by checking each new coordinate against all other coordinates
-Much slower than v3, scales exponentially with number of nodes

##Version 5:
- Adds lookup tables to reduce scaling time
- Can turn ring closing on and off
- Can turn plotting on and off; off decreases sim time
- Can turn on some statisitcal analysis of the dataset
#Version 6:
-3D model  that allows adsorption of nodes to form new stacked sheets

##Version 7: 
-Can add extra nucleation points to have competing polymer growth
-"Big nodes" to prevent stacking

## Definitions
# Node up/down
- up is 2
- down is 1

# CovBonMat: Covalent Bonding Matrix
- n x n matrix (n=no monomers). Each element represents a bond bewteen 2 nodes. 1 = bond, 0 = no bond. Sum of row indicates how many bonds a monomer has. Column/row n represents node n.

# CoOrdMat: Coordinates Matrix
- n x 8 matrix. Row n represents row n. 
- Elements 1:3 are the [x y z] coordinates of the node. 
- Element 4 is whether the node is up (1) or down (2).
- Elements 5:7 are the [up/down left right] bonds. 1 = bond, 0 = no bond, 2 = adjacent node without bond. Sum[(5:7)>0] is the number of bonds to the node.
- Element 8 is the identity of the node, 

# CoOrdLUT: Coordinates Lookup Table
- Contains the coordinates of the adjacent nodes for each node in the graph in the form. 
- 1-3 are up/down, 4-6 are left, 7-9 are right of the node, 10-12 are above, 13-15 are below
- Coordinates are [x y z]

#AvailNodesLUT: Available Nodes Lookup Table
- Lookup table of all nodes that can accept a covalent bond
- Updates each cycle with which nodes can accept a bond

#NodesLUT:
- Starts as list of all nodes
- Saturated nodes are removed during each cycle, so it is a master list of nodes that are unsaturated
- Used to generate AvailNodesLUT at each step

#List of variables:
- min
- max
- adjacentNode
- selectedNode
- Adsorption: randomly picks whether to adsorb, then randomly picks to absorb to above or below existing node

#Results:
- Table of numercial results, 10 columns
- NoMonomers Covalency Total_possible_bonds Total_bonds Ratio_bonds_monomers Time -x-y +x+y -x+y +x-y
