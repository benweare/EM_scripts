# Zernike polynomials

A  Jupyter Notebook and Digital Micrograph script for drawing Zernike polynomials on a unit circle. 

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/zernike.png" alt="full" width="500"/>

In a TEM context, Zernike polynomials describe the aberration function. Included in the above image are aberrations to the third order labelled with the names used in the electron microscopy literaure. I have also included "piston", which is not usually considered in TEM but is part of the Zernike series. 

The usual literature on TEM aberrations was useful for this project, as was Optics (Hecht 2016). Van Brug was useful for deciding how to represent the polynomials in Python,though I used the radial form here.

### Citations

- Van Brug HH. Efficient Cartesian representation of Zernike polynomials in computer memory. In Delft, Netherlands; 1997 [cited 2025 Apr 15]. p. 382. Available from: http://proceedings.spiedigitallibrary.org/proceeding.aspx?doi=10.1117/12.294412

- Hecht E. Optics. 5th edn. Harlow: Pearson Education; 2016.