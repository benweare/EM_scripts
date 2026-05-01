# Electron Microscopy Scripts

A collection of various useful scripts, not associated with any particular publication. 

Most scripts are for controlling TEMs via DigitalMicrograph (DM) scripting in DMScript and Python, with some image processing scripts, and a few other scripts that don't fall neatly into a category. Anything in MATLAB is a legacy from my PhD.

If you found these useful, please drop a reference in your work so others can benefit too.

## Select List of Scripts

### Tomography

- auto-tomo: script for automated tomography. Records images over a tilt range by cloning the LiveView, and saves the angle metadata for repeatable measurements. Currently has no drift correction so relies on setting the eucentric height to minimise specimen drift in the x-y plane.

### Microscope Control 

- AutoBlank: this script blanks the beam after a set amount of time has passed. Useful for repeatable irradation experiments. 
- vary_high_tension: script to record how focus changes as a function of accelerating voltage, to measure chromatic aberration of a TEM.