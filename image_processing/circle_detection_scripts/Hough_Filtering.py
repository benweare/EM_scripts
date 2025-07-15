# Hough_Filtering.py
# BLW @ NMRC, 20-06-24
# This script uses the Hough circle transform to find circles in images
# Circles are drawn on the input image, and coordinates are outputted as as csv file
# Image should be pre-processed by cropping to minimum area, and binning can be done at this stage
# Input:
# - Standard deviation and thresholds for for canny filter
# - Scaling factor for binning (1 =  no binning, 0.5 = 2x binning); aliasing
# - Hough circle radius, Hough score, etc. 
# Settings will have to be tweaked for optimum detection, more fiddling for noisier images 
#
#Import packages
#Generic packages
import numpy as np
import matplotlib.pyplot as plt
import csv
import skimage
#Drawing tools
from skimage import data, color
from skimage.feature import canny
#Circles
from skimage.draw import circle_perimeter
from skimage.transform import hough_circle, hough_circle_peaks, rescale

#Define functions
#Canny filter
def CannyFilter( input_image, sigma_canny, low_threshold, high_threshold ):
	edges = canny( input_image, sigma_canny, low_threshold, high_threshold )
	return( edges )
#Hough transform and data output
def HoughCircles( input_image, edges, total_num_peaks, min_radius, max_radius, step_radius, min_xsep, min_ysep, HCthreshold ):
	# Detect circles
	hough_radii = np.arange(min_radius, max_radius, step_radius)
	hough_res = hough_circle( edges, hough_radii )
	# Select circles based on input parameters 
	accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii, min_xsep, min_ysep, HCthreshold, total_num_peaks )
	#Write data to csv file as numpy array
	CircleDataX = np.array(cx)
	CircleDataY = np.array(cy)
	CircleData = np.column_stack((CircleDataX, CircleDataY))
	np.savetxt('OutputData.txt',CircleData, delimiter = ', ', fmt = '%i')
	print(CircleData)
	#Draw circles 
	fig2, ( ax1, ax2 ) = plt.subplots(ncols=1, nrows=2, figsize=(10, 8), sharex=True, sharey=True)
	ax1.set_title( 'Canny Filter' )
	ax1.imshow(edges, cmap='gray')
	ax2.set_title( 'Hough Output' )
	circles_img = input_image#rgb_image 
	for center_y, center_x, radius in zip(cy, cx, radii):
		circy, circx = circle_perimeter( center_y, center_x, radius, shape = circles_img.shape )
		circles_img[circy, circx] = 1 #(255, 0, 0)
	ax2.imshow( circles_img, cmap='gray' )
	plt.show()
#Binning; only works if the histograms are matched afterwards. Can control byte type here
def ResizeImg( raw_img, scaling_factor, should_i_alias ):
	resized_img = skimage.transform.rescale( raw_img, scaling_factor, anti_aliasing = should_i_alias )
	resized_img = skimage.exposure.match_histograms( resized_img, raw_img )
	return( resized_img )

#Define variables
input_image = skimage.io.imread("bubbles.tif", dtype=np.int8 )

#detection settings
sigma_canny = 2.0
low_threshold = 0.05
high_threshold = 5

#resize
resize_scale = 1.0
should_i_alias = False

#Hough transform settings
total_num_peaks = 50
min_radius = 6 #pixels
max_radius = 10 #pixels
step_radius =1 #pixels
min_xsep = 12 #seperation between circles
min_ysep = 12 #seperation between circles
HCthreshold = 0.4

#Script starts here
plt.close('all') #clean up
resized_image = ResizeImg( input_image, resize_scale, should_i_alias )
edges = CannyFilter( resized_image, sigma_canny, low_threshold, high_threshold )
HoughCircles( resized_image, edges, total_num_peaks, min_radius, max_radius, step_radius, min_xsep, min_ysep, HCthreshold )
#End