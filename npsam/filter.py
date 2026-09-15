'''
Script to filter NP-SAM segmentation.
'''

print('\nStarting NP-SAM.')

import npsam as ns
from numpy import inf

files = [
    './perovskite_data/00.dm4',
    './perovskite_data/01.dm4',
    './perovskite_data/02.dm4',
    './perovskite_data/03.dm4',
    './perovskite_data/04.dm4',
    './perovskite_data/05.dm4',
    './perovskite_data/06.dm4',
]

print('\nImages:')
for file in files:
    print(file)

s = ns.NPSAM(files, select_image='HAADF')

# Load data.
s.load_segmentation()

s.filter()# Does not work for some reason.

'''
print('Filtering masks.')
s[0].filter_nogui({
        'area': (7694.798889880162, 35825.095531989435),
        'solidity': (0.9653679653679653, 0.9871926580371208),
        'intensity_mean': (5769.23095703125, 5888.38720703125),
        'eccentricity': (0.5381057329628652, 0.7146242235569806),
        'overlap': (0, 71877),
        'number_of_overlapping_masks': inf,
        'removed_index': [],
})
'''