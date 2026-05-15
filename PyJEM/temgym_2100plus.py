import temgymbasic
from temgymbasic import components as comp
from temgymbasic.model import Model
from temgymbasic.run import show_matplotlib

import matplotlib.pyplot as plt

import numpy as np

# Relative height of components measured from top down, in mm.
rel_height = np.array( [1,# Gun
            4,# CL1
            4,# CL2
            4,# CL3
            2,# CA
            4,# C STIG
            4,# C DEF
            2,# CM
            #,# OA
            9.5,# Specimen
            4,# OL STIG
            3,# OL1
            #,# OM
            5,# OL2
            3,# IMAGE SHIFT
            #,# SA
            #,# ILSTIG
            6,# IL1
            5.5,# IL2
            2.5,# IL3
            2.5,# PL DEF
            3.0])# PL

# Absolute height.
height = np.flip(np.cumsum( np.flip(rel_height), axis=-1 ))
top = height[0] + 1

print(height)

# Scale diagram.
scale_factor = 0.1
top = top * scale_factor
height = height * scale_factor

# Taking the gun as the first crossover.
components = [comp.Lens(name = 'Electrostatic Lens',# Acting as the whole electron gun
                z = height[0], 
                f = -0.2),
              # 2 def in reality.
              #comp.DoubleDeflector(name = 'Gun def 1', 
              #  z_up = 2.8, 
              #  z_low = 2.7),
              comp.Lens(name = 'CL1', 
                z = height[1], 
                f = -0.2),
              comp.Lens(name = 'CL2', 
                z = height[2], 
                f = -0.2),
              comp.Lens(name = 'CL3', 
                z = height[3], 
                f = -0.2),
              comp.Aperture(name = 'CA', 
                z = height[4], 
                aperture_radius_inner=0.05),
              #comp.Quadrupole(name = 'C stig', 
              #  z = 2.2),
              # Spot align here
              # 2 def in reality.
              comp.DoubleDeflector(name = 'C def 1', 
                z_up = height[5]+(0.5*scale_factor), 
                z_low = height[5]-(0.5*scale_factor)),
              comp.Lens(name = 'CM', 
                z = height[6], 
                f = -0.2),
              #comp.Aperture(name = 'Objective Aperture', 
              #  z = 1.7, 
              #  aperture_radius_inner=0.05),
              #comp.Sample(name = 'Sample', 
              #  z = height[7]),
              comp.Quadrupole(name = 'OL Stig', 
                z = height[8]),
              comp.Lens(name = 'OL1', 
                z = height[9], 
                f = -0.2),
              #comp.Lens(name = 'OM', 
              #  z = 1.3, 
              #  f = -0.2),
              comp.Lens(name = 'OL2', 
                z = height[10], 
                f = -0.2),
              # 2 def in reality
              comp.DoubleDeflector(name = 'Image Shift 1', 
                z_up = height[11]+(0.5*scale_factor), 
                z_low = height[11]-(0.5*scale_factor)),
              #comp.Aperture(name = 'SA', 
              #  z = 0.9, 
              #  aperture_radius_inner=0.05),
              #comp.Quadrupole(name = 'IL stig', 
              #  z = 0.8),
              comp.Lens(name = 'IL1', 
                z = height[12], 
                f = -0.2),
              comp.Lens(name = 'IL2', 
                z = height[13], 
                f = -0.2),
              comp.Lens(name = 'IL3', 
                z = height[14], 
                f = -0.2),
              comp.DoubleDeflector(name = 'PL Def', 
                z_up = height[15]+ (0.5*scale_factor), 
                z_low = height[15]-(0.5*scale_factor)),
              comp.Lens(name = 'PL', 
                z =height[16], 
                f = -0.2)
              ]

# List of part labels
labels = []

#axis_view = 'x_axial'
plus_model = Model(components,
				beam_z=top,
				beam_type='x_axial',
                num_rays=32,
                gun_beam_semi_angle=0.15,
                beam_tilt_x=0)
name = 'model_tem.svg'

fig, ax = show_matplotlib(plus_model, name = name, label_fontsize = 14)
fig.suptitle('TEM Model', fontsize=32)
print(plus_model)

plt.show()