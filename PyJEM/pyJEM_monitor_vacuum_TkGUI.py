'''
Script to monitor the Penning gauge vacuum via PyJEM.

OUTDATED: see newer version of script that isn't based on Tkinter GUI.

Currently plots Penning gauge 1, Pirani gauge 2, and Pirani gauge 4.
Tested on 2100+ TEM at nmRC.
Useful for cryoTEM vacuum monitoring.

Known issues:
- matplotlib graph resizing x-axis slightly when running continuously.
- works on nmrc OneView server, but not on EDS pc.

Based on DM Scripting Site script Emission Monitor.
BLW @ nmRC.
Work in progress.
'''

import matplotlib
import matplotlib.pyplot as plt
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import (FigureCanvasTkAgg, NavigationToolbar2Tk)
import tkinter as tk
import threading
import time
from datetime import datetime


from PyJEM import TEM3

if (TEM3.isconnect() == False ):
    TEM3.connect()

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
        
        # create a button which will invoke a sub-dialog to provide a value
        self.start_button = tk.Button(self.master, text = 'Start', padx=6, pady=3, command = self.start_monitoring_response)
        self.stop_button = tk.Button(self.master, text = 'Stop', padx=6, pady=3, command = self.end_monitoring_response)
        
        
        # Create a list of intervals with which to select the sampling time
        self.interval_label=tk.Label(self.master, text="Interval/s")
        
        self.interval_list=['1','2','5', '10', '20', '30', '60', '120', '240']
        
        self.interval_val=tk.IntVar()
        self.interval_default_val=1
        self.interval_val.set(self.interval_default_val)
        
        self.interval_selector=tk.OptionMenu(self.master, self.interval_val, *self.interval_list)
        self.interval_selector.config(width=1)
        self.interval_selector["state"]='normal'# state can be normal or disabled
        
        
        # Create a field which displays the emission value. 
        self.mylabel=tk.Label(self.master, text= "Pressure: ")
        self.EmissionVal = tk.IntVar()
        self.EmissionVal.set(0) # default value
        self.mainentry = tk.Entry(self.master,textvariable=self.EmissionVal, width=7, state="normal")
        
        # Values for plotting graph.
        self.max_time = 180 # in seconds
        self.xlim = [0, self.max_time]
        self.ylim = [0, 200]
        # y-axis values.
        self.peg0_data = [0]
        self.pig1_data = [0]
        self.pig3_data = [0]
        # x-axis values.
        self.time_data = [0]
        
        # Create a Matplotlib graph.
        self.fig, self.axs = plt.subplots( 1, figsize = (5, 5), layout='tight', dpi = 100)
        self.axs.set_ylabel( "Pressure" )
        self.axs.set_xlabel( "Live time / s" )
        self.axs.set_ylim( self.ylim )
        self.axs.set_xlim( self.xlim )
        self.axs.plot( self.time_data, self.peg0_data, label='PeG1' )
        self.axs.plot( self.time_data, self.pig1_data, label='PiG2')
        self.axs.plot( self.time_data, self.pig3_data, label='PiG4')
        plt.legend( ['PeG1','PiG2','PiG4'], loc='upper left' )
        
        # Assemble the items into the dialog
        #self.mylabel.grid(column=0, row=0)
        #self.mainentry.grid(column=1, row=0)
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
        
        # create an instance of the VACUUM3 module.
        self.vac_module=TEM3.VACUUM3()
        return
        
    def _format_graph( self, ax ):
        # Not in use currently.
        ax.set_ylabel( "Pressure" )
        ax.set_xlabel( "Live time / s" )
        ax.set_ylim( self.ylim )
        ax.set_xlim( self.xlim )
        return
    
    def _update_graph( self ):
        self.axs.clear()
        self.axs.plot( self.time_data, self.peg0_data, label='PeG1' )
        self.axs.plot( self.time_data, self.pig1_data, label='PiG2')
        self.axs.plot( self.time_data, self.pig3_data, label = 'PiG4' )
        self.axs.set_ylim( self.ylim )
        if (self.time_data[0] == 0):
            self.axs.set_xlim([0, self.max_time])
        else:
            self.axs.set_xlim([self.time_data[0], self.time_data[-1]])
        self.axs.set_ylabel( "Pressure" )
        self.axs.set_xlabel( "Live time / s" )
        plt.legend( ['PeG1','PiG2','PiG4'], loc='upper left' )
        self.canvas.draw()
        return
    
    # Python Destructor.
    def __del__(self):
        self.terminate_thread_flag=1
        return
    
    def _update_vals( self, interval ):
        '''
        Update the data used to draw the graph.
        '''
        self.peg0_data.append( self.peg0 )
        self.pig1_data.append( self.pig1 )
        self.pig3_data.append( self.pig3 )
        self.time_data.append( self.time_data[-1]+interval )
        if (len(self.time_data) > self.max_time):
            self.time_data.pop(0)
            self.peg0_data.pop(0)
            self.pig1_data.pop(0)
            self.pig3_data.pop(0)
        return
    
    def _monitor_vacuum( self ):
        '''
        Gets the vacuum values.
        '''
        self.peg0 = self.vac_module.GetPegInfo( 0 )[0]
        self.pig0 = self.vac_module.GetPigInfo( 0 )[0]
        self.pig1 = self.vac_module.GetPigInfo( 1 )[0]
        self.pig2 = self.vac_module.GetPigInfo( 2 )[0]
        self.pig3 = self.vac_module.GetPigInfo( 3 )[0]
        self.pig4 = self.vac_module.GetPigInfo( 4 )[0]
        self.pig5 = self.vac_module.GetPigInfo( 5 )[0]
        return
    
    # This furntion is run as a thread
    def monitor(self):
        print("\nMonitoring emission:\n")
        do_break=0
        
        # Source the interval from the dialog
        interval=self.interval_val.get()
        
        # Infinite sampling loop.
        # Broken out of by pressing Stop.
        while 1:
            
            self._monitor_vacuum()
            
            # Get the current time
            
            timestring=datetime.now()
            nowtime=timestring.strftime("%H:%M:%S")
            
            
            # Output the emission and time to the Console
            
            print("\rPenning 0 = "+str("%.2f" % self.peg0)+" Time = "+nowtime, end="")
            
            # Update the dialog
            self.EmissionVal.set(str("%.2f" % self.peg0))
            self.mainentry.update_idletasks()
            
            # Break the sampling interval into 1s interval and check for
            # a stop press every second
            for i in range(interval):
                if self.terminate_thread_flag==1:
                    do_break=1
                    break
                time.sleep(1)
            
            self._update_vals( interval )
            self._update_graph()
            
            if do_break==1:
                break
        
        # Reset the dialog
        
        print("\nThread ended")
        self.terminate_thread_flag=0
        self.start_button.config(state="normal")
        return
    
    def _log_data( self ):
        return
    
    def _create_log_file( self ):
        output = ''
        output += 'Time(s), Peg0, Pig0, Pig1, Pig2, Pig3, Pig4, Pig5'
        return output
    
    def _save_file():
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

# End of Main_Dialog class

# Call the main function. Use the if __name__ etc to ensure this script will not
# be run immdediately if loaded as a library
if __name__=='__main__':
    root = tk.Tk()
    app = Main_Dialog(root)
    root.mainloop()
    root.mainloop()
