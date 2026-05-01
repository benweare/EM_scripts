// Calculate the wavelength given the accelerating voltage, in metres.
// BLW @ nmRC, 2026-05-01
number CalculateWavelength( number HT )
{
	number c = 299792458
	number h = 6.62607015e-34
	number e = 1.602176634e-19
	number m_e = 9.1093837139e-31
	number E_k = HT*e
	number lamb = h/(2*m_e*E_k*(1+(E_k/(2*m_e*(c**2)))))**0.5
	return lamb
}

number kV = 200 * 1000
number wavelength = CalculateWavelength( kV )
result( wavelength *1e9 + " nm-1 \n" )