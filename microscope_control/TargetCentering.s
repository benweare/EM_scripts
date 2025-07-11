// Target Centering
// 12-12-23
// B L Weare, @NMRC
// Resolution Rings 

//Create ROI
void CreateResRing( number radius, number x, number y, number r, number g, number b )
{
	ROI resRing = NewROI( )
	ROISetCircle(resRing, x, y, radius)
	image img := GetFrontImage()
	ImageDisplay imgDisplay = img.ImageGetImageDisplay(0)
	imgDisplay.ImageDisplayAddROI( resRing )
	
	ROISetColor( resRing, r, g, b) //RBG in 0-1
	ROISetMoveable( resRing, 0 )
	ROISetVolatile( resRing, 0 )
}

//Grab scale from image
number ScaleInfo( )
{
	image img := GetFrontImage()
	number img_scale = ImageGetDimensionScale(img, 0)
	string scale_units = ImageGetDimensionUnitString(img, 0)
	//result("Scale: " + img_scale + " " + scale_units + "\n")
	return img_scale
}

// Script starts here

//Define desired ring radius in nm-1
number ringRadius = 2

// This block gives geometric centre of image; for Fourier transforms.
image img := GetFrontImage()
number img_center_x = ImageGetDimensionSize(img, 0)/2
number img_center_y = ImageGetDimensionSize(img, 1)/2

//Colour of rings in RGB
number rval = 1; number gval = 0; number bval = 0

number scale = ScaleInfo( )
number pixRadius = ringRadius / scale
CreateResRing( pixRadius, img_center_x, img_center_y, rval, gval, bval )
// End