import numpy as np
import matplotlib.pyplot as plt
#import matplotlib.image as mpimg
import skimage
#import DigitalMicrograph as DM

from skimage import data, color
from skimage.feature import canny
from skimage.filters import sobel
from skimage.filters import gaussian
#Circles
from skimage.draw import circle_perimeter
from skimage.transform import hough_circle, hough_circle_peaks
#Ellipses
from skimage.transform import hough_ellipse
from skimage.draw import ellipse_perimeter

#clean up
plt.close('all')

input_image = skimage.io.imread("unfiltered.tif")

#detection settings
sigma = 4
low_threshold = 0.1
high_threshold = 5

#circle settings
total_num_peaks = 3
min_radius = 38 #pixels
max_radius = 42 #pixels
step_radius = 2 #pixels

#ellipse settings
accuracy = 20
threshold = 250
min_size = 100
max_size = 120

#define functions
def CannyFilter( input_image, sigma, low_threshold, high_threshold ):
	edges = canny( input_image, sigma, low_threshold, high_threshold )
	return( edges )

def SobelFilter( input_image, sigma, low_threshold, high_threshold ):
	gauss_img = gaussian( input_image )
	#edges = sobel( gauss_img )
	edges = canny( input_image, sigma, low_threshold, high_threshold )
	fig2, (ax1, ax2, ax3) = plt.subplots(ncols=1, nrows=3, figsize=(8, 4), sharex=True, sharey=True)
	ax1.set_title('Input')
	ax1.imshow(input_image)
	ax2.set_title('Gauss')
	ax2.imshow(gauss_img)
	ax3.set_title('Sobel')
	ax3.imshow(edges)
	plt.show()
	return( edges )
	

def HoughCircles( input_image, edges, total_num_peaks, min_radius, max_radius, step_radius ):
	# Detect radii
	hough_radii = np.arange(min_radius, max_radius, step_radius)
	hough_res = hough_circle( edges, hough_radii )
	# Select the most prominent 3 circles
	accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii, total_num_peaks)
	#Draw them
	fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(10, 4))
	image = color.gray2rgb( input_image )
	for center_y, center_x, radius in zip(cy, cx, radii):
		circy, circx = circle_perimeter( center_y, center_x, radius, shape=image.shape )
		image[circy, circx] = ( 220, 20, 20 )
	#ax.imshow( input_image, cmap=plt.cm.gray )
	ax.imshow( edges, cmap=plt.cm.gray )
	plt.show()

def HoughEllipses( input_image, edges, accuracy, threshold, min_size, max_size ):
	# Perform a Hough Transform
	# The accuracy corresponds to the bin size of the histogram for minor axis lengths.
	# A higher `accuracy` value will lead to more ellipses being found, at the
	# cost of a lower precision on the minor axis length estimation.
	# A higher `threshold` will lead to less ellipses being found, filtering out those
	# with fewer edge points (as found above by the Canny detector) on their perimeter.
	result = hough_ellipse( edges, accuracy, threshold, min_size, max_size )
	result.sort(order='accumulator')
	# Estimated parameters for the ellipse
	best = list(result[-1])
	yc, xc, a, b = (int(round(x)) for x in best[1:5])
	orientation = best[5]
	# Draw the ellipse on the original image
	cy, cx = ellipse_perimeter(yc, xc, a, b, orientation)
	image_rgb[cy, cx] = (0, 0, 255)
	# Draw the edge (white) and the resulting ellipse (red)
	edges = color.gray2rgb(img_as_ubyte(edges))
	edges[cy, cx] = (250, 0, 0)
	fig2, (ax1, ax2) = plt.subplots(ncols=2, nrows=1, figsize=(8, 4), sharex=True, sharey=True)
	ax1.set_title('Original picture')
	ax1.imshow(image_rgb)
	ax2.set_title('Edge (white) and result (red)')
	ax2.imshow(edges)
	plt.show()

#Script starts here
edges = SobelFilter( input_image, sigma, low_threshold, high_threshold )
#HoughCircles( input_image, edges, total_num_peaks, min_radius, max_radius, step_radius )
#HoughEllipses( input_image, edges, accuracy, threshold, min_size, max_size )
#Scripts ends here