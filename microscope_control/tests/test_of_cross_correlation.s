// test of cross-correlation function
// add binning for improved speed
// based on David Mitchell script for cross-correlation for drift measurement
// 07-07-25
// functions to create custom LUTs
TagGroup CreateColEntry( number index, number r, number g, number b)
	{ 
		TagGroup entryTg = NewTagGroup()
		entryTg.TagGroupSetTagAsLong( "Index", index )
		entryTg.TagGroupSetTagAsRGBUInt16( "RGB", r,g,b )
		return entryTg 
	}
void apply_LUT( imagedisplay &disp )
{
	image colour_matrix := [3,10] : {
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

	image CLUT = COLUGradientColorCLUT(colTG)

	disp.ImageDisplaySetInputColorTable( CLUT )
	CloseImage( CLUT )
	
	return
}
// functions to show direction and magnitude of drift on an image
image vectorplot( image input, number xsize, number ysize, number xoffset, number yoffset )
{
	image vectorimg := input
	number height = 1
	documentwindow vectorwin
	number frontwinleft, frontwinbottom

	imagedisplay vectordisp=vectorimg.imagegetimagedisplay(0)
	
	component arrow
	number vectorrescaling = 1
	
	number xcentre=xsize/2
	number ycentre=ysize/2
	
	arrow = newarrowannotation(ycentre, xcentre, (ycentre - (yoffset *vectorrescaling)), xcentre - (xoffset * vectorrescaling))
	arrow.componentsetforegroundcolor(0,1,0)
	vectordisp.componentaddchildatend(arrow)
	updateimage(vectorimg)
	
	number dy=(ycentre+(yoffset*vectorrescaling))-ycentre
	number dx=xcentre+(xoffset*vectorrescaling)-xcentre

	number angle=atan2(dy, dx)
	angle=(angle*(180/pi()))+180
	
	//result( "drift (x, y, angle) = " + xoffset + ", " + yoffset + ", " + angle + "\n" )
	
	return vectorimg
}
void draw_roi( number radius, number x, number y, imagedisplay disp, number r, number g, number b, string label )
{
	ROI resRing = NewROI( )
	ROISetCircle(resRing, x, y, radius)
	disp.ImageDisplayAddROI( resRing )
	
	ROISetLabel( resRing, label )
	ROISetColor( resRing, r, g, b) //RBG in 0-1
	ROISetMoveable( resRing, 0 )
	ROISetVolatile( resRing, 0 )
}
// image filters
image sobelfilters(image sourceimg ) 
{
	// Declare and set up some variables		
	image sobel, dx, dy
	number xsize, ysize
	getsize(sourceimg,xsize,ysize)
	number scalex, scaley
	string unitstring
	getscale(sourceimg,scalex, scaley)
	getunitstring(sourceimg, unitstring)
	// Create images to hold the derivatives - then calculate them
	sobel=Exprsize(xsize,ysize,0)
	dx=Exprsize(xsize,ysize,0)
	dy=Exprsize(xsize,ysize,0)
	dx = offset(sourceimg,-1,-1) - offset(sourceimg,1,-1)  + \
	2*(offset(sourceimg,-1,0) - offset(sourceimg,1,0)) + \
	offset(sourceimg,-1,1) - offset(sourceimg,1,1)
	dy = offset(sourceimg,-1,-1) - offset(sourceimg,-1,1)  + \
	2*(offset(sourceimg,0,-1) - offset(sourceimg,0,1)) + \
	offset(sourceimg,1,-1) - offset(sourceimg,1,1)
	sobel = sqrt(dx*dx+dy*dy)
	setscale(sobel, scalex, scaley)
	setunitstring(sobel, unitstring)
	deleteimage(dx)
	deleteimage(dy)
	return sobel
}
image butterworth(image sourceimg)
{
	number imagexsize, imageysize
	getsize(sourceimg, imagexsize, imageysize)
	image butterworthimg=realimage("",4,imagexsize, imageysize)
	// Settings from the Butterworth filter
	number halfpointconst=0.4
	number bworthorder=0.5
	number zeroradius=(imagexsize/2)
	// Create the butterworth image - by default the butterworth image is a low pass
	// filter ie 1 near the centre and 0 at the periphery
	butterworthimg=1/(1+halfpointconst*(iradius/zeroradius)**(2*bworthorder))
	image product=sourceimg*butterworthimg
	return product
}
image gaussianblur(image sourceimg, number blurvalue)
{
	number imagexsize, imageysize
	getsize(sourceimg, imagexsize, imageysize)
	compleximage fftsource=realfft(sourceimg)
	compleximage gauss:=ExprSize(imagexsize, imageysize,exp(-((irow-(imageysize/2))**2+(icol-(imagexsize/2))**2)/(blurvalue**2)))			
	compleximage gaussfft=fft(gauss)
	compleximage fftproduct=fftsource*gaussfft.modulus().sqrt()	
	converttopackedcomplex(fftproduct)
	image product=packedifft(fftproduct)
	return product
}
image bin_image( number binning_amount_x, number binning_amount_y, image img )
{
	image binned = img
	number binX = binning_amount_x
	number binY = binning_amount_y
	number sizeX, sizeY
	GetSize( img, SizeX, SizeY )
	ImageResize( binned, 2, sizeX/binX, sizeY/binY )
	for ( number j = 0; j < binY; j++ )
	{
		for ( number i = 0; i < binX; i++ )
		{
			binned += Slice2( img, i, j, 0, 0, sizeX/binX, binX, 1, sizeY/binY, binY )
		}
	}
	return binned
	CloseImage(binned)
}
// cross-correlation function
void crosscorrig( image originalimg, image currentimg, number xscale, number yscale, number &xoffset, number &yoffset, number xsize, number ysize, number &xpos, number &ypos, number verbose, number filtering )
{
	// binning to speed up processing speed and increase SNR
	//originalimg = bin_image( 4, 4, originalimg )
	//currentimg = bin_image( 4, 4, currentimg )
	
	if(filtering==1) // use Sobel and associate filtering to improve the cross correlation
	{
		number blurvalue=2
		originalimg = gaussianblur(originalimg,blurvalue)
		originalimg = butterworth(originalimg)
		currentimg = gaussianblur(currentimg,blurvalue)
		currentimg = butterworth(currentimg)
	}		

	image crosscorrimg = crosscorrelate( originalimg, currentimg )
	number xpos, ypos, ccmax
	ccmax=max(crosscorrimg, xpos,ypos)//in pixels
	if ( verbose == 1 ){
	result("Max correlation at (" + xpos + ", " + ypos + "): " + ccmax + "\n" )
	}

	if ( verbose == 1 ){
		setname(crosscorrimg, "Cross Correlation")
		ShowImage( crosscorrimg )
		
		imagedisplay disp = crosscorrimg.imagegetimagedisplay( 0 )
		apply_LUT( disp )
		ImageDisplaySetImageRect( disp, 0, 0, 1, 1 )
		ImageDisplaySetIntensityScaleBarOn( disp, 1 )
		draw_roi( 10, xpos, ypos, disp, 1, 0, 0, "" )	
	}

	xoffset = xpos - xsize/2
	yoffset = ypos - ysize/2
	if ( verbose == 1 ){
	result("pixel offset (x, y) = " + xoffset + ", " + yoffset + ", distance =" + (sqrt(xoffset^2 + yoffset^2)) +"\n" )
	}

	if ( verbose != 1 ){
		CloseImage( crosscorrimg )
		}
}
// drift correction function
void drift_correction( number x_drift, number y_drift, number xscale, number yscale, number verbose )
{
	number correct_stage = 0
	number stage_x, stage_y, scalefactor, deltax, deltay
	if (correct_stage == 1){
		// absolute stage position in microns
		stage_x = EMGetStageX()
		stage_y = EMGetStageX()
		scalefactor = 1/1000
		deltax = x_drift * xscale * scalefactor
		deltay = y_drift * xscale * scalefactor
		// new absolute stage position in microns
		if ( verbose == 1){
		result("stage x, y = " + stage_x + ", " + stage_y +"\n" )
		//result("delta = " + (stage_x - ( x_drift * xscale ))+ ", " + (stage_y - ( y_drift * yscale )/1000)+"\n" )
		result("delta = " + deltax + ", " + deltay +"\n" )
		}
		EMSetStageX( stage_x - deltax )
		EMSetStageY( stage_y - deltay )
	}
	else{
		// need to calibrate image shift
		EMGetImageShift(stage_x, stage_y)
		scalefactor = 1/1000
		deltax = x_drift * xscale * scalefactor
		deltay = y_drift * xscale * scalefactor
		// new absolute stage position in microns
		if ( verbose == 1){
		//result("image x, y = " + stage_x + ", " + stage_y +"\n" )
		//result("delta = " + (stage_x - ( x_drift * xscale ))+ ", " + (stage_y - ( y_drift * yscale )/1000)+"\n" )
		result("image delta = " + deltax + ", " + deltay +"\n" )
		}
		EMSetImageShift( stage_x + deltax, stage_y + deltay )
	}
	
}
// script starts here

//global variables
number xscale, yscale, xoffset, yoffset, xpos, ypos, xsize, ysize
number true = 1; number false = 0

number verbose = false // optionally, more information. 1 or 0
number filtering = false // whether to apply filters to images, slower

number d_thresh = 100

image inpt1:= GetFrontImage()
image inpt2 := FindNextImage( inpt1 )
image image_00, image_01
if ( filtering == 1){//clones images to apply filter
	image image_00 = inpt1
	image image_01 = inpt2
}
else{
	image_00 := inpt1
	image_01 := inpt2
}
if ( verbose == 1 ){
	setname(image_00, "original")
	setname(image_01, "current")
	ShowImage( image_01 )
	ShowImage( image_00 )
}
// get image size and scale
GetScale( image_00, xscale, yscale )
xsize = ImageGetDimensionSize(image_00, 0)
ysize = ImageGetDimensionSize(image_00, 1)
// perform cross-correlation to measure drift
crosscorrig( image_00, image_01, xscale, yscale, xoffset, yoffset, xsize, ysize, xpos, ypos, verbose, filtering )
// correct drift if above a threshold value in x or y
if (( abs( xoffset ) > d_thresh ) || ( abs( yoffset ) > d_thresh ))//make to be outside of a circle of known size
{
	drift_correction( xoffset, yoffset, xscale, yscale, verbose )
}
// images to show extent of drift
if ( verbose == 1 ){
	image sumimage = image_00 - image_01
	SetScale(sumimage, xscale, yscale)
	showimage(sumimage)
	imagedisplay disp = sumimage.imagegetimagedisplay( 0 )
	draw_roi( 10, xsize/2, ysize/2, disp, 1, 0, 0, "(0, 0)" )	
	draw_roi( 10, xsize/2 - xoffset, ysize/2 - yoffset, disp, 0, 1, 0, "(" + xoffset + ", " + yoffset + ")")
	image vectorimg = vectorplot( sumimage, xsize, ysize, xoffset, yoffset )
	}
// cleanup
//CloseImage( image_00 )
//CloseImage( image_01 )
// end
//result("done")