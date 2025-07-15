//Semi-automated tomography
// does not use In-Situ camera mode
// 27-06-25
//
// Can clone images from Live View, or use CameraAcquireInPlace() 
// Set live time to desired exposure time if cloning Live View
// currently has no drift correction so set stage to eucentric height
// metadata is recorded in a text file
// to add: more image metadata, GUI, clean up

// alpha at start in degrees
number alpha_start = -50
// alpha at end
number alpha_end = 50
// angle step size
number alpha_step = 2
// pause to acquire image in seconds
number cam_sleep = 5

string notes = "defocus -13.13 um"
string operators = "ICZ/BLW"
string rotation_axis = "?"
string program_name = "semi-auto-tomo"

string save_dir = "X:\\ICZ\\Service Work\\Internal\\Rebecca Pope\\250627 EV mouse primary cell\\tomography\\" //directory to save log file
string sample_name = "mouse_EV_tomography"
string file_ext = ".txt"

number camid = CameraGetActiveCameraID()
number exp_num = 0 // initial log file suffix
number fiddle = 1.0 // amount angles can be off by
number fileCheck = 1 
number start_angle, end_angle 

number lambda = 0.0251
number exposure = 1

string rotation_table, fileName, meta_string, saveName
number total_time, stack_size, time_1, time_2
image output_image

// Declare functions
void check_ready( number camid )
{
	if ( CameraGetInserted( camid ) != 1 )
	{
		result("camera not inserted!")
		break
	}
}
string UniqueSaveName( string save_dir, string &saveName, string fileName, string sample_name, string log_ext, number &exp_num, number fileCheck )
{
	try
	{
		while ( fileCheck == 1 )
		{
			filename = sample_name + "_" + exp_num + log_ext
			saveName = PathConcatenate( save_dir, filename )
			fileCheck = DoesFileExist( saveName )

			if ( fileCheck == 1 )
				exp_num = exp_num + 1
			else 
				break
		}
	}
	catch
	{
		result( "Something went wrong." )
	}
	return saveName
}

void WorkOutCapture( number stack_size )
{
	result("number of images: " + stack_size +"\n")
	result("capture time (s): " + stack_size*cam_sleep +"\n")
}
//metadata
string GetDate()
{
    number year, month, day, hour, minute, second, nanosecond
    DeconstructUTCDate( GetCurrentTime(), year, month, day, hour, minute, second, nanosecond )
    string date = year + "-" + format(month, "%02d") + "-" + format(day, "%02d")
    return date
}
void TagImages( string progname, number start_angle, number end_angle, number step, number frames,\
number time, number exposure, string axis, string notes, image target, string operators )
{
	number range = abs(end_angle - start_angle)
	try{
		//image target:=OpenImage(ImageName)
		TagGroup imgTags = target.ImageGetTagGroup()
		string bosstag
		bosstag = "Tomography Data:"
		imgTags.TagGroupSetTagAsString( bosstag + "Program", progname )
		imgTags.TagGroupSetTagAsNumber( bosstag + "Start angle (deg)", start_angle )
		imgTags.TagGroupSetTagAsNumber( bosstag + "End angle (deg)", end_angle )
		imgTags.TagGroupSetTagAsNumber( bosstag + "Rotation range (deg)", range )
		imgTags.TagGroupSetTagAsNumber( bosstag + "Step size (deg)", step )
		imgTags.TagGroupSetTagAsNumber( bosstag + "Frames", frames )
		imgTags.TagGroupSetTagAsNumber( bosstag + "Total time (s)", time )
		imgTags.TagGroupSetTagAsNumber( bosstag + "Exposure (s)", exposure )
		imgTags.TagGroupSetTagAsString( bosstag + "Rotation axis (deg)", axis )
		imgTags.TagGroupSetTagAsString( bosstag + "Notes", notes )
		imgTags.TagGroupSetTagAsString( bosstag + "Operators", operators )
	}
	catch{
		result( "Something went wrong. Tags not written to image." + "\n" )
		//result( ImageName + "\n" )
	}
	
}
string WriteMetaData( number camid, number time_1, number time_2, number end_angle,\
	 number start_angle, string notes, number fiddle, number cam_sleep,\
	 number lambda, number alpha_step, string rotation_table, string program_name, number &total_time, number stack_size, string rotation_axis )
{
	// event timings
	total_time = CalcHighResSecondsBetween( time_1, time_2 )
	end_angle = EMGetStageAlpha( )
	string date = GetDate()
	number no_frames = round( ( start_angle - end_angle ) / alpha_step )
	// get experiment parameters 
	number spot_size = EMGetSpotSize( )
	number total_angle = abs( end_angle - start_angle )
	// get camera and tem name
	string camera_name = CameraGetName( camid )
	string tem_name = "'JEOL 2100Plus Transmission Electron Microscope'"
	number high_tension = EMGetHighTension( ) / 1000 //accelerating voltage in kV
	image img := GetFrontImage()
	number phys_pixelsize_x, phys_pixelsize_y, scale_x, scale_y
	CameraGetPixelSize(camid, phys_pixelsize_x, phys_pixelsize_y)
	GetScale( img, scale_x, scale_y )
	
	string output = "data_"+"\n"+\
	"_audit_creation_date " + date + "\n"+\
	"_audit_creation_method " + "'Created by script'" + "\n"+\
	"_computing_data_collection " + program_name + "\n"+\
	"_diffrn_source 'LaB6'\n"+\
	"_diffrn_radiation_probe " + "electron" + "\n"+\
	"_diffrn_radiation_type electrons \n"+\
	"_diffrn_radiation_wavelength " + lambda + "\n"+\
	"_diffrn_radiation_monochromator " + "'transmission electron microscope'" + "\n"+\
	"_diffrn_radiation_device " + "'transmission electron microscope'" + "\n"+\
	"_diffrn_radiation_device_type " + tem_name + "\n"+\
	"_diffrn_detector " + "'CMOS camera'" + "\n"+\
	"_diffrn_detector_type " + camera_name + "\n"+\
	"_diffrn_measurement_method 'RED'"+ "\n"+\
	"_diffrn_source_voltage " + high_tension + "\n" +\
	"_diffrn_detector_details 'electron camera'" +"\n"+\
	"_cell_measurement_temperature ?" +"\n"+\
	"_diffrn_measurement_details" +"\n"+\
	";" +"\n"+\
	"Spot Size: " + spot_size + "\n"+\
	"Camera: " + camera_name + "\n"+\
	"Camera pixel size x/y (um): (" + phys_pixelsize_x + ", " + phys_pixelsize_y + ")\n"+\
	"Scale (nm-1 px-1): " + scale_x + ", " + scale_y + "\n"+\
	"Image size x/y (px): (" + ImageGetDimensionSize(img, 0) + ", " + ImageGetDimensionSize(img, 1) + ")\n"+\
	"Start angle (deg): " + start_angle + "\n"+\
	"End angle (deg): " + end_angle +  "\n"+\
	"Number of frames : " + stack_size + "\n"+\
	"Rotation range (deg): " + (end_angle - start_angle) + "\n"+\
	"Data collection time (s): " + total_time + "\n"+\
	"Rotation axis (deg): " + rotation_axis + "\n"+\
	"Notes:" + notes + "\n"+\
	"loop_\n"+\
	"_image_number\n"+\
	"_alpha_degrees\n"+\
	rotation_table +"\n"
	 
	// print log to console
	result( "\n ===== \n" )
	result( output )
	
	return output
}
void save_data( string ouput_string, image img, string file_name, string file_ext, string file_path )
{
	number file_num = CreateFileForWriting( file_path )
	WriteFile( file_num, ouput_string )
	CloseFile( file_num )
	result( "Wrote file: " + file_name )
	result( "Saved data to: " + file_path + "\n" )
	SaveImage( img, file_path ) //save tomography stack
}
//uses current frame of live view to acquire an image
void CaptureImage( image target, number i, number xSize,\
 number ySize, number sync, number xBin, number yBin,\
  number processing, number polarity, string &rotation_table )
{
	image img = GetFrontImage()
	Slice2( target, 0, 0, i, 0, xSize, 1, 1, ySize, 1 ) = img
	number angle = EMGetStageAlpha() + (alpha_step * polarity) 
	( "image " + i + ": " + angle  + " degrees\n"  )
	rotation_table += i + " " + angle + "\n" 
	CloseImage(img)
	sync = 1
	return
}
//set up capture container. pre-defines stack size
image SetUpContainer( number alpha_start, number alpha_end, number alpha_step,\
 string sample_name, number xBin, number yBin, number processing, number &xSize,\
  number &ySize, number &stack_size )
{
	stack_size = round( ( alpha_end - alpha_start ) / alpha_step ) + 1//plus 1 for zeroth image
	WorkOutCapture( stack_size )
	image img := CameraCreateImageForAcquire( camid, xBin, yBin, processing )
	xSize = img.ImageGetDimensionSize(0)
	ySize = img.ImageGetDimensionSize(1)
	ImageResize( img, 3, xSize, ySize, stack_size )
	SetName( img, sample_name )
	return img
	//image current_slice
}
void data_collection_variables( number &exposure, number &polarity, number &xBin,\
 number &yBin, number &xSize, number &ySize,number &processing, number &areaT,\
  number &areaL, number &areaB, number &areaR, string &rotation_table, image &target, number &stack_size )
{
	//rotation_table = "image alpha(deg)\n"//custom header
	CameraGetDefaultParameters(camid, exposure, xBin, yBin, processing, areaT, areaL, areaB, areaR)
	target = SetUpContainer( alpha_start, alpha_end, alpha_step, sample_name, xBin, yBin, processing, xSize, ySize, stack_size )
	
	return
}
// Data collection
void ContinousTilt( number fiddle, number alpha_start, number alpha_end,\
 number &end_angle, number &start_angle, number &time_1, number &time_2,\
  number cam_sleep, number alpha_step, string &rotation_table, image &target, number &stack_size )
{
	// declare variables 
	number slice_num = 0//counting from zero
	number exposure, polarity
	number xBin, yBin, xSize, ySize
	number processing
	number areaT, areaL, areaB, areaR
	number current_alpha
	number sync = 0
	number i = 0
	
	if ( alpha_start > 0 )
		polarity = -1
	else
		polarity = 1
	
	data_collection_variables( exposure, polarity, xBin, yBin,\
	 xSize, ySize, processing, areaT, areaL, areaB, areaR, rotation_table,\
	 target, stack_size )
	
	// Data collection
	EMSetStageAlpha( alpha_start )//tilt to angle alpha_start

	while ( abs( EMGetStageAlpha( )- alpha_start ) >= fiddle )
	{
		if ( ShiftDown( ) ) exit( 0 )
	}

	EMSetBeamBlanked(0)//unblank beam
	sleep(cam_sleep)//sleeps to settle stage tilt
	
	start_angle = EMGetStageAlpha() // tilt start angle
	result( "Capture begin" + "\n" )

	time_1 = GetHighResTickCount( )//measures delay in start of tilt
	
	if ( i == 0 )
	{
		CaptureImage(target, i, xSize, ySize, sync, xBin, yBin, processing, polarity, rotation_table )
		i = i + 1
	}

	while ( abs( EMGetStageAlpha( )- alpha_start ) <= abs( ( alpha_start - alpha_end  ) + fiddle*polarity ) )//these loops will prevent other commands firing until they done
	{
		if ( ShiftDown( ) ) exit( 0 ) //exit loop if shift is held, as backup to kill script
		EMSetStageAlpha( EMGetStageAlpha() + (alpha_step * polarity))
		sleep( cam_sleep )
		
		CaptureImage(target, i, xSize, ySize, sync, xBin, yBin, processing, polarity, rotation_table )
		
		if (sync = 1 )
		{
			//result("captured image\n")
			//EMSetBeamBlanked(1)//blank beam
		}
		current_alpha = EMGetStageAlpha()
		sync = 0
		i = i + 1
	}
	time_2 = GetHighResTickCount( )

	result( "Capture cease" + "\n" )

	EMSetBeamBlanked( 1 )//blank beam
	ShowImage( target )

	return
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
		//check_ready( camid )
		UniqueSaveName( save_dir, saveName, fileName, sample_name, file_ext, exp_num, fileCheck )
		ContinousTilt( fiddle, alpha_start, alpha_end, end_angle, start_angle, time_1,\
		 time_2, cam_sleep, alpha_step, rotation_table, output_image, stack_size )
		meta_string = WriteMetaData( camid, time_1, time_2, end_angle, start_angle,\
		 notes, fiddle, cam_sleep, lambda, alpha_step, rotation_table,\
		  program_name, total_time, stack_size, rotation_axis )
		TagImages( program_name, start_angle, end_angle, alpha_step, stack_size,\
		total_time, exposure, rotation_axis, notes, output_image, operators )
		save_data( meta_string, output_image, fileName, file_ext, saveName )
		//EMSetStageAlpha(0)
	}
}

// Script starts here
Invoke( )
//end