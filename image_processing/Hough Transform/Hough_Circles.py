#https://scikit-image.org/docs/stable/auto_examples/edges/plot_circular_elliptical_hough_transform.html
import numpy as np
import matplotlib.pyplot as plt
#import matplotlib.image as mpimg
import skimage

plt.close('all')

from skimage import data, color
from skimage.transform import hough_circle, hough_circle_peaks
from skimage.feature import canny
from skimage.draw import circle_perimeter
from skimage.util import img_as_ubyte

#detection settings
sigma = 5
low_threshold = 10 
high_threshold = 50
total_num_peaks = 300


# Load picture and detect edges
image = skimage.io.imread("unfiltered.tif")
imp = image
edges = canny(image, sigma, low_threshold, high_threshold)

# Detect two radii
hough_radii = np.arange(24, 30, 2)
hough_res = hough_circle(edges, hough_radii)

# Select the most prominent 3 circles
accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii, total_num_peaks)

# Draw them
image = color.gray2rgb(image)
for center_y, center_x, radius in zip(cy, cx, radii):
    circy, circx = circle_perimeter(center_y, center_x, radius, shape=image.shape)
    image[circy, circx] = (255, 0, 0)

fig, ( ax1, ax2 ) = plt.subplots(ncols=1, nrows=2, figsize=(8, 4), sharex=True, sharey=True)
ax1.set_title('Input')
ax1.imshow(imp)
ax2.set_title('Hough')
ax2.imshow(image)

plt.show()

