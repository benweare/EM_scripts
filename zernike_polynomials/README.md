# Zernike polynomials

A  Jupyter Notebook and Digital Micrograph script for drawing Zernike polynomials on a unit circle. 

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/zernike.png" alt="full" width="500"/>

In the context of TEM, Zernike polynomials can be used to describe the aberration function, where each polynomial corresponds to an optical aberration. The above diagram is labelled using the naming conventions for aberrations in electron microscopy, but I have also included "piston" which is not usually considered in TEM. The above diagram is organised according to azimuthal symmetry (increasing left to right) and radial symmetry (increasing top to bottom), which is indicated by the C~nm~ labels (Brydon 2011). I have omitted the aberrations with negative azimuthal symmetry from the diagram, but they are accounted for in the scripts. 

Optical aberrations in TEM can be treated explicitly using the contrast transfer function scripts in this repo, but the Zernike polynomials make nice diagrams. You could also use them to make a model phase plate by summing them together. 

The usual literature on TEM aberrations was useful for this project, as was Optics (Hecht 2016). Van Brug was useful for deciding how to represent the polynomials in Python,though I used the radial form here.

### Citations
- Brydson R, editor. Aberration-corrected analytical transmission electron microscopy. Chichester, West Sussex: RMS-Wiley; 2011.
- Hecht E. Optics. 5th edn. Harlow: Pearson Education; 2016.
- Van Brug HH. Efficient Cartesian representation of Zernike polynomials in computer memory. In Delft, Netherlands; 1997 [cited 2025 Apr 15]. p. 382. Available from: http://proceedings.spiedigitallibrary.org/proceeding.aspx?doi=10.1117/12.294412

Please cite this repo if you found it helpful! 
