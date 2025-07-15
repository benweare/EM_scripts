// Bulk Image Pre-Processing
// 05-01-24
//
// Processes all files in folder
// User defines direct beam mask, smoothing kernel, and pixel mask threshold
// 1 - masks direct beam 
// 2 - smooths using defined kernel
// 3 - removes pixel noise

// Bugs:
// Currently replaces images instead of making a new copy

// Image processing functions //

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

//////////////////////////////////////////
//This block adapted from:
// ## Batch processed dm4 files to dm3
// v 1a 25 September 2023 - MWF

//Function save as dm4
void SaveProcessedImage( image img, string fname )
{
	string DirOnly = PathExtractDirectory( fname, 0 )
	string NameOnly = PathExtractBaseName(fname, 0)
	string file_name =  DirOnly + "processed_" + NameOnly + ".dm4"
	Result(file_name + "\n")
	ConvertToByte( img ) //comverts to integer 1 unsigned
	SaveImage(img, file_name ) 
}

// Function converts a string to lower-case characters
string ToLowerCase( string in )
{
 string out = ""
 for( number c = 0 ; c < len( in ) ; c++ )
 {
         string letter = mid( in , c , 1 )
         number n = asc( letter )
         if ( ( n > 64 ) && ( n < 91 ) )        letter = chr( n + 32 )
         out += letter
         }        

 return out

}
 
// Function to create a list of file entries with full path
TagGroup CreateFileList( string folder )
{
 TagGroup filesTG = GetFilesInDirectory( folder , 1 )                        // 1 = Get files, 2 = Get folders, 3 = Get both
 TagGroup fileList = NewTagList()
 for (number i = 0; i < filesTG.TagGroupCountTags() ; i++ )
 {
         TagGroup entryTG
         if ( filesTG.TagGroupGetIndexedTagAsTagGroup( i , entryTG ) )
         {
                 string fileName
                 if ( entryTG.TagGroupGetTagAsString( "Name" , fileName ) )
                 {
                         filelist.TagGroupInsertTagAsString( fileList.TagGroupCountTags() , PathConcatenate( folder , fileName ) )
                 }
         }
 }
 return fileList
}

// Function removes entries not matching in suffix
TagGroup FilterFilesList( TagGroup list, string suffix )
{
 TagGroup outList = NewTagList()
 suffix = ToLowerCase( suffix )
 for ( number i = 0 ; i < list.TagGroupCountTags() ; i++ )
 {
         string origstr
         if ( list.TagGroupGetIndexedTagAsString( i , origstr ) ) 
         {
                 string str = ToLowerCase( origstr )
                 number matches = 1
                 if ( len( str ) >= len( suffix ) )                 // Ensure that the suffix isn't longer than the whole string
                 {
                         if ( suffix == right( str , len( suffix ) ) ) // Compare suffix to end of original string
                         {
                                 outList.TagGroupInsertTagAsString( outList.TagGroupCountTags() , origstr )        // Copy if matching
                         }
                 }
         }
 }
 return outList
}
 
// Open and process all files in a given fileList
// Comment out any image processing you don't want
void BatchProcessList( TagGroup fileList , string name, number img_center_x, number img_center_y, number mask_radius, number threshold, image smoothing_kernel, number BinningX, number BinningY, number filter_size )
{
 number nEntries = fileList.TagGroupCountTags()
 if ( nEntries > 0 )
         result( "Processing file list <" + name + "> with " + nEntries + " files.\n" )
 else
         result( "File list <" + name + "> does not contain any files.\n" )
 
 for ( number i = 0 ; i < nEntries ; i++ )
 {
         string str 
         if ( fileList.TagGroupGetIndexedTagAsString( i , str ) )
         {
				 Try
				 {
					image raw_image := OpenImage( str )
					image processed_img = raw_image
					//processed_img = mask_direct_beam( mask_radius, processed_img, img_center_x, img_center_y )
					//processed_img  = smooth_image( processed_img , smoothing_kernel )
					//processed_img  = pixel_masking( threshold, processed_img  )
					image final_img = bin_image(binningX, binningY, processed_img )
					final_img = median_filtering( final_img, filter_size )
					SaveProcessedImage( final_img, str )
					//CloseImage(raw_image)
					//CloseImage(processed_img)
				 }
                 Catch
                 {
					result("something went wrong" + "\n")
					break
                 }
         }
 }
 result("completed" + "\n")
}

// Main routine. Processes all dm3/dm4 files in a directory
void BatchProcessFilesInFolder( number img_center_x, number img_center_y, number mask_radius, number threshold, image smoothing_kernel, number BinningX, number BinningY, number filter_size )
{
 string folder , outputFolder
 if ( !GetDirectoryDialog( "Select folder to batch process" , "" , folder ) ) 
         return
 
 TagGroup fileList = CreateFileList( folder ) 
 TagGroup fileListDM3 = FilterFilesList( fileList , ".dm3" )
 TagGroup fileListDM4 = FilterFilesList( fileList , ".dm4" )
 BatchProcessList( fileListDM4 , "DM4 list", img_center_x, img_center_y, mask_radius, threshold, smoothing_kernel, BinningX, BinningY, filter_size )//put functions for image processing in here
}
//////////////////////////////////////////
// Script starts here //
number img_center_x = 2650//1352 //ImageGetDimensionSize(img, 0)/2
number img_center_y = 2230//1094 //ImageGetDimensionSize(img, 1)/2
number mask_radius = 300 // pixels
number threshold = 10 // pixel intensity
number binningX = 2; number binningY = binningX //only works if binning = 1 rn?
number filter_size = 2

BatchProcessFilesInFolder( img_center_x, img_center_y, mask_radius, threshold, smoothing_kernel, binningX, binningY, filter_size )

//End