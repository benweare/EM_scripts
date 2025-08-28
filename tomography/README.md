# Automatic Tomography

This script is used to capture tomography series automatically.

### Operation
This script works by capturing an image at each discrete tilt step.

Image alignment during data collection is currently under development, using a cross-correlation approach. 

### Example

This tomography series was acquired of negative-stained extra-cellular vesicles: 

![tomo_series_1](https://github.com/benweare/EM_scripts/tree/main/assets/images/full.gif)

![tomo_series_2](https://github.com/benweare/EM_scripts/tree/main/assets/images/extract.gif)

Images were acquired on a JEOL 2100Plus TEM with Gatan OneView camera, at 200 kV accelerating voltage. The specimen was rotated 121 degrees in 2 degree steps over 307 seconds. The images were acquired at 4k pixel resolution then binned to 256x256 for display. The images were aligned afrer acquisiton using cross-correlation in Digital Micrograph, and saved in GIF format using ImageJ. Thanks to R Pope for making the specimen and I Cardillo-Zallo for letting me acquire the data.

### Step-by-step instructions

- Set microscope stage to eucentric height. 
- Set stage to desired starting angle. 
- Execute script. 
- Review data, and perform image alignment on data stack (e.g. via cross-correlaton). 

### Testing
It has been tested successfully with a JEOL 2100Plus TEM and a JEOL 2100F TEM, and should work with any TEM using a Gatan camera. 

This script is written in DigitalMicrograph Script, but could probably be rewritten in Python with a little effort.
