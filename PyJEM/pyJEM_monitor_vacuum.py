'''
Script to monitor the TEM vacuum via PyJEM.

Features:
- Uses a matplotlib FuncAnimation to draw live plot of Penning gauge 1, 
    Pirani gauge 2, and Pirani gauge 4.
- Creates a log file of all Penning and Pirani gauges in .csv format.
- Tested on 2100+ TEM at nmRC.
- Useful for cryoTEM vacuum monitoring.

Known issues:
- matplotlib graph resizing x-axis slightly when running continuously.
- works on nmrc OneView server, but not on EDS pc.

BLW @ nmRC.
'''


import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style

import PyJEM
from PyJEM import TEM3

from datetime import datetime

#vac_sys=TEM3.VACUUM3()


class microscopeMonitor():
    '''
    Creates live matpltlib graph of column vacuum.
    '''
    
    def __init__( self ):
        # Connect to the microscope.
        if TEM3.isconnect() == False:
            TEM3.connect()
        print('\nConnected to microscope.')
        
        # Create an instance of the VACUUM3 module.
        self.vac_module=TEM3.VACUUM3()
        print('\nConnected to vacuum system.')

        # Refresh interval in ms.
        self.interval = 1000
        
        # Values for plotting graph.
        self.max_time = 180 # in seconds
        self.xlim = [0, self.max_time]
        self.ylim = [0, 250]
        # y-axis values.
        self.peg0_data = [ self.vac_module.GetPegInfo( 0 )[0] ]
        self.pig0_data = [ self.vac_module.GetPigInfo( 0 )[0] ]
        self.pig1_data = [ self.vac_module.GetPigInfo( 1 )[0] ]
        self.pig2_data = [ self.vac_module.GetPigInfo( 2 )[0] ]
        self.pig3_data = [ self.vac_module.GetPigInfo( 3 )[0] ]
        self.pig4_data = [ self.vac_module.GetPigInfo( 4 )[0] ]
        self.pig5_data = [ self.vac_module.GetPigInfo( 5 )[0] ]
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
        
        # Create file to log vacuum data.
        timestring=datetime.now()
        date=timestring.strftime('%Y-%m-%d_%H%M%S')
        self.fname = date + '_pressure.csv'
        output = 'Time(s), Peg0, Pig0, Pig1, Pig2, Pig3, Pig4, Pig5'
        with open( self.fname, 'x', encoding="utf-8") as f:
            f.write(output)
        print( '\nWriting data to ' + self.fname )
        return
        
    def _format_graph( self ):
        self.axs.set_ylabel( "Pressure" )
        self.axs.set_xlabel( "Live time / s" )
        self.axs.set_ylim( self.ylim )
        if (self.time_data[0] == 0):
            self.axs.set_xlim([0, self.max_time])
        else:
            self.axs.set_xlim([self.time_data[0], self.time_data[-1]])
        plt.legend( ['PeG1','PiG2','PiG4'], loc='upper left' )
        return
    
    def _animate( self, frame ):
        # Update values.
        self._update_vals( (self.interval/1000) )
        self.axs.clear()
        # Plot graph.
        self.axs.plot( self.time_data, self.peg0_data, label='PeG1' )
        self.axs.plot( self.time_data, self.pig1_data, label='PiG2')
        self.axs.plot( self.time_data, self.pig3_data, label = 'PiG4' )
        self._format_graph()
        self._log_data()
        return
    
    def _update_vals( self, interval ):
        '''
        Update the data used to draw the graph.
        '''
        self.peg0_data.append( self.vac_module.GetPegInfo( 0 )[0] )
        self.pig0_data.append( self.vac_module.GetPigInfo( 0 )[0] )
        self.pig1_data.append( self.vac_module.GetPigInfo( 1 )[0] )
        self.pig2_data.append( self.vac_module.GetPigInfo( 2 )[0] )
        self.pig3_data.append( self.vac_module.GetPigInfo( 3 )[0] )
        self.pig4_data.append( self.vac_module.GetPigInfo( 4 )[0] )
        self.pig5_data.append( self.vac_module.GetPigInfo( 5 )[0] )
        self.time_data.append( self.time_data[-1]+interval )
        if (len(self.time_data) > self.max_time):
            self.time_data.pop(0)
            self.peg0_data.pop(0)
            self.pig0_data.pop(0)
            self.pig1_data.pop(0)
            self.pig2_data.pop(0)
            self.pig3_data.pop(0)
            self.pig4_data.pop(0)
            self.pig5_data.pop(0)
        return
    
    def _log_data( self ):
        output = '\n' + str("%.1f" % self.time_data[-1])+\
        ', '+ str("%.2f" % self.peg0_data[-1])+\
        ', '+ str("%.2f" % self.pig0_data[-1])+\
        ', '+ str("%.2f" % self.pig1_data[-1])+\
        ', '+ str("%.2f" % self.pig2_data[-1])+\
        ', '+ str("%.2f" % self.pig3_data[-1])+\
        ', '+ str("%.2f" % self.pig4_data[-1])+\
        ', '+ str("%.2f" % self.pig5_data[-1])
        
        with open( self.fname, 'a', encoding='utf-8') as f:
            f.write( output )
        return

#style.use('fivethirtyeight')

vac_sys = microscopeMonitor()

ani = animation.FuncAnimation(vac_sys.fig, vac_sys._animate, cache_frame_data=False, interval=vac_sys.interval)

plt.show()
