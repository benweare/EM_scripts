'''
Something using pyJEM and TEMGym to make a live model of the beam path thru the column?

Uses custom fork of TEMgym, to allow drawing ray diagram on specific figure.
'''

#import PyJEM
#from PyJEM import TEM3

import numpy as np

from datetime import datetime

import matplotlib.pyplot as plt
import matplotlib.animation as animation

import temgymbasic
from temgymbasic import components as comp
from temgymbasic.model import Model
from temgymbasic.run import show_matplotlib

import PyJEM
from PyJEM import TEM3

class microscopeMonitor:
    def __init__( self ):
        # Connect to the microscope.
        if TEM3.isconnect() == False:
            TEM3.connect()
        print('\nConnected to microscope.')
        
        # Create an instance of the VACUUM3 module.
        self.vac_module=TEM3.VACUUM3()
        print('\nConnected to vacuum system.')
        
        # Init virtual microscopes.
        self.vscope = virtualMicroscope()
        self.sim = microscopeSimulation( self.vscope )
        
        # Sample rate in ms.
        self.interval = 1500
        
        # Create a Matplotlib figure for the lens diagram.
        self.sim._make_model()
        self.fig, self.ax = show_matplotlib(self.sim.model,
                                    name = self.sim.name,
                                    label_fontsize = 8)
        self.figsize = self.fig.get_size_inches()
        self.fig.set_size_inches( self.figsize/2 )
        return
        
     
    def _plot_settings(self):
        self.ax.clear()
        self.sim._make_model()
        self.figsize = self.fig.get_size_inches()
        self.fig.set_size_inches( self.figsize/2 )
        self.canvas.draw()
        return
        
    def _animate( self, frame ):
        self.ax.clear()
        self.vscope._update_lenses()
        self.sim._update_components( self.vscope )
        self.fig, self.ax = show_matplotlib(self.sim.model,
                                    name = self.sim.name,
                                    label_fontsize = 8,
                                    figure=self.fig,
                                    axis=self.ax)
        #print('\r OLc: ' + str(self.vscope.OLc))
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
        self.components = self._init_components( vscope )
        self.model = self._make_model()
        return

    def _calc_focal_length( self ):
        # do some magic to get the real focal length out?
        return

    def _init_components( self, vscope ):
        # Create TEMgym model list.
        components = [comp.Lens(name = 'Electrostatic Lens',
                                    z = 3,
                                    f = -0.2),
                        comp.DoubleDeflector(name = 'Gun Beam Deflectors',
                                            z_up = 2.8,
                                            z_low = 2.7),
                        comp.Lens(name = 'CL1',
                                            z = 2.6,
                                            f = -0.2),
                        comp.Lens(name = 'CL2',
                                            z = 2.5,
                                            f = -0.2),
                        #comp.Lens(name = 'CL3',
                        #                    z = 2.5,
                        #                    f = -0.2)
                        comp.Aperture(name = 'CA',
                                            z = 2.3,
                                            aperture_radius_inner=0.05),
                        comp.Quadrupole(name = 'C stig', z = 2.2),
                        comp.DoubleDeflector(name = 'C Def',
                                            z_up = 2.1,
                                            z_low = 2.0),
                        comp.Lens(name = 'CM',
                                            z = 1.8,
                                            f = -0.2),
                        comp.Aperture(name = 'Obj A',
                                            z = 1.7,
                                            aperture_radius_inner=1.0),#0.05
                        comp.Lens(name = 'OL',
                                            z = 1.5,
                                            f = -0.2),
                        comp.Quadrupole(name = 'Obj Stig',
                                            z = 1.4),
                        comp.Lens(name = 'OM',
                                            z = 1.3,
                                            f = -0.2),
                        comp.DoubleDeflector(name = 'Image Shifts',
                                            z_up = 1.1,
                                            z_low = 1.0),
                        comp.Aperture(name = 'SA A',
                                            z = 0.9,
                                            aperture_radius_inner=1.0),#0.05
                        comp.Quadrupole(name = 'IL Stigmator', z = 0.8),
                        comp.Lens(name = 'IL1',
                                            z = 0.7,
                                            f = -0.2),
                        comp.Lens(name = 'IL2',
                                            z = 0.6,
                                            f = -0.2),
                        comp.Lens(name = 'IL3',
                                            z = 0.5,
                                            f = -0.2),
                        comp.DoubleDeflector(name = 'PL def',
                                            z_up = 0.4,
                                            z_low = 0.3),
                        comp.Lens(name = 'PL',
                                            z =0.2,
                                            f = -0.2)
                        ]
        return components
        
    def _update_components( self, vscope ):
        # Condenser.
        self.components[2].f = vscope.CL1
        self.components[3].f = vscope.CL2
        self.components[7].f = vscope.CM
        # Objective.
        self.components[10].f = vscope.OLc
        if (vscope.OM1 != 0):
            self.components[11].f = vscope.OM1
        else:
            self.components[11].f = -0.2
        # Intermediate.
        self.components[15].f = vscope.IL1
        self.components[16].f = vscope.IL2
        self.components[17].f = vscope.IL3
        # Projector.
        self.components[19].f = vscope.PL1
        return

    def _make_model( self ):
        self.model = Model(self.components,
                            beam_z=self.beam_z,
                            beam_type=self.beam_type,
                            num_rays=self.num_rays,
                            gun_beam_semi_angle=0.15)
        return



# Script starts here.

model = microscopeMonitor()

ani = animation.FuncAnimation(model.fig, model._animate, cache_frame_data=False, interval=model.interval)

plt.show()

# End of script.
