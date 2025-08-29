// Generate Zernike Polynomials
// creates 2D images of Zernike polynomials, i.e. to illustrate geometric aberrations
// for polynomial equations see e.g. https://doi.org/10.1117/12.294412 

TagGroup CreateColEntry( number index, number r, number g, number b)
{ 
 TagGroup entryTg = NewTagGroup()
 entryTg.TagGroupSetTagAsLong( "Index", index )
 entryTg.TagGroupSetTagAsRGBUInt16( "RGB", r,g,b )
 return entryTg 
}
image viridis := [3,10] : {
	{68, 1, 84},
	{72, 40, 120},
	{62, 73, 137},
	{49, 104, 142},
	{38, 130, 142},
	{31, 158, 137},
	{53, 183, 121},
	{110, 206, 88},
	{181, 222, 43},
	{253, 231, 37}
} 
void apply_LUT( imagedisplay &disp, image colour_matrix )
{
	number r, g, b, interval
	number array_length = ImageGetDimensionSize(colour_matrix, 1)
	number diff = (255 - 0)/(array_length - 1)
	TagGroup colTG = NewTagList()
	for (number i = 0; i < array_length ; i++ )//less than length of array
	{
		if ( i == 0 )
		{
			interval = 0
		}
		else if ( i == array_length )
		{
			interval = 256
		}
		else
		{
			interval = 0 + ( i  )*diff//arithmetic progression, where i = i -1
		}
		r = GetPixel(colour_matrix, 0, i )
		g = GetPixel(colour_matrix, 1, i )
		b = GetPixel(colour_matrix, 2, i )
		colTG.TagGroupInsertTagAsTagGroup( Infinity(), CreateColEntry(interval, r, g, b) )
	}
	image LUT = COLUGradientColorCLUT(colTG)
	disp.ImageDisplaySetInputColorTable( LUT )
	CloseImage( LUT ) 
	return
}
image CreateImage( number xsize, number ysize, string name )
{
	//image input = RealImage("", 4, xsize, ysize)
	image input = IntegerImage("", 1, 0, xsize, ysize)
	SetName( input, name )
	input.ImageSetDimensionCalibration( 0, 250, 0.02, "1/nm", 1 )
	input.ImageSetDimensionCalibration( 1, 250, 0.02, "1/nm", 1 )
	input = 0
	return input
}
image CropImage( image input, number radius )
{
	input = (iradius/radius > 1) ? 0 : input
	return input
}
void SetDisplay( image &img, number radius, image viridis )
{
	CropImage( img, radius )
	ShowImage( img )
	ImageDisplay ImgDisp = img.ImageGetImageDisplay( 0 )
	apply_LUT( ImgDisp, viridis )
	return
}

// image size 
number xsize = 500; number ysize = 500; number radius = xsize/2

// variables
number 	a0, a1, a2, a3, a4, a5, a6, a7, a8
image piston, tiltx, tilty, astig, astig45, defocus, spherical, aberrations
image comax, comay
a0 = 0
a1 = 1; a2 = 1
a3 = 1; a4 = 1
a5 = 1
a6 = 1
a7 = 1
a8 = 1

// create blank images
piston := CreateImage(xsize, ysize, "piston" )
tiltx := CreateImage(xsize, ysize, "Tilt X" )
tilty := CreateImage(xsize, ysize, "Tilt Y" )
astig := CreateImage(xsize, ysize, "Astigmatism" )
astig45 := CreateImage(xsize, ysize , "Astigmastism 45" )
defocus := CreateImage(xsize, ysize , "Defocus" )
spherical := CreateImage(xsize, ysize , "Spherical" )
comax = CreateImage(xsize, ysize , "Coma X" )
comay = CreateImage(xsize, ysize , "Coma Y" )

// radial zernike polynomials in jacobi form
piston = a0 * 1 
tiltx = a1 * iradius*cos(itheta)
tilty = a2 * iradius*sin(itheta)
astig = (a3 * (((iradius/radius)) * sin(2 * itheta )))
astig45 = (a4 * (((iradius/radius)**2) * cos(2 * itheta )))
defocus = a5 * (2*(iradius/radius)**2 - 1)
comax = a5 *(iradius/radius)**4 *cos(4*itheta)
comay = a6 *(iradius/radius)**4 *cos(4*itheta)
spherical = a8 *( 6*(iradius/radius)**4 - 6*(iradius/radius)**2 + 1 )

// draw images
SetDisplay( piston, radius, viridis )
SetDisplay( tiltx, radius, viridis )
SetDisplay( tilty, radius, viridis )
SetDisplay( astig, radius, viridis )
SetDisplay( astig45, radius, viridis )
SetDisplay( defocus, radius, viridis )
SetDisplay( spherical, radius, viridis )
SetDisplay( comax, radius, viridis )
SetDisplay( comay, radius, viridis )