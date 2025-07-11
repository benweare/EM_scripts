number test = (200-0.01)*1000

Try{
	EMSetBeamEnergy( test )
}
Catch
{
	result("something went wrong")
}

sleep (1)
result( EMGetHighTension() + "\n" )