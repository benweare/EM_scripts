/*
	Function to calculate camera length for SAED.
*/

number calculate_camera_length( number distance, number lamb, number size )
{ 
	number cam_length
	distance = (1/distance)*1e-9
	size = size*1e-9
	// Camera length in metres.
	cam_length = (distance * size) / lamb
	
	return cam_length
}

number lamb

lamb = calculate_camera_length( 0.074319, 0.00251, 15 )