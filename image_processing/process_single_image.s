// Single Image Pre-Processing
// 05-01-24
// BLW @NMRC
//
// ED image processing to improve reflection identification
// Processes a single image
// User defines direct beam mask, smoothing kernel, and pixel mask threshold
// 1 - masks direct beam 
// 2 - smooths using defined kernel
// 3 - removes pixel noise
image smooth_image( image img, image kernel )
{
	image smoothed = convolution(img, kernel)
	return smoothed
	CloseImage( smoothed )
	CloseImage( kernel )
}

// Mask direct beam
image mask_direct_beam( number radius, image img, number cent_x, number cent_y )
{
	image beam_mask, masked
 
	beam_mask = img * 0 // create all zero-valued mask of same size as image
	beam_mask = ( ( icol - cent_x )**2 + ( irow - cent_y )**2 < radius**2 ) ? 0 : 1                
	masked := beam_mask ? img : 0
	CloseImage( beam_mask )
	return masked
	CloseImage( masked )
}

// Mask direct beam artefact
image mask_artefact( number length, number width, image img, number cent_x, number cent_y )
{
	image beam_mask, masked
 
	beam_mask = img * 0 // create all zero-valued mask of same size as image
	beam_mask = ( ( icol - cent_x )**2 + ( irow - cent_y )**2 < radius**2 ) ? 0 : 1                
	masked := beam_mask ? img : 0
	CloseImage( beam_mask )
	return masked
	CloseImage( masked )
}

// Single pixel mask
image pixel_masking( number pix_threshold, image img )
{
	image pixel_mask, masked
	pixel_mask = img * 0
	pixel_mask = ( img > pix_threshold ) ? 1 : 0
	masked := pixel_mask ? img : 0
	return masked
	CloseImage( masked )
}

// Kernel definition //
//User-defined kernel. A convolution matrix. 
image smoothing_kernel := [3,3] : {
	{1,1,1},
	{1,2,1},
	{1,1,1}
}

// Function Median Filter
image median_filtering( image img, number sizenumber )
{
	number shapenumber = 3 // vertical, horizontal, cross, square
	image medianimage:= medianfilter( img, shapenumber, sizenumber )
	return medianimage
	CloseImage( medianimage )
}
// Function binning
// bins image by arbitary amount
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

image renameImage( image img, string str )
{
	SetName( img, str )
	//ConvertToByte( img )//crashed the binned img
	ShowImage( img )
}

// Script starts here
number img_center_x = 707//1352 //ImageGetDimensionSize(img, 0)/2
number img_center_y = 498//1094 //ImageGetDimensionSize(img, 1)/2
number mask_radius = 30 // pixels
number threshold = 10 // pixel intensity
number binningX = 2; number binningY = binningX //only works if binning = 1 rn?
number filter_size = 2

image raw_image := GetFrontImage()
number scaleX, scaleY
GetScale( raw_image, scaleX, scaleY)

Try
{
	image processed_img := ImageClone( raw_image )
	renameImage(processed_img, "initial")
	//CloseImage(raw_image)
	
	image masked_img := mask_direct_beam( mask_radius, processed_img, img_center_x, img_center_y )
	renameImage(masked_img, "masked")
	
	//processed_img  = smooth_image( processed_img , smoothing_kernel )
	//processed_img  = pixel_masking( threshold, processed_img  )
	
	image binned_img := bin_image(binningX, binningY, masked_img )
	SetScale( binned_img, scaleX*binningX, scaleY*binningY )
	renameImage(binned_img, "binned")
	
	image filtered_img := median_filtering( binned_img, filter_size )
	renameImage(filtered_img, "filtered")
	ConvertToByte( filtered_img )
}
Catch
	{
	result("something went wrong" + "\n")
	break
	}
// End
//SetName( )
//CloseImage( )
//ShowImage( )