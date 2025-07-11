// Chromatic aberration measurement
// see 10.1073/pnas.2312905120
// manually set whether add or substract HT at the moment

// values in kV
number startHT = 200
number endHT = 199.99

number voltage_step = 0.01

string sample_name = "Voltage focus series from " + startHT + " to " + endHT

//number stack_size = round( ( startHT - endHT ) / voltage_step ) + 1
//result( "size" + stack_size +"\n") 

string metadata = "metadata: \n"

if ( startHT > endHT )
{
	voltage_step = -voltage_step
}
else if ( startHT < endHT )
{
	continue
}
else
{
	result( "something went wrong" +"\n" )
}

// define functions
void CaptureImage( image target, number i, string &metadata, number xSize, number ySize, number camid )
{
	image current_slice := Slice2( target, 0, 0, i, 0, xSize, 1, 1, ySize, 1 )
	//Slice2( current_slice, 0, 0, i, 0, xSize, 1, 1, ySize, 1 )
	CameraAcquireInPlace( camid, current_slice )//something going wrong here, probably with the slice number
	metadata += ( "image " + i + ": " + EMGetHighTension()/1000  + " kV\n"  )
	result ("capturing \n")
	CloseImage(current_slice)
	return
}

//set up capture container. pre-defines stack size
image SetUpContainer( number HTStart, number HTEnd, number HTStep,\
number xBin, number yBin, number processing, number &xSize,\
  number &ySize, number &stack_size, string sample_name, number camid )
{
	stack_size = abs (round( ( HTStart - HTEnd ) / HTStep ) + 1 )//plus 1 for zeroth image
	image img := CameraCreateImageForAcquire( camid, xBin, yBin, processing )
	xSize = img.ImageGetDimensionSize(0)
	ySize = img.ImageGetDimensionSize(1)
	ImageResize( img, 3, xSize, ySize, stack_size )
	SetName( img, sample_name )
	return img
}
void DataCollectionVariables( number &exposure, number &xBin,\
 number &yBin, number &xSize, number &ySize,number &processing, number &areaT,\
  number &areaL, number &areaB, number &areaR, number &stack_size, number camid )
{
	CameraGetDefaultParameters(camid, exposure, xBin, yBin, processing, areaT, areaL, areaB, areaR)
	return
}
void SetHighTension( number step_size )
{
	number currentHT = EMGetHighTension()/1000
	number targetHT 
	/*
	if ( polarity == 1 )
	{
		targetHT = currentHT + step_size
	}
	if ( polarity == -1 )
	{
		targetHT = currentHT - step_size
	}
	*/
	targetHT = currentHT + step_size
	result( targetHT +"\n" )
	if ( ( targetHT > 200) || ( targetHT < 1 ) )
	{
		result( " target HT out of allowed range" +"\n" )
		result( " ensure HT is in kV, not V" +"\n" )
		break
	}
	Try
	{
		//EMSetBeamEnergy( targetHT * 1000 )
		result( "HT = " + targetHT +"kV \n" )
		sleep( 0.5 )
	}
	Catch
	{
		result( "could not set HT" +"\n" )
	}
}
void CollectData( number step_size, number startHT, number endHT, string sample_name, string metadata )
{
	number targetHT
	
	number slice_num = 0//counting from zero
	number exposure
	number xBin, yBin, xSize, ySize
	number processing
	number areaT, areaL, areaB, areaR
	number i = 0
	number stack_size
	
	image outputimg
	
	number camid = CameraGetActiveCameraID()
	
	DataCollectionVariables( exposure, xBin, yBin, xSize, ySize, processing, areaT, areaL, areaB, areaR, stack_size, camid )
	outputimg = SetUpContainer( startHT, endHT, step_size, xBin, yBin, processing, xSize, ySize, stack_size, sample_name, camid )
	
	
	if ( i == 0 )
	{
			//CaptureImage( outputimg, i, metadata, xSize, ySize, camid )
			i = i + 1
			sleep( 0.5 )
	}
	while ( i < stack_size )
	{
		SetHighTension( step_size )
		sleep( 2 )
		//CaptureImage( outputimg, i, metadata, xSize, ySize, camid  )
		sleep( 0.5 )
		i = i + 1 
	}
	
	result( metadata )
	
	ShowImage( outputimg )
}

// Threading
void Invoke( )
{
	alloc( data_collection_thread ).StartThread( )
}
// declare threads
Class data_collection_thread : thread //controls data collection
{
	data_collection_thread( object self )//constructor
	{
		result( self.ScriptObjectGetID() + " collector created.\n" )
	}
	~data_collection_thread( object self )//destructor
	{
		result( self.ScriptObjectGetID() + " collector destroyed.\n" )
	}
	void RunThread( object self )
	{
		CollectData( voltage_step, startHT, endHT, sample_name, metadata )
	}
}

// Script starts here
Invoke( )
//end