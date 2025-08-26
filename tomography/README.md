# Automatic Tomography

This script is used to capture tomography series automatically.

### Operation
This script works by capturing an image at each discrete tilt step.

Image alignment during data collection is currently under development, using a cross-correlation approach. 

### Step-by-step instructions

- Set microscope stage to eucentric height. 
- Set stage to desired starting angle. 
- Execute script. 
- Review data, and perform image alignment on data stack (e.g. via cross-correlaton). 

### Testing
It has been tested successfully with a JEOL 2100Plus TEM and a JEOL 2100F TEM, and should work with any TEM using a Gatan camera. 

This script is written in DigitalMicrograph Script, but could probably be rewritten in Python with a little effort.