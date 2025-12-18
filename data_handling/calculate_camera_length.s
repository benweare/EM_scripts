

number calcualte_camera_length(, number distance, number lamb, number size )
{ 
	number cam_length_1x_bin, cam_length_2x_bin, cam_length_4x_bin
	distance = (1/distance)*1e-9
	size = size*1e-9
	// camera length in metres 
	cam_length_1x_bin = (distance * size) / lamb
	
	cam_length_2x_bin = cam_length_1x_bin / 2
	cam_length_4x_bin = cam_length_1x_bin / 4
	
	return
}

calculate_camera_length( 0.074319, 0.00251, 15 )