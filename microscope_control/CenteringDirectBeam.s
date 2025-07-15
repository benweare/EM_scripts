// CenteringDirectBeam
// 01-02-24
// B L Weare, @NMRC
// Imaging mode: centres the beam with CL shift
// Diffraction mode: centres the direct beam with PL shift
// Must calibrate at each mag you want to use, and calibrate each time the underlying alignment is changed 
// Calibrated range(s): 
// NOTE: untested

void BeamCoordinates( number &Shift_X, number &Shift_y )
{
	try
	{
	//imaging mode
		number Mag = EMGetMagnification()
			if Mag = 10000
				{
					//Shift_X = 100; Shift_Y = 100
					result( "Mag not calibrated!") 
					AbortScript = 1
				}
			else if Mag = 20000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 25000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 30000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 40000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 50000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 60000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 80000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 100000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else if Mag = 120000
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else
			{
				result( "Mag not calibrated!" )
			}
		return
	}
	catch
	{
		result( "Something went wrong.") 
		AbortScript = 1
	}
}

void BeamDiffCoordinates( number &PL_X, number &PL_Y )
{
	try
	{
	//diffraction mode
		number Mag = EMCanGetCameraLength( )
			if Mag = 200
				{
					//PL_X = 100; PL_Y = 100
					result( "Mag not calibrated!") 
					AbortScript = 1
				}
			else if Mag = 250
			{
				result( "Mag not calibrated!") 
				AbortScript = 1
			}
			else
			{
				result( "Mag not calibrated!" )
			}
		return
	}
	catch
	{
		result( "Something went wrong.") 
		AbortScript = 1
	}
}

void MoveDirectBeam( number PL_x, number PL_y, number Shift_X, number Shift_Y )
{
	EMSetProjectorShift(PL_x,PL_y)
	EMSetBeamShift(Shift_x,Shift_y)
}

// Script starts here

number Shift_X, Shift_Y, PL_X, PL_Y
EMGetProjectorShift(PL_x, PL_y)
EMGetBeamShift(PL_x, PL_y)
number AbortScript = 0


if (EMCanGetCameraLength( ) == 1)
{
	void BeamDiffCoordinates( PL_X, PL_y )
}
else
{
	void BeamCoordinates( Shift_X, Shift_y )
}
	
if AbortScript = 0
{
	MoveDirectBeam( PL_X, PL_Y, Shift_X, Shift_Y )
}
else
{
	result( "Something went wrong." )
}
// End