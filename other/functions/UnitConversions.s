//nm-1 to Angstrom 
void ConvertToAngstrom( number num2convert )
{ 
number convertednum = 1/(num2convert*0.1)

result(num2convert + " nm-1 = " + convertednum + " A" + "\n")
}

number testNum = 10

ConvertToAngstrom( testNum )

//Angstroms to nm-1
number ConvertToRecNM( number num2convert )
{ 
number convertednum = 1/(num2convert*0.1)

result(num2convert + " A = " + convertednum + " nm-1" + "\n")
}

testNum = 1


ConvertToRecNM( testNum )