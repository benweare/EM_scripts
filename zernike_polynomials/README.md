# Zernike polynomials

A  Jupyter Notebook and Digital Micrograph script for drawing Zernike polynomials on a unit circle. 

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/zernike.png" alt="full" width="500"/>

In the context of TEM, Zernike polynomials can be used to describe the aberration function, where each polynomial corresponds to an optical aberration. The above diagram is labelled using the naming conventions for aberrations in electron microscopy, but I have also included "piston" which is not usually considered in TEM. The above diagram is organised according to azimuthal symmetry (increasing left to right) and radial symmetry (increasing top to bottom), which is indicated by the C<sub>nm</sub> labels (Brydon 2011). I have omitted the aberrations with negative azimuthal symmetry from the diagram, but they are accounted for in the scripts. 

Optical aberrations in TEM can be treated explicitly using the contrast transfer function scripts in this repo, but the Zernike polynomials make nice diagrams. You could also use them to make a model phase plate by summing them together. 

The usual literature on TEM aberrations was useful for this project, as was Optics (Hecht 2016). Niu at el and Van Brug were useful for deciding how to represent the polynomials in Python, though I used the radial form here.

### Citations
- Brydson R, editor. Aberration-corrected analytical transmission electron microscopy. Chichester, West Sussex: RMS-Wiley; 2011.
- Hecht E. Optics. 5th edn. Harlow: Pearson Education; 2016.
- Niu K, Tian C. Zernike polynomials and their applications. J Opt. 2022 Dec 1;24(12):123001. DOI: 10.1088/2040-8986/ac9e08 
- Van Brug HH. Efficient Cartesian representation of Zernike polynomials in computer memory. In Delft, Netherlands; 1997 [cited 2025 Apr 15]. p. 382. Available from: http://proceedings.spiedigitallibrary.org/proceeding.aspx?doi=10.1117/12.294412

Please cite this repo if you found it helpful! 

## Addendum - aberration nomenclature

### Electron microscopy

Via Brydson 2011:

| Radial Order | Azimuthal Order | Name | Krivanek Notation | Other Notation |
| -------- | ------- | -------- | ------- | -------- |
| 0 | 1  | Image shift | C01 |  |
| 1 | 0  | Defocus | C10 | C1 |
| 1 | 2  | Two-fold astigmatism | C12 | A1 |
| 2 | 1  | Axial coma | C21 | B2 |
| 2 |  3 | Three-fold astigmatism | C23 | A2 |
| 3 | 0  | Spherical | C30 | Cs, C3 |
| 3 | 2  | Axial star | C32 | S2 |
| 3 |  4 | Four-fold astigmatism | C34 | A3 |


### Optics 

Via Niu et al.:

| Radial Order | Azimuthal Order | Name |
| -------- | ------- | -------- |
| 0 | 1  | Piston |
| 1 | 1  | Tilt-Y |
| 1 | -1  | Tilt-X |
| 2 | -2  | Astigmatism |
| 2 | 0 | Defocus | Defocus |
| 2 | -2  | Astigmatism |
| 3 | -3  | Trefoil |
| 3 | -1  | Coma |
| 3 | -1  | Coma |
| 3 | -3  | Trefoil |
| 4 | -4  | Quadrafoil |
| 4 | -2  | Secondary astigmatism |
| 4 | 0  | Spherical  |
| 4 | -2  | Secondary astigmatism |
| 4 | -4  | Quadrafoil |
