'''
Script to monitor the Penning gauge vacuum via PyJEM.

Bbased on DM Scripting Site script Emission Monitor.
BLW @ nmRC, 07-05-2026
Work in progress.
'''

import matplotlib
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import (FigureCanvasTkAgg, NavigationToolbar2Tk)
import tkinter as tk
import threading
import time
from datetime import datetime

from PyJEM import TEM3

class Main_Dialog:
    '''
    Dialogue class.
    '''
    # Python constructor.
    def __init__(self, master):
        self.master = master
        self.frame = tk.Frame(self.master)
        self.master.title("Vacuum Monitor")
        self.master.configure(bg='#FFFFFF')
        
        # Holds vacuum values.
        self.peg0 = 0
        self.pig0 = 0
        self.pig1 = 0
        self.pig2 = 0
        self.pig3 = 0
        self.pig4 = 0
        self.pig5 = 0
        
        # Values for plotting graph.
        self.xlim = [0, 30]
        self.ylim = [0, 200]
        self.x_data = [0]
        self.y_data = [0]

        # Log file.
        self.filename = 'unique_name.txt'
        self.file = open( self.filename, 'x' )
        self.file.write( 'Time, Elapsed(s), Peg0, Pig0, Pig1, Pig2, Pig3, Pig4, Pig5' )
        
        # create a button which will invoke a sub-dialog to provide a value
        self.start_button = tk.Button(self.master,
                                        text = 'Start',
                                        padx=6,
                                        pady=3,
                                        command = self.start_monitoring_response)
        self.stop_button = tk.Button(self.master,
                                        text = 'Stop',
                                        padx=6,
                                        pady=3,
                                        command = self.end_monitoring_response)
        
        # Create a list of intervals with which to select the sampling time
        self.interval_label=tk.Label(self.master, text="Interval/s")
        self.interval_list=['1','2','5', '10', '20', '30', '60', '120', '240']
        self.interval_val=tk.IntVar()
        self.interval_default_val=1
        self.interval_val.set(self.interval_default_val)
        self.interval_selector=tk.OptionMenu(self.master,
                                                self.interval_val,
                                                *self.interval_list)
        self.interval_selector.config(width=1)
        self.interval_selector["state"]='normal'# state can be normal or disabled
        
        # Create a field which displays the emission value. 
        self.mylabel=tk.Label(self.master, text= "Pressure: ")
        self.EmissionVal = tk.IntVar()
        self.EmissionVal.set(0) # default value
        self.mainentry = tk.Entry(self.master,
                                    textvariable=self.EmissionVal,
                                    width=7,
                                    state="normal")
        
        # Create a Matplotlib grpah.
        self.fig = matplotlib.figure.Figure(figsize = (3, 3), layout='tight', dpi = 100)
        self.plot1 = self.fig.add_subplot(111)
        self.plot1.set_ylabel( "Pressure" )
        self.plot1.set_xlabel( "Live time / s" )
        self.plot1.set_ylim( self.ylim )
        self.plot1.set_xlim( self.xlim )
        self.plot1.plot( self.x_data, self.y_data )
        
        # Assemble the items into the dialog
        self.mylabel.grid(column=0, row=0)
        self.mainentry.grid(column=1, row=0)
        self.interval_label.grid(column=0, row=1)
        self.interval_selector.grid(column=1, row=1, pady=5)
        self.start_button.grid(column=0, row=2, pady=5)
        self.stop_button.grid(column=1, row=2)
        self.master.config(border=10)
        self.canvas = FigureCanvasTkAgg(self.fig,master = self.master)
        self.canvas.draw()
        self.canvas.get_tk_widget().grid( column=0, row=3 )
        
        # A flag for ending the thread
        self.terminate_thread_flag=0
        
        # Create an instance of the VACUUM3 module.
        self.vaccuum=TEM3.VACUUM3()
        return

    
    # Python destructor.
    def __del__(self):
        self.terminate_thread_flag = 1
        return
    
    def _update_vals( self, interval, vac ):
        '''
        Update the data used to draw the graph.
        '''
        self.y_data.append( vac )
        self.x_data.append( self.x_data[-1]+interval )
        if (len(self.x_data) > 30):
            self.x_data.pop(0)
            self.y_data.pop(0)
        return

    def _update_graph( self ):
        '''
        Update the graph.
        '''
        self.plot1.clear()
        self.plot1.plot( self.x_data, self.y_data )
        self.plot1.set_ylim( self.ylim )
        if ( self.x_data[0] == 0 ):
            self.plot1.set_xlim( self.xlim )
        else:
            self.plot1.set_xlim([self.x_data[0], self.x_data[-1]])
        self.plot1.set_ylabel( "Pressure" )
        self.plot1.set_xlabel( "Live time / s" )
        self.canvas.draw()
        return
    

    def _monitor_vacuum( self ):
        '''
        Gets the vacuum values.
        '''
        self.peg0 = self.vaccuum.GetPegInfo( 0 )[0]
        self.pig0 = self.vaccuum.GetPigInfo( 0 )[0]
        self.pig1 = self.vaccuum.GetPigInfo( 1 )[0]
        self.pig2 = self.vaccuum.GetPigInfo( 2 )[0]
        self.pig3 = self.vaccuum.GetPigInfo( 3 )[0]
        self.pig4 = self.vaccuum.GetPigInfo( 4 )[0]
        self.pig5 = self.vaccuum.GetPigInfo( 5 )[0]
        return
    

    def monitor(self):
        '''
        Thread to monitor vacuum system.
        '''
        print("\nMonitoring emission:\n")
        do_break=0
        
        # Source the interval from the dialog
        interval=self.interval_val.get()
        
        # Infinite sampling loop. Break by press Stop.
        while 1:
            self._monitor_vacuum()
            
            # Get the current time.
            timestring=datetime.now()
            nowtime=timestring.strftime("%H:%M:%S")
            
            
            # Output to console.
            print("\rPenning 0 = "+str("%.2f" % self.peg0)+" Time = "+nowtime, end="")
            
            # Update the dialog
            self.EmissionVal.set(str("%.2f" % self.peg0))
            self.mainentry.update_idletasks()
            
            # Break the sampling interval into 1s interval and check for
            # a stop press every second.
            for i in range(interval):
                if self.terminate_thread_flag==1:
                    do_break=1
                    break
                time.sleep(1)
            
            self._update_vals( interval, self.peg0 )
            self._update_graph()
            self._log_data( nowtime )
            
            if do_break==1:
                break
        
        # Reset the dialog.
        print("\nThread ended")
        self.terminate_thread_flag=0
        self.start_button.config(state="normal")
        return
    

    # Write data to file in .csv format.
    def _log_data( self, nowtime ):
        output = nowtime,
                self.x_data[-1], ', ',
                str('%.2f' % self.peg0), ', ',\
                str('%.2f' % self.pig0), ', ',\
                str('%.2f' % self.pig1), ', ',\
                str('%.2f' % self.pig2), ', ',\
                str('%.2f' % self.pig3), ', ',\
                str('%.2f' % self.pig4), ', ',\
                str('%.2f' % self.pig5), '\n'
        with open(self.filename, "a") as f:
            f.write( output )
        return
    

    def start_monitoring_response(self):
        '''
        Responds when the Start button is pressed
        '''
        self.start_button.config(state="disabled")
        self.terminate_thread_flag=0
        print("\nStart pressed")
    
        self.thread_id=threading.get_ident()
        print("Thread id = "+str(self.thread_id))
        threading.Timer(0, self.monitor).start()
        return
    

    def end_monitoring_response(self):
        '''
        Responds when the Press Me button is pressed
        '''
        print("Stop pressed")
        self.terminate_thread_flag=1
        self.start_button.config(state="normal")
        return


### Script starts here ###

# Connect to microscope.
if ( TEM3.isconnect() == False )
    TEM.connect()


# Call the main function. Use the if __name__ etc. to ensure this
# script will not be run immdediately if loaded as a library
if __name__=='__main__':
    root = tk.Tk()
    app = Main_Dialog(root)
    root.mainloop()
    root.mainloop()