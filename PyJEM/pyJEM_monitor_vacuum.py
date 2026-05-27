'''
Script to monitor the TEM vacuum and lenses via PyJEM.

Features:
- Can monitor lenses or vacuum or both via bools.
- Uses a matplotlib FuncAnimation to draw live plot of Penning gauge 1, 
    Pirani gauge 2, and Pirani gauge 4.
- Creates a log file of all Penning and Pirani gauges in .csv format.
- Tested on 2100+ TEM at nmRC.
- Useful for cryoTEM vacuum monitoring.
- Useful for monitoring bakeout.

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
    
    def __init__( self, vacuum, lenses ):
        # Bools to pick which values are tracked.
        self.monitor_vacuum = vacuum
        self.monitor_lenses = lenses
        
        # Connect to the microscope.
        if TEM3.isconnect() == False:
            TEM3.connect()
        print('\nConnected to microscope.')
        
        # Refresh interval in ms.
        self.interval = 1000
        
        # Values for plotting graph.
        self.max_time = 180 # in seconds
        self.xlim = [0, self.max_time]
        self.ylim = [0, 250]
        
        # y-axis values.
        if self.monitor_vacuum == True:
            self.vac_module = TEM3.VACUUM3()
            self._get_vac_gauges()
            print('\nConnected to lenses.')
        if self.monitor_lenses == True:
            self.lens = TEM3.Lens3()
            self._get_lenses_dec()
            print('\nConnected to vacuum system.')
        
        # x-axis values.
        self.time_data = [0]
        
        # Create a Matplotlib graph.
        if self.monitor_vacuum == True and self.monitor_lenses == True:
            self.fig, self.axs = plt.subplots( 2, figsize = (5, 5), layout='tight', dpi = 100)
            self._vac_axis( self.axs[0], self.xlim )
            self._vac_axis( self.axs[1], self.xlim )
        if self.monitor_vacuum == False and self.monitor_lenses == True:
            self.fig, self.axs = plt.subplots( 1, figsize = (5, 5), layout='tight', dpi = 100)
            self._lens_axis( self.axs, self.xlim )
            plt.legend( ['CL1', 'CL2', 'CL3', 'CM', 'OLc', 'OLf', 'OM1', 'OM2', 'IL1', 'IL2', 'IL3', 'PL1'], loc='upper left' )
        if self.monitor_vacuum == True and self.monitor_lenses == False:
            self.fig, self.axs = plt.subplots( 1, figsize = (5, 5), layout='tight', dpi = 100)
            self._vac_axis( self.axs, self.xlim )
            plt.legend( ['PeG1','PiG2','PiG4'], loc='upper left' )
        
        # Create file to log data.
        timestring=datetime.now()
        date=timestring.strftime('%Y-%m-%d_%H%M%S')
        self.fname = date + '_monitor.csv'
        if self.monitor_vacuum == True and self.monitor_lenses == False:
            output = 'Time(s), Peg0, Pig0, Pig1, Pig2, Pig3, Pig4, Pig5'
        elif self.monitor_vacuum == False and self.monitor_lenses == True:
            output = 'Time(s), CL1, CL2, CL3, CM, OLc, OLf, OM1, OM2, IL1, IL2, IL3, PL1'
        elif self.monitor_vacuum == True and self.monitor_lenses == True:
            output = 'Time(s), Peg0, Pig0, Pig1, Pig2, Pig3, Pig4, Pig5, CL1, CL2, CL3, CM, OLc, OLf, OM1, OM2, IL1, IL2, IL3, PL1'
        with open( self.fname, 'x', encoding="utf-8") as f:
            f.write(output)
        print( '\nWriting data to ' + self.fname )
        return
    
    
    def _lens_axis( self, ax, xlim ):
        ax.set_ylabel( "Normalised Current" )
        ax.set_xlabel( "Time / min" )
        ax.set_ylim( [0, 1] )
        ax.set_xlim( xlim )
        ax.set_title( 'Lenses' )
        ax.plot( self.time_data, self.CL1, label='CL1' )
        ax.plot( self.time_data, self.CL2, label='CL1' )
        ax.plot( self.time_data, self.CL3, label='CL3' )
        ax.plot( self.time_data, self.CM, label='CM' )
        ax.plot( self.time_data, self.OLc, label='OLc' )
        ax.plot( self.time_data, self.OLf, label='OLf' )
        ax.plot( self.time_data, self.OM1, label='OM1' )
        ax.plot( self.time_data, self.OM2, label='OM2' )
        ax.plot( self.time_data, self.IL1, label='IL1' )
        ax.plot( self.time_data, self.IL2, label='IL2' )
        ax.plot( self.time_data, self.IL3, label='IL3' )
        ax.plot( self.time_data, self.PL1, label='PL1' )
        return
    
    
    def _vac_axis( self, ax, xlim ):
        ax.set_ylabel( "Pressure" )
        ax.set_xlabel( "Live time / s" )
        ax.set_title( 'Vacuum' )
        ax.set_ylim( self.ylim )
        ax.set_xlim( xlim )
        ax.plot( self.time_data, self.peg0_data, label='PeG1' )
        ax.plot( self.time_data, self.pig1_data, label='PiG2')
        ax.plot( self.time_data, self.pig3_data, label='PiG4')
        return
    
    
    def _get_vac_gauges( self ):
        # Penning.
        self.peg0_data = [ self.vac_module.GetPegInfo( 0 )[0] ]
        # Pirani.
        self.pig0_data = [ self.vac_module.GetPigInfo( 0 )[0] ]
        self.pig1_data = [ self.vac_module.GetPigInfo( 1 )[0] ]
        self.pig2_data = [ self.vac_module.GetPigInfo( 2 )[0] ]
        self.pig3_data = [ self.vac_module.GetPigInfo( 3 )[0] ]
        self.pig4_data = [ self.vac_module.GetPigInfo( 4 )[0] ]
        self.pig5_data = [ self.vac_module.GetPigInfo( 5 )[0] ]
        return
    
    
    def _get_lenses_dec( self ):
        # Get lens value as a decimal, range 0 - 1.
        # Condenser system
        self.CL1 = [ self.lens.GetLensInfo(0) / 65535 ]
        self.CL2 = [ self.lens.GetLensInfo(1) / 65535 ]
        self.CL3 = [ self.lens.GetLensInfo(2) / 65535 ]
        self.CM = [ self.lens.GetLensInfo(3) / 65535 ]
        # Objective. 
        self.OLc = [ self.lens.GetLensInfo(6) / 65535 ]
        self.OLf = [ self.lens.GetLensInfo(7) / 65535 ]
        self.OM1 = [ self.lens.GetLensInfo(8) / 65535 ]
        self.OM2 = [ self.lens.GetLensInfo(9) / 65535 ]
        # Intermediate.
        self.IL1 = [ self.lens.GetLensInfo(10) / 65535 ]
        self.IL2 = [ self.lens.GetLensInfo(11) / 65535 ]
        self.IL3 = [ self.lens.GetLensInfo(12) / 65535 ]
        # Projector.
        self.PL1 = [ self.lens.GetLensInfo(14) / 65535 ]
        return
        
        
    # plt.legend( ['PeG1','PiG2','PiG4'], loc='upper left' )
    
    
    def _animate( self, frame ):
        # Update values.
        self._update_vals( (self.interval/1000) )
        # Update xlim.
        if (self.time_data[0] == 0):
            xlim = ([0, self.max_time])
        else:
            xlim = ([self.time_data[0], self.time_data[-1]])
        # Plot graph.
        if self.monitor_vacuum == True and self.monitor_lenses == True:
            self.axs[0].clear()
            self.axs[1].clear()
            self._vac_axis( self.axs[0], xlim  )
            self._lens_axis( self.axs[1], xlim  )
        if self.monitor_vacuum == True and self.monitor_lenses == False:
            self.axs.clear()
            self._vac_axis( self.axs, xlim  )
            plt.legend( ['PeG1','PiG2','PiG4'], loc='upper left' )
        if self.monitor_vacuum == False and self.monitor_lenses == True:
            self.axs.clear()
            self._lens_axis( self.axs, xlim  )
            plt.legend( ['CL1', 'CL2', 'CL3', 'CM', 'OLc', 'OLf', 'OM1', 'OM2', 'IL1', 'IL2', 'IL3', 'PL1'], loc='upper left' )
        # Log data to file.
        self._log_data()
        return
        
        
    def _update_vals( self, interval ):
        # Update all monitored params and advance time.
        self.time_data.append( self.time_data[-1] + interval )
        if self.monitor_lenses == True:
            self._update_lens_vals()
        if self.monitor_vacuum == True:
            self._update_vac_vals()
        self._trim_var_arrays()
        return
        
        
    def _trim_var_arrays( self ):
        if (len(self.time_data) > self.max_time):
            # Time.
            self.time_data.pop(0)
            # Vacuum.
            if self.monitor_vacuum == True:
                self.peg0_data.pop(0)
                self.pig0_data.pop(0)
                self.pig1_data.pop(0)
                self.pig2_data.pop(0)
                self.pig3_data.pop(0)
                self.pig4_data.pop(0)
                self.pig5_data.pop(0)
            # Lenses.
            if self.monitor_lenses == True:
                self.CL1.pop(0)
                self.CL2.pop(0)
                self.CL3.pop(0)
                self.CM.pop(0)
                self.OLc.pop(0)
                self.OLf.pop(0)
                self.OM1.pop(0)
                self.OM2.pop(0)
                self.IL1.pop(0)
                self.IL2.pop(0)
                self.IL3.pop(0)
                self.PL1.pop(0)
        return
    
    
    def _update_lens_vals( self ):
        '''
        Update the data used to draw the graph.
        '''
        self.CL1.append( self.lens.GetLensInfo(0) / 65535 )
        self.CL2.append( self.lens.GetLensInfo(1) / 65535 )
        self.CL3.append( self.lens.GetLensInfo(2) / 65535 )
        self.CM.append( self.lens.GetLensInfo(3) / 65535 )
        # Objective. 
        self.OLc.append( self.lens.GetLensInfo(6) / 65535 )
        self.OLf.append( self.lens.GetLensInfo(7) / 65535 )
        self.OM1.append( self.lens.GetLensInfo(8) / 65535 )
        self.OM2.append( self.lens.GetLensInfo(9) / 65535 )
        # Intermediate.
        self.IL1.append( self.lens.GetLensInfo(10) / 65535 )
        self.IL2.append( self.lens.GetLensInfo(11) / 65535 )
        self.IL3.append( self.lens.GetLensInfo(12) / 65535 )
        # Projector.
        self.PL1.append( self.lens.GetLensInfo(14) / 65535 )
        return
        
        
    def _update_vac_vals( self ):
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
        return
    
    
    def _log_data( self ):
        # if statement to contorl which we are monitoring herer
        output = '\n' + str("%.1f" % self.time_data[-1])
        # Vacuum gauges.
        if self.monitor_vacuum == True:
            output += ', '+ str("%.2f" % self.peg0_data[-1])+\
            ', '+ str("%.2f" % self.pig0_data[-1])+\
            ', '+ str("%.2f" % self.pig1_data[-1])+\
            ', '+ str("%.2f" % self.pig2_data[-1])+\
            ', '+ str("%.2f" % self.pig3_data[-1])+\
            ', '+ str("%.2f" % self.pig4_data[-1])+\
            ', '+ str("%.2f" % self.pig5_data[-1])
        # Lenses.
        if self.monitor_lenses == True:
            output +=', '+ str("%.2f" % self.CL1[-1])+\
            ', '+ str("%.2f" % self.CL2[-1])+\
            ', '+ str("%.2f" % self.CL3[-1])+\
            ', '+ str("%.2f" % self.CM[-1])+\
            ', '+ str("%.2f" % self.OLc[-1])+\
            ', '+ str("%.2f" % self.OLf[-1])+\
            ', '+ str("%.2f" % self.OM1[-1])+\
            ', '+ str("%.2f" % self.OM2[-1])+\
            ', '+ str("%.2f" % self.IL1[-1])+\
            ', '+ str("%.2f" % self.IL2[-1])+\
            ', '+ str("%.2f" % self.IL3[-1])+\
            ', '+ str("%.2f" % self.PL1[-1])
        
        with open( self.fname, 'a', encoding='utf-8') as f:
            f.write( output )
        return


# Script starts here.

#style.use('fivethirtyeight')

vac_sys = microscopeMonitor( True, False )

ani = animation.FuncAnimation(vac_sys.fig, vac_sys._animate, cache_frame_data=False, interval=vac_sys.interval)

plt.show()
