'''
Function to calculate camera length in SAED.

 Camera | Pixel size (um)
  K3    | 5
OneView | 15
'''

def calculate_camera_length( distance, lamb, size ):# d = wL/R
    d = (1/distance)*1e-9 #distance per pixel, in 1/nm
    w = (lamb)*1e-9 #wavelength, in nm
    R = size*1e-6 # real distance, 1 pixel = 15 um

    length = (d * R) / w
    return length

length = calculate_camera_length( 0.049546, 0.00251, 5 )
print( 'camera length = ' + str(length*1000) + ' mm' + '\n' )