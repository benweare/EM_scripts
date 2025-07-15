// script to test cloning Live View in Digital Micrograph
// tends to run slowly, giving poor temporal resolution and duty cycle 
// collects 10 frames from Live View into a stack
object NewData = NewSignal(0)
object objListener = Alloc(ImageListener)

class ImageListener
// Listen to updates of the live stream
{
    Void DataValueChanged(object self, number e_fl, image img)
    {   
        NewData.SetSignal()
    }
}

void main_script( object NewData)
{
	number i = 0
	while ( i < 10 )
	{
		WaitOnSignal( NewData, 1, NULL )  
		NewData.resetSignal()
		result("new frame \n")
		i++
	}
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
		main_script( NewData )
	}
}

// Script starts here
Invoke( )
//end