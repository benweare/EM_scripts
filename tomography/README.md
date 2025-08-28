# Automatic Tomography

This script is used to capture tomography series automatically. It's main advantage is it faster than performing tomography manually, and requires no user input freeing you to do other tasks.

### Operation
This script works by capturing an image at each discrete tilt step. At each step an image is captured and the stage tilt angle is recorded. The output is an image stack and a metadata file in CIF format (i.e. human readable).

Image alignment during data collection is currently under development, using a cross-correlation approach. For best results, ensure your stage is set to eucentric height and the sample drift is minimal over the desired rotation range.

### Example

This tomography series was acquired of negative-stained extra-cellular vesicles: 

<img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/full.gif" alt="full" width="200"/> <img src="https://github.com/benweare/EM_scripts/blob/main/assets/images/extract.gif" alt="extract" width="200"/>

Tomography metadata was collected automatically and saved in CIF format.

Images were acquired on a JEOL 2100Plus TEM at 200 kV accelerating voltage, with Gatan OneView camera in imaging mode ("I" mode). The specimen was rotated 121&deg; in 2&deg; steps over 307 seconds. The images were acquired at 4k pixel resolution (pixel size = 0.45284 nm), then binned to 256x256 for cross-correlation. The images were aligned afrer acquisiton using cross-correlation in Digital Micrograph (v3.6), then had contrast enhanced and were saved in GIF format using FIJI (Schindelin et al. 2012). Thanks to R Pope for making the specimen, and I Cardillo-Zallo for letting me acquire the data.

### Step-by-step instructions

This script is based off of my diffraction tomography project, please see this repo for more useful information about tomography and script useage: [GiveMeED](https://github.com/benweare/GiveMeED)

- Set microscope stage to eucentric height. 
- Set stage to desired starting angle. 
- Execute script. 
- Review data: metadata file can be opened using a text editor.
- Perform image alignment on data stack (e.g. via cross-correlaton). 

### Testing
It has been tested successfully with a JEOL 2100Plus TEM and a JEOL 2100F TEM, and should work with any TEM using a Gatan camera. 

This script is written in DigitalMicrograph Script, but could probably be rewritten in Python with a little effort.

Please cite this repo if you found this script useful in your own work.

### Citations
Schindelin, J., Arganda-Carreras, I., Frise, E. et al. Fiji: an open-source platform for biological-image analysis. Nat Methods 9, 676–682 (2012). https://doi.org/10.1038/nmeth.2019 
