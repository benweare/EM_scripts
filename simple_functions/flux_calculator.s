/*
	A function to calculate electron flux (aka dose-rate)
*/
number calculate_flux( number counts, number gain, number pixel_size )
{
	// Counts are in counts per second for flux (dose-rate),
	// or total counts for fluence (dose).
	number flux = counts/(gain*pixel_size^2)
	return flux
}

number pixel_size = 0.0011331*1000
number counts = 7569.13
number gain = 36.3

number flux = calculate_flux( counts, gain, pixel_size )
result( flux )