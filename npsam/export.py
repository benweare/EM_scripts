'''
Script to export results of NP-SAM.
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

print('\nSaving data.')
s.export_all()

characteristics = ['area','diameter','overlap']
s.overview(save_as='results.pdf', characteristics=characteristics)