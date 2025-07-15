# Electron Microscopy Scripts

A collection of various useful scripts, not associated with any particular publication. 

Most scripts are for controlling TEMs via DigitalMicrograph (DM) scripting in DMScript and Python, with some image processing scripts, and a few other scripts that don't fall neatly into a category. Anything in MATLAB is probably a legacy from my PhD.

If you found these useful, please drop a reference in your work so others can benefit too.

## List of Scripts

### Tomography

- auto-tomo: script for automated tomography. Records images over a tilt range by cloning the LiveView, and saves the angle metadata for repeatable measurements. Currently has no drift correction so relies on setting the eucentric height to minimise specimen drift in the x-y plane.

### Microscope Control 

- AutoBlank: this script blanks the beam after a set amount of time has passed. Useful for repeatable irradation experiments. 
- Measure_Cc: script to record how focus changes as a function of accelerating voltage, to measure chromatic aberration of a TEM. See: 
- Beam centering: scripts to move the beam to pre-defined location, i.e. center the beam on the camera.
- Various scripts for testing functionality in DM

### Image Processing 

- draw_zernike_polynomials creates image of the Zernike polynomials, and can be used to sum them together to make a phase plate. 
- define_custom_LUT allows changing the colour table of images in DM without having to save the LUT as an image beforehand. 
- Various scripts related to the Hough transform for circle detection in TEM images. 
- FourierFilter.py performs an automated Fourier filter of an input HRTEM image and returns the filtered image.
- TargetCentering.s draws a circle ROI in the centre of an image. Useful to find the geometric centre of the Live View during data collection sessions.

### Calculations 

- Calculate elastic mean free path of fast electron through a material.
- Calculate electron wavelength from accelerating voltage.

### Data handling 

- Scripts to convert files to differnt formats, and count files in a folder.

### Other

- A python script for communication over serial ports.
- A batch script for pinging domains and recording the results.
