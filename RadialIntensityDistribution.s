/*----------------------------------------------------------------------------------------------

Hit ctrl-enter to execute.

Description:

	This function generates the radial intensity distribution of the input image.
	If the input image is a diffractogram, it is packed complex as a result of the FFT. The data 
	type is changed to real by means of modulus extraction. 
	Then the image dimension (hight and width) is found from the image. 

	The image is displayed in cardinal coordinates, and needs to be transformed into polar coordinates. 
	The passed variable "sample" defines the number of segment of the 360 degree angular range. 
	The transformation of coordinates ("img" in cardinal, "dst" in polar) is realized by bilinear inter-
	polation (the use of warp function). Then line projection is easily calculated by adding up all
	the columns in "dst" (polar coordinates). The averaged line intensity is also normalized by the
	number of segment ("sample"). 

	From a script By Ming Pan,  Gatan, Inc.
	Modified and annotated by Paul Thomas, March 2001
	Modified and annotated by Robin Harmon, April 2001
	Modified by Benjamin Weare, December 2024
Ming
-----------------------------------------------------------------------------------------------*/

/*	RadialIntensityDistribution.
	It is passed a source image and the sampling density 
	i.e. the number of segments to split the full 360 degree
	angular range into.  It returns the rotationally averaged image */ 

image RadialIntensityDistribution(image img, number samples)
{
	// Define neccessary parameters and constants
	number pi = 3.1416
	number xscale, yscale, xsize, ysize
	number centerx, centery, halfMinor
	number scale = img.ImageGetDimensionScale(0)
	string unit = img.ImageGetDimensionUnitString(0)

	// Likewise, declare intermediate images
	image rotational_average, dst, line_projection
	
	// If the source image is complex, take the modulus						
	if ( img.ImageIsDataTypeComplex( ))
		img := modulus(img)

	// Get the dimension sizes, and determine half the smallest dimension 
	img.Get2dSize( xsize, ysize )
	halfMinor = min( xsize, ysize )/2

	// Find the centre of the image
	centerx = xsize / 2
	centery = ysize / 2

	// Convert the image to polar co-ordinates...
	dst := RealImage( "dst", 4, halfMinor, samples )
	dst = warp( img, icol*sin(irow*2*pi/samples) + \
			centerx, icol*cos(irow*2*pi/samples) + centery )

	// and create a line projection using the icol intrinsic variable, 
	// normalising with the sampling density
	line_projection := RealImage( "line projection", 4, halfMinor, 1 )
	line_projection.ImageSetDimensionScale( 0, scale )
	line_projection.ImageSetDimensionUnitString( 0, unit )
	line_projection = 0
	line_projection[icol,0] += dst
	line_projection /= samples

	return line_projection
}


//  Call function using the front image as input.
//  Display the results.  

image img := GetFrontImage()
ShowImage( RadialIntensityDistribution(img, 300 ) )

