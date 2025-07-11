// AutoBlank for Fluence Experiements 
// Made by B Weare @ nmRC
// Please credit the author if you found this script useful
// 10-05-24

// Notes:
// Tested up to 5 mins successfully (300 s)
// Printing to output can be supressed by commenting line 52
// Rounds to nearest second
// Pressing reset will also stop the run

// User Variables
number countdown_time, rounded_time //in seconds
number mean_flux = 0 //change this to flux in e- nm-2

// script starts below
number sleepnum = 1 //in seconds
number true = 1
number false = 0

class myThread:Thread
{
  number linkedDLG_ID
  number externalBreak

  myThread( object self )  
  {
   // result( self.ScriptObjectGetID() + " created.\n" )
  }

  ~myThread( object self )
  {
   // result( self.ScriptObjectGetID() + " destroyed.\n" )
  }

  void SetLinkedDialogID( object self, number ID ) { linkedDLG_ID = ID; }

  void RunThread( object self )
  {

		// Do not change below
		number flux_start, flux_end
		
		rounded_time = round( countdown_time )
		

		result("Couting down for " + rounded_time + " seconds." + "\n")

		EMSetBeamBlanked(0)//unblank beam
		flux_start = GetHighResTickCount()
		
		number time_left

		while( CalcHighResSecondsBetween(flux_start, GetHighResTickCount()) < rounded_time)
		{
			if ( ShiftDown() ) exit(0)
			
			sleep(sleepnum) //sleep in seconds
			time_left = rounded_time - CalcHighResSecondsBetween(flux_start, GetHighResTickCount())
			result("Time left:" + time_left + "\n")	
			
		}

		EMSetBeamBlanked(1)//blank beam
		flux_end = GetHighResTickCount()

		number total_time = CalcHighResSecondsBetween(flux_start, flux_end)
		number approx_fluence = mean_flux * total_time

		result("Time elapsed / s :" + total_time + "\n")
		result("Approx. fluence / e- nm-2 s-1: " + approx_fluence + "\n")
		
		//Need trigger to revert button states  
  }
}

class myDialog:UIframe
{
  object callThread

  myDialog( object self )
  {
   // result( self.ScriptObjectGetID() + " created.\n" )
  }
  ~myDialog( object self )
  {
   // result( self.ScriptObjectGetID() + " destroyed.\n")
  }

//functions for UI interactive elements
 void StartPressed( object self ) // needs to not launch a second instance if it's running; start button
  {
	self.Setelementisenabled("first", false);// these commands set the button as enabled or not enabled
	self.Setelementisenabled("second", true);// "second" in this command is the identifier of the button 'secondbutton' 
	countdown_time
	{
		self.DLGGetValue( "inputTime", countdown_time )
	}
	callThread.StartThread( )
  } 
    void StopPressed( object self )//stop button
  {
    rounded_time = 0
    self.Setelementisenabled("first", true);// these commands set the button as enabled or not enabled
	self.Setelementisenabled("second", false);// "second" in this command is the identifier of the button 'secondbutton'
	  
  } 

  TagGroup CreateDLG( object self )
  {
	number label_width = 10
    number entry_width = 10
    number button_width = 50
  
    TagGroup tgItems, tg, button_1, button_2, input, label
    tg = DLGCreateDialog("Dialog",tgItems)
    button_1 = DLGCreatePushButton( "Start", "StartPressed" ).DLGWidth(button_width)//button to start countdown
    dlgenabled(button_1,1) // sets the button as enabled when the dialog is first created
	dlgidentifier(button_1, "first") // identifiers are strings which identify an element, such as a button
	
    button_2 = DLGCreatePushButton( "Reset", "StopPressed" ).DLGWidth(button_width)//button to end countdown
    dlgenabled(button_2,0) // sets the button as enabled when the dialog is first created
	dlgidentifier(button_2, "second") // identifiers are strings which identify an element, such as a button
    
	label = DLGCreateLabel( "Time (s)" ).DLGWidth(label_width)//field to enter time
	input = DLGCreateStringField("").DLGWidth(entry_width)
	dlgidentifier(input, "inputTime")
    tgItems.DLGAddElement( DLGGroupItems( label, input, button_1, button_2 ).DLGTableLayout( 2 , 2 , 0 ) ).DLGAnchor( "East" )
    return tg
  }

  object Init(object self, number callThreadID )
  {
    // Assign thread-object via weak-reference
    callThread = GetScriptObjectFromID( callThreadID )      
    if ( !callThread.ScriptObjectIsvalid() )
      Throw( "Invalid thread object passed in! Object of given ID not found." )

    // Pass weak-reference to thread object
    callThread.SetLinkedDialogID( self.ScriptObjectGetID() )  
    return self.super.init( self.CreateDLG() )
  }

}

void StartScript()
 {
   object threadObject = alloc( myThread )
   object dlgObject = alloc( myDialog ).Init( threadObject.ScriptObjectGetID() )
   dlgObject.display( "AutoBlank" ) //title of UI
 }
StartScript()