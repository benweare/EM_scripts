import temgymbasic
from temgymbasic import components as comp
from temgymbasic.model import Model
from temgymbasic.run import show_matplotlib

import matplotlib.pyplot as plt

import numpy as np

# Relative height of components measured from bottom up, in mm.
# Taking viewing screen as the 0 height.
rel_height = np.array( [1,# Gun
            4,# CL1
            4,# CL2
            4,# CL3
            2,# CA
            4,# C STIG
            4,# C DEF
            2,# CM
            # x-ray aperture
            4,# Specimen
            5.5,# OA
            4,# OL STIG
            1,# OL1
            2,# OM
            5,# OL2
            3,# IMAGE SHIFT
            3,# SA
            3,# ILSTIG
            5.5,# IL1
            5.5,# IL2
            2.5,# IL3
            2.5,# PL DEF
            3])# PL - really 33 above viewing screen

# Absolute height.
height = np.flip(np.cumsum( np.flip(rel_height), axis=-1 ))
top = height[0] + 1

print(height)

# Scale diagram.
scale_factor = 0.1
top = top * scale_factor
height = height * scale_factor

# Focal length of lens.
focal_length = [-0.2,# Gun
                -0.2,# CL1
                -0.2,# CL2
                -0.2,# CL3
                -0.2,# CM
                -0.2,# OL1
                -0.2,# OM
                -0.2,# OL2
                -0.2,# IL1
                -0.2,# IL2
                -0.2,# IL3
                -0.2]# PL

# Aperture diameters.
cond_a = np.array([10, 5, 2, 1])/100
obj_a = np.array([10, 5, 2, 1])/100
sel_a = np.array([10, 5, 2, 1])/100

# Taking the gun as the first crossover.
components = [comp.Lens(name = 'Electrostatic Lens',# Acting as the whole electron gun
                z = height[0], 
                f = focal_length[0]),
              comp.Lens(name = 'CL1', 
                z = height[1], 
                f = focal_length[1]),
              comp.Lens(name = 'CL2', 
                z = height[2], 
                f = focal_length[2]),
              comp.Lens(name = 'CL3', 
                z = height[3], 
                f = focal_length[3]),
              comp.Aperture(name = 'CA', 
                z = height[4], 
                aperture_radius_inner = cond_a[0]),
              comp.Lens(name = 'CM', 
                z = height[7], 
                f = focal_length[4]),
              comp.Lens(name = 'OL1', 
                z = height[11], 
                f = focal_length[5]),
              comp.Lens(name = 'OM', 
                z = height[12], 
                f = focal_length[6]),
              comp.Lens(name = 'OL2', 
                z = height[13], 
                f = focal_length[7]),
              comp.Lens(name = 'IL1', 
                z = height[17], 
                f = focal_length[8]),
              comp.Lens(name = 'IL2', 
                z = height[18], 
                f = focal_length[9]),
              comp.Lens(name = 'IL3', 
                z = height[19], 
                f = focal_length[10]),
              comp.Lens(name = 'PL', 
                z =height[21], 
                f = focal_length[11])
              ]

screen_width = 20 *scale_factor

# List of part labels
labels = []

#axis_view = 'x_axial'
plus_model = Model(components,
				beam_z=top,
				beam_type='x_axial',
                num_rays=32,
                gun_beam_semi_angle=0.15,
                beam_tilt_x=0,
                detector_size=screen_width)
name = 'model_tem.svg'

fig, ax = show_matplotlib(plus_model,
                            name = name,
                            label_fontsize = 8)
fig.suptitle('2100Plus Scale Model',fontsize=10)

print(plus_model)
plt.show()