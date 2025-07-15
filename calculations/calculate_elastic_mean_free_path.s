/* Calculate elastic mean free path 
	BLW @ NMRC, 23-02-24
	
	Input your accelerating voltage in kV, material density, and the scattering cross section
	Cross-sections vary with element and voltage, and are available on the NIST website: http://doi.org//10.18434/T4T88K
	Mean free path equation from Williams and Carter 2nd edition
*/
// variables
// accelerating voltage
number keV = 80
//density of diamond, kg per m^-3
number density = 3.5 * 1000
//atomic weight of carbon, in kg per mol
number atomic_weight = 12 / 1000

// functions
// total atomic elastic scattering cross-section in m^2 for carbon, from NIST
number calculate_cross_section( number accelerating_voltage )
{
	number cross_sec
	
	if ( accelerating_voltage == 200 )
	{
		cross_sec = (1.787180e-2)
	}
	else if ( accelerating_voltage == 180 )
	{
		cross_sec = (1.906703e-2)
	}
	else if ( accelerating_voltage == 160 )
	{
		cross_sec = (2.056732e-2)
	}
	else if ( accelerating_voltage == 140 )
	{
		cross_sec = (2.250364e-2)
	}
	else if ( accelerating_voltage == 120 )
	{
		cross_sec = (2.509427e-2)
	}
	else if ( accelerating_voltage == 100 )
	{
		cross_sec = (2.873188e-2)
	}
	else if ( accelerating_voltage == 80 )
	{
		cross_sec = (3.420123e-2)
	}
	else if ( accelerating_voltage == 60 )
	{
		cross_sec = (4.333119e-2)
	}
	else if ( accelerating_voltage == 40 )
	{
		cross_sec = (6.159630e-2)
	}
	else if ( accelerating_voltage == 20 )
	{
		cross_sec = (1.1622230e-1)
	}
	else 
	{
		result( "voltage not calibrated" + "\n" )
		cross_sec = 0
	}
	
	return cross_sec *(2.8001852e-21)
}

number calculate_mean_free_path( number cross_section, number atomic_weight, number density )
{
		number mean_free_path = ( atomic_weight  *  (10e8)) / ( 6.02214076e23 * cross_section * density )
		return mean_free_path
}
// main script
number elastic_CS, MFP
elastic_CS = calculate_cross_section( keV )
MFP = calculate_mean_free_path( elastic_CS, atomic_weight, density )
result( "Elastic MFP @ " + keV + "kV" + " = " + MFP + " nm" + "\n" )
// end