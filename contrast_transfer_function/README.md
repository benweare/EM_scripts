# Contrast Transfer Function Scripts

The contrast transfer function (CTF) is an important concept for high-resolution TEM (HRTEM) You can learn about the contrast transfer function in great detail from several textbooks. There are some options for simulating CTFs but I couldn't find any for fitting experimental CTFs, hence the development of these notebooks and functions.

If you find this repo useful, please cite it so other people can find it! 

## CTF simulation

Simulating CTFs is great for understaning them. You can use this to see how the CTF varies with wavelength and lens aberrations, and how these affect the frequencies present in HRTEM images. If you know certain parameters from your own TEM, you can simulate CTFs quantitatively to match to your experimental data. 

### 1D CTF

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/1d.png" alt="1d CTFs" width=500 /> 

This allows you to simulate 1D CTFs and through-focus series. The modelled CTF includes damping from an aperture function, spatial envelope, and temporal envelope. The CTF (left) was simulated for 200 kV electrons at defocus of -150 nm with spherical aberration of 1.6 mm and chromatic aberration of 1.6 mm. The through focus series (right) used the same settings, but varied defocus from 0 nm to -100 nm in 10 nm steps. 

### 2D CTF

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/2d.png" alt="2d CTFs" width=500 /> <img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/TF.gif" alt="2d CTFs" width=500 />

2D CTFs can also be simulated, with a range of defocus and optical aberrations applied. 2D through-focus series can also be simulated (right).  

### Operation

Developed using Python 3, using Matplotlib and Numpy. CV2 is used for simulating 2D through-focus series.

Variables:

- Accelerating voltage (electron wavelength)
- Defocus
- Spherical aberration
- Chromatic aberration 
- Two-fold astigmatism


### Citations

