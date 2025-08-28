# Contrast Transfer Function Scripts

The contrast transfer function (CTF) is an important concept for high-resolution TEM (HRTEM) You can learn about the contrast transfer function in great detail from several textbooks. There are some options for simulating CTFs but I couldn't find any for fitting experimental CTFs, hence the development of these notebooks and functions.

If you find this repo useful, please cite it so other people can find it! 

## CTF simulation

Simulating CTFs is great for understaning them. You can use this to see how the CTF varies with wavelength and lens aberrations, and how these affect the frequencies present in HRTEM images. If you know certain parameters from your own TEM, you can simulate CTFs quantitatively to match to your experimental data. 

### 1D CTF

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/1d.png" alt="1d CTFs" width=500 /> 

This allows you to simulate 1D CTFs and through-focus series. The modelled CTF includes damping from an aperture function, spatial envelope, and temporal envelope. The CTF (left) was simulated for 200 kV electrons at defocus of -150 nm with spherical aberration of 1.6 mm and chromatic aberration of 1.6 mm. The through focus series (right) used the same settings, but varied defocus from 0 nm to -100 nm in 10 nm steps. 

### 2D CTF

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/2d.png" alt="2d CTFs" width=500 />

2D CTFs can also be simulated, with a range of defocus and optical aberrations applied. 2D through-focus series can also be simulated (below).  

 <img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/TF.gif" alt="2d CTFs" width=200 />

### Operation
Developed using Python 3, using Matplotlib and Numpy. CV2 is used for simulating 2D through-focus series.

Variables:

- Accelerating voltage (electron wavelength)
- Defocus
- Spherical aberration
- Chromatic aberration 
- Two-fold astigmatism

## CTF simulation
If you can simualte a CTF, you can fit experimental data. This is useful for e.g. estimating defocus precisely (the microscope stage and the objective lens excitation add together to give the real defocus!).

### Examples

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/1d_fitting.png" alt="2d CTFs" width=500 />

Above are fitted 1D CTFs from a FEG TEM (left) and a LaB6 TEM (left). Strictly the FEG source is a Schottky source, but I won't tell if you don't. The fit estimated the defocus as -228 nm and -284 nm respectively, which was stable for spherical aberration over 1.0 - 2.0 mm. Fitting was easier for the FEG TEM due to the more coherent source giving rise to a greater number of sharper peaks to fit. CTF fitting for a LaB6 is possible but challenging. 

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/2d_fitting.png" alt="2d CTFs" width=500 />

Above are fitted 2D CTFs from the same FEG TEM (left) and LaB6 TEM (left). There is significant two-fold astigmatism in the LaB6 CTF, which has been fitted reasonably well. I stigmated the lens on purpose for this example, but I'd always advise you don't do that when collecting data.

### Exeperimental

Images for CTF fitting were acquired on a JEOL 2100Plus TEM with LaB6 source with Gatan OneView camera in imaging mode ("I" mode) at 1 frame per second, or a JEOL 2100F TEM with FEG source at 200 kV accelerating voltage with Gatan K3 camera imaging at 1 frame per second. The stage was set to neutral focus height, then defocus was controlled via the excitation of the objective lens. The images were acquired at 4k pixel resolution. The specimen was an amorphous carbon film on continuous carbon film coated Cu TEM grids (300 mesh, EM Resolutions). 2D CTFs were made by taking a Fourier transform of the image of the specimen, then converting to real 4-byte data using the log-modulus. A 400x400 pixel region of the Fourier transform containing the CTF was extracted and binned to 200x200 pixels for fitting. 1D CTF were made by taking the radial average of the real-valued Foruier transform. Image processing was perfomed in Digital Micrograph (v3.6), then saved as .tif files suitable for fitting using FIJI (Schindelin et al. 2012).

### Operation
Developed using Python 3, using Matplotlib and Numpy. Ski-kit Image was used to import images, and Lmfit was used to fit the CTFs. 


## Citations
Schindelin, J., Arganda-Carreras, I., Frise, E. et al. Fiji: an open-source platform for biological-image analysis. Nat Methods 9, 676–682 (2012). https://doi.org/10.1038/nmeth.2019  

### Bibliography
Learn more about CTFs here. I'd recommend starting with Williams and Carter before going on to Brydson. Uhlemann, Thust, and Krivanek were all helpful in deciphering the aberration function in a form understandable by myself and the computer.

Williams DB, Carter CB. Transmission electron microscopy: a textbook for materials science. 2nd ed. New York: Springer; 2008. 

Brydson R, editor. Aberration-corrected analytical transmission electron microscopy. Chichester, West Sussex: RMS-Wiley; 2011.

Uhlemann S, Haider M. Residual wave aberrations in the first spherical aberration corrected transmission electron microscope. Ultramicroscopy. 1998 May;72(3–4):109–19. 

Thust A, Overwijk MHF, Coene WMJ, Lentzen M. Numerical correction of lens aberrations in phase-retrieval HRTEM. Ultramicroscopy. 1996 Aug;64(1–4):249–64. 

Krivanek OL, Dellby N, Lupini AR. Towards sub-Å electron beams. Ultramicroscopy. 1999 June;78(1–4):1–11. 



