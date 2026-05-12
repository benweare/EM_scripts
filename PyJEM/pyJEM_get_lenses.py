import PyJEM
from PyJEM import TEM3

import time


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
        

vscope = virtualMicroscope()

t1 = time.time()

vscope._update_lenses()

t2 = time.time()

print( 'Time / s: ', str( '%.2f' % (t2-t1)) )
print(vscope.CL1)