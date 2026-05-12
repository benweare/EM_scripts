'''
Something using pyJEM and TEMGym to make a live model of the beam path thru the column?
'''

#import PyJEM
#from PyJEM import TEM3

import numpy as np

import temgymbasic
from temgymbasic import components as comp
from temgymbasic.model import Model
from temgymbasic.run import show_matplotlib

import matplotlib.pyplot as plt

import matplotlib
from matplotlib.figure import Figure
from matplotlib.backends.backend_tkagg import (FigureCanvasTkAgg, NavigationToolbar2Tk)
import tkinter as tk
import threading
import time

import PyJEM
from PyJEM import TEM3

class userInterface:
    # Python constructor.
    def __init__(self, master, model_scope, vscope):
        self.master = master
        self.frame = tk.Frame( self.master )
        self.master.title( 'Lens diagram' )
        self.master.configure( bg='#FFFFFF' )
        self.sim = model_scope
        self.vscope = vscope
        
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
        self.interval_list=['1','2','5']
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
        
        # Create a Matplotlib figure for the lens diagram.
        self.sim._make_model()
        self.fig, self.ax = self.sim._create_figure()
        self.figsize = self.fig.get_size_inches()
        self.fig.set_size_inches( self.figsize/3 )
        
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
        
        self.terminate_thread_flag=0
        return

    # Destructor.
    def __del__(self):
        self.terminate_thread_flag = 1
        return
        
    def _update_graph(self):
        self.sim._make_model()
        self.fig, self.ax = self.sim._create_figure()
        self.figsize = self.fig.get_size_inches()
        self.fig.set_size_inches( self.figsize/3 )
        self.canvas.draw()
        return

    def monitor(self):
        '''
        Thread to monitor vacuum system.
        '''
        print("\nModel microscope.\n")
        do_break=0
        
        # Source the interval from the dialog
        interval=self.interval_val.get()
        
        # Infinite sampling loop. Break by press Stop.
        while 1:
            # Grab microscope state.
            # Draw figure.
            # Update diagram.

            self.mainentry.update_idletasks()
            
            # Update the lens diagram.
            
            self.sim.components = self.sim._update_components( self.vscope )
            self._update_graph()
            
            print("\Objective coarse = "+str(self.vscope.OLc)+" Time = "+nowtime, end="")
            
            # Break the sampling interval into 1s interval and check for
            # a stop press every second.
            for i in range(interval):
                if self.terminate_thread_flag==1:
                    do_break=1
                    break
                time.sleep(1)
                       
            if do_break==1:
                break
        
        # Reset the dialog.
        print("\nThread ended")
        self.terminate_thread_flag=0
        self.start_button.config(state="normal")
        return

    def start_monitoring_response(self):
        '''
        Responds when the Start button is pressed
        '''
        self.start_button.config(state="disabled")
        self.terminate_thread_flag=0
        print("\nStart pressed")
    
        #self.thread_id=threading.get_ident()
        #print("Thread id = "+str(self.thread_id))
        #threading.Timer(0, self.monitor).start()
        return
    
    def end_monitoring_response(self):
        '''
        Responds when the Press Me button is pressed
        '''
        print("Stop pressed")
        self.terminate_thread_flag=1
        self.start_button.config(state="normal")
        return


# Use pyJEM to get the needed info from the lenses.
class virtualMicroscope:
    def __init__( self ):
        self.lens = TEM3.Lens3()
        #self.stage = TEM3.Stage3()
        # Aperture diameters.
        self.C_aperture = [0, 0, 0, 0]
        self.O_aperture = [0, 0, 0, 0]
        self.SA_aperture = [0, 0, 0, 0]
        # Specimen position.
        #self.specimen = self.stage.GetPos()
        self._update_lenses()
        return

    def _update_lenses( self ):
        # Get lens value as a decimal.
        # 1 = maximim, 0 = minimum.
        # Condenser system
        self.CL1 = self.lens.GetLensInfo(0) / 65535
        self.CL2 = self.lens.GetLensInfo(1) / 65535
        self.CL3 = self.lens.GetLensInfo(2) / 65535
        self.CM = self.lens.GetLensInfo(3) / 65535

        # Objective. 
        self.OLc = self.lens.GetLensInfo(6) / 65535
        self.OLf = self.lens.GetLensInfo(7) / 65535
        self.OM1 = self.lens.GetLensInfo(8) / 65535
        self.OM2 = self.lens.GetLensInfo(9) / 65535

        # Intermediate.
        self.IL1 = self.lens.GetLensInfo(10) / 65535
        self.IL2 = self.lens.GetLensInfo(11) / 65535
        self.IL3 = self.lens.GetLensInfo(12) / 65535

        # Projector.
        self.PL1 = self.lens.GetLensInfo(14) / 65535
        return

    def _update_def( self ):
        # Update lens values via PyJEM.
        return


# Use TEMGym to make a microscope model here.
class microscopeSimulation:
    def __init__( self, vscope ):
        self.name = 'name'
        self.beam_z = 3.5
        self.beam_type = 'x_axial'
        self.num_rays = 32
        self.components = self._update_components( vscope )
        self.model = self._make_model()
        return

    def _calc_focal_length( self ):
        # do some magic to get the real focal length out?
        return

    def _update_components( self, vscope ):
        # update components based on PyJEM values somehow.
        components = [comp.Lens(name = 'Electrostatic Lens',
                                    z = 3,
                                    f = -0.2),
                        comp.DoubleDeflector(name = 'Gun Beam Deflectors',
                                            z_up = 2.8,
                                            z_low = 2.7),
                        comp.Lens(name = 'CL1',
                                            z = 2.6,
                                            f = vscope.CL1),
                        comp.Lens(name = 'CL2',
                                            z = 2.5,
                                            f = vscope.CL2),
                        comp.Aperture(name = 'CA',
                                            z = 2.3,
                                            aperture_radius_inner=0.05),
                        comp.Quadrupole(name = 'C stig', z = 2.2),
                        comp.DoubleDeflector(name = 'C Def',
                                            z_up = 2.1,
                                            z_low = 2.0),
                        comp.Lens(name = 'CM',
                                            z = 1.8,
                                            f = vscope.CM),
                        comp.Aperture(name = 'Obj A',
                                            z = 1.7,
                                            aperture_radius_inner=0.05),
                        comp.Lens(name = 'OL',
                                            z = 1.5,
                                            f = vscope.OLc),
                        comp.Quadrupole(name = 'Obj Stig',
                                            z = 1.4),
                        # Divide by 0 zero error here when in Mag mode
                        #comp.Lens(name = 'OM',
                        #                    z = 1.3,
                        #                    f = vscope.OM1),
                        comp.DoubleDeflector(name = 'Image Shifts',
                                            z_up = 1.1,
                                            z_low = 1.0),
                        comp.Aperture(name = 'SA A',
                                            z = 0.9,
                                            aperture_radius_inner=0.05),
                        comp.Quadrupole(name = 'IL Stigmator', z = 0.8),
                        comp.Lens(name = 'IL1',
                                            z = 0.7,
                                            f = vscope.IL1),
                        comp.Lens(name = 'IL2',
                                            z = 0.6,
                                            f = vscope.IL2),
                        comp.Lens(name = 'IL3',
                                            z = 0.5,
                                            f = vscope.IL3),
                        comp.DoubleDeflector(name = 'PL def',
                                            z_up = 0.4,
                                            z_low = 0.3),
                        comp.Lens(name = 'PL',
                                            z =0.2,
                                            f = vscope.PL1)
                        ]
        return components

    def _make_model( self ):
        self.model = Model(self.components,
                            beam_z=self.beam_z,
                            beam_type=self.beam_type,
                            num_rays=self.num_rays,
                            gun_beam_semi_angle=0.15)
        return

    def _create_figure( self ):
        fig, ax = show_matplotlib(self.model,
                                    name = self.name,
                                    label_fontsize = 14)
        return fig, ax


#def connect_to_microscope():
#   if (TEM3.isconnect == False):
#       TEM.connect()
#   return

# Script starts here.
virtual_scope = virtualMicroscope()
model_scope = microscopeSimulation( virtual_scope )


# UI as thread.
if __name__=='__main__':
    root = tk.Tk()
    app = userInterface( root, model_scope, virtual_scope )
    root.mainloop()
    root.mainloop()
