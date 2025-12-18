// Automatic Resolution Rings 
// 13-12-23
// B L Weare, @NMRC
// Draws a standard set of resolution rings on the front image
// Can tweak how many rings & diameter by editing the matrix

//Angstroms to nm-1

class res_rings
{
	// Using image object as a matrix
	image resolution_rings
	number array_length
	image img
	number img_center_x
	number img_center_y
	number ringRadius
	number scale
	number rawRadius
	number pixRadius
	number rval, gval, bval
	
	// class methods
	number ConvertToRecNM( object self, number num2convert )
	{ 
		number convertednum = 1/(num2convert*0.1)
		return convertednum
	}

	//Create ROI
	void CreateResRing( object self, number radlabel, number radius, number x, number y, number r, number g, number b )
	{
		ROI resRing = NewROI( )
		ROISetCircle(resRing, x, y, radius)
		image img := GetFrontImage()
		ImageDisplay imgDisplay = img.ImageGetImageDisplay(0)
		imgDisplay.ImageDisplayAddROI( resRing )
		
		string label = radlabel + " A"
		ROISetColor( resRing, r, g, b) //RBG in 0-1
		if (radlabel != 100)
			ROISetLabel( resRing, label )
		ROISetMoveable( resRing, 0 )
		ROISetVolatile( resRing, 0 )
	}

	//Grab scale from image
	number ScaleInfo( object self, image img )
	{
		number img_scale = ImageGetDimensionScale(img, 0)
		string scale_units = ImageGetDimensionUnitString(img, 0)
		return img_scale
	}
	
	object init( object self, number r, number g, number b )
	{
		img := GetFrontImage()
		img_center_x = ImageGetDimensionSize(img, 0)/2
		img_center_y = ImageGetDimensionSize(img, 1)/2
		resolution_rings := [1,6] : {{100},{4},{2},{1.4},{1},{0.8}}
		array_length = ImageGetDimensionSize(resolution_rings, 1)//y dimentsion of array
		rval = r
		gval = g
		bval = b
		
		return self
	}
	
	void AddRings( object self )
	{
		for (number i = 0; i < array_length ; i++ )//less than length of array
		{
			try
			{
				ringRadius = GetPixel(resolution_rings, 0, i )//element i of array (counts from 0)
				scale = self.ScaleInfo( img )
				rawRadius = self.ConvertToRecNM( ringRadius )
				pixRadius = rawRadius / scale
				self.CreateResRing( ringRadius, pixRadius, img_center_x, img_center_y, rval, gval, bval )
			}
			catch
			{
				result("something went wrong" + "\n")
			}
		}
		CloseImage(resolution_rings)
	}
	
	res_rings( object self )
	{
	}
	~res_rings( object self )
	{
	}
}

// Script starts here

// User defined centre of pattern
//number img_center_x = 2161
//number img_center_y = 2153

// This block gives geometric centre of image; for Fourier transforms.

//alloc( res_rings.init(1, 0, 0) )

object rings = alloc( res_rings ).init( 1, 0, 0 )

rings.AddRings()

// End