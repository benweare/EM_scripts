'''
Script to run segmentation via NP-SAM.
'''

print('\nStarting NP-SAM.')

import time
import npsam as ns
from numpy import inf

files = [
    './liposome_data/00.dm4',
    './liposome_data/01.dm4',
    './liposome_data/02.dm4',
    './liposome_data/03.dm4',
    './liposome_data/04.dm4',
    './liposome_data/05.dm4',
    './liposome_data/06.dm4',
    './liposome_data/07.dm4',
    './liposome_data/08.dm4',
    './liposome_data/09.dm4',
    './liposome_data/10.dm4',
    './liposome_data/11.dm4',
    './liposome_data/12.dm4',
    './liposome_data/13.dm4',
    './liposome_data/14.dm4',
    './liposome_data/15.dm4',
]

'''
files = [
    './perovskite_data/00.dm4',
    './perovskite_data/01.dm4',
    './perovskite_data/02.dm4',
    './perovskite_data/03.dm4',
    './perovskite_data/04.dm4',
    './perovskite_data/05.dm4',
    './perovskite_data/06.dm4',
]
'''

print('\nImages:')
for file in files:
    print(file)

s = ns.NPSAM(files, select_image='HAADF')

#s.set_scaling('0.7532181143760681 nm')
s.convert_to_units('nm')


print('\nFinding masks.')

start_time = time.time()

# Larger models can take much longer to run.
s.segment(
    device = 'auto',# Chooses CUDA or CPU automatically. cuda, cpu, auto.
    SAM_model = 'f',# f, l, h, b, or auto (fast, large, huge, base, or auto)
    PPS = 128,# "Points per side", sampling gridsize for the image.
    shape_filter = False,# Removes "faulty masks", less good for concave particles.
    edge_filter = True,# Remove masks touching edge of image.
    crop_and_enlarge = False,
    invert = True,# Image inverted before running SAM.
    double = False,
    stepsize = 2,#Accuracy for overlap analysis.
    min_mask_region_area = 10,#Remove masks smaller than this.
)

end_time = time.time()

print('\nTime elapsed: ', str(end_time - start_time), 's')

# print model attributes.
#print('Model: ' )

print('\nSaving data.')
s.save_segmentation()

s.plot_masks()
