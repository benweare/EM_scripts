# Fourier Filtering
# BLW @ nmRC, 27-11-24
#
# Script performs automatic Foruier Filtering of HRTEM images.
# Image is imported and FT'd, then a maximum filter is used to find peaks in the FT.
# A mask is applied to remove everything but the peaks, then an iFT is performed.
# Larger images will take longer to process; the FT and iFT are the slow steps.
# No GUI.
#
# Tested with: .tif
# May work with .png and .jpg/.jpeg
#
## Dependancies: 
# scikit-image v. 0.22.0
# numpy v. 1.26.4
# scipy v. 1.13.1
# python v. 3.12.7
# matplotlib v. 3.8.4
#
###Packages###
import scipy
from scipy import ndimage as ndi
import numpy as np
import matplotlib.pyplot as plt
import skimage
from skimage.feature import peak_local_max
from skimage import data, img_as_float
###variables###
# name of your image
input_image = "input_rs.tif"
# threshold for maximum filter, adjust until all of the peaks in the FT are picked
thresh = 0.0025
# binning for maximum filter
window_size = 3
###functions###
def perform_fft( input_image ):
	im = img_as_float(input_image) #real space image as float
	imfft = np.fft.fft2(im)#real valued FFT for peak search
	imfft = np.fft.fftshift(imfft)#shifts zeros to centre of spectrum
	search_imfft = abs(imfft) #np.log((abs(imfft)))
	return( imfft, search_imfft )
def find_frequencies( search_imfft, imfft, thresh, window_size ):
	# searching for peaks in the modulus of the FT
	image_maxima = ndi.maximum_filter((search_imfft), size=window_size, mode='constant')
	# Comparison between image_max and im to find the coordinates of local maxima
	coordinates = peak_local_max( search_imfft, min_distance=5, threshold_rel = thresh )
	#take coordinates as peak centre then measure intensity in 3x3 area and also phase
	return( coordinates, image_maxima )
def inverse_fft( coordinates, image_size ):
	mask = np.zeros((image_size, image_size))
	for n in coordinates:
		mask[n[0], n[1]] = 1
		masked_fft = mask * imfft
	freq_plot = np.fft.ifft2( masked_fft )
	return(freq_plot)
###script starts here###
plt.close('all')
input_image = skimage.io.imread(input_image, dtype=np.int8 )
[imfft, search_imfft] = perform_fft( input_image )
image_size = int( len (imfft) )
[coordinates, image_maxima ] = find_frequencies( search_imfft, imfft, thresh, window_size )
freq_plot = inverse_fft( coordinates, image_size )
###plot figure###
fig2, ( ax1, ax2, ax3 ) = plt.subplots(ncols=3, nrows=1, figsize=(10, 8), sharex=True, sharey=True)
#Ax1
ax1.imshow(input_image, cmap=plt.cm.gray)
ax1.axis('off')
ax1.set_title('Original')
#ax2
ax2.imshow(np.log(abs((imfft))), cmap=plt.cm.gray)
ax2.axis('off')
ax2.set_title('FFT')
ax2.plot(coordinates[:, 1], coordinates[:, 0], 'r.')
#ax3
ax3.set_title('Frq')
#ax3.imshow( abs(freq_plot), cmap=plt.cm.gray)
ax3.imshow( abs(freq_plot), cmap=plt.cm.gray)
plt.show()