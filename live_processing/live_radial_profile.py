'''

Live radial profile in DigitalMicrograpgh.

Author(s): E Weare
Location: nmRC
Date: 06-06-2026

'''

import numpy as np
import sys
import time
import traceback
import DigitalMicrograph as DM


class imageListener( DM.Py_ScriptObject ):
    '''
    Image listener class.

    Updates image when live view updates.
    

    Attributes
    ----------
    DM.PyscriptObject : class

    Methods
    -------
    find_ROI
    processing_loop
    HandleDataChangedEvent
    HandleWindowClosedEvent
    HandleROIRemovedEvent
    RemoveListeners


    Warnings
    --------


    Notes
    -----
    Based on script by Ben Miller (Gatan) for live data processing.

    Runs slowly if many Fourier transforms are called in each processing step.

    '''
    
    
    # Constructor.
    def __init__(self,img):
        try:
            #Create an index that is incremented each time data is processed.
            self.i = 0
            #get the original image and assign it to self.imgref
            self.imgref = img
            
            #Get the data from the region within an ROI
            self.roi = DM.GetROIFromID(self.find_ROI(self.imgref))
            val, val2, val3, val4 = self.roi.GetRectangle()
            self.data = self.imgref.GetNumArray()[int(val):int(val3),int(val2):int(val4)]
            #get the shape and calibration of the original image
            (input_sizex, input_sizey) = self.data.shape
            origin, x_scale, scale_unit =  self.imgref.GetDimensionCalibration(1, 0)
            if scale_unit == b'\xb5m': scale_unit = 'um' #scale unit of microns causes problems for python in DM
            
            # Create a new image to contain the results of processing.
            self.result_image = _np_array_to_dm_image( self.data.copy(), str("Extract of " + img.GetName() ) )
            #Set the calibration based on the original data
            self.result_image.SetDimensionCalibration(0,origin,x_scale,scale_unit,0)
            self.result_image.SetDimensionCalibration(1,origin,x_scale,scale_unit,0)

            # Get reference to image numpy array.
            self.result_data=self.result_image.GetNumArray()

            # Radial profile variables.
            self.profile, _ = self.radial_profile( self.image_data.copy(), len(self.image_data[0])/2), len(self.image_data[0])/2 )
            self.dm_profile = self._np_array_to_dm_image( self.profile, title='Radial Profile' )
            self.profile = self.dm_profile.GetNumArray()


            DM.Py_ScriptObject.__init__(self)
            self.stop = 0
        except:
            print( traceback.format_exc() )
        return
    
    
    def find_ROI(self, image):
        '''
        Function to find an ROI placed on an image by the user, returning the ROI ID.
        If no ROI found, create a new one covering the entire image.
        '''
        imageDisplay = image.GetImageDisplay(0)
        numROIs = imageDisplay.CountROIs()
        id = None
        for n in range(numROIs):
            roi = imageDisplay.GetROI(n) 
            if roi.IsRectangle():
                roi.SetVolatile(False)
                roi.SetResizable(False)  
                id = roi.GetID()
                break
        if id is None:
            #I f No ROI is found, create one that covers the whole image. 
            print('\nRectangular ROI not found. Using whole image.\n')
            data_shape = image.GetNumArray().shape
            roi=DM.NewROI()
            roi.SetRectangle(0, 0, data_shape[0], data_shape[1])
            imageDisplay.AddROI(roi)
            roi.SetVolatile(False)
            roi.SetResizable(False)
            id = roi.GetID()
        return id
    
    
    #@jit
    # From PyCTF module.
    def radial_profile( self, data, centX, centY ):
        '''
        Create radial profile of 2D array.
        
        Parameters
        ----------
        data : array
            Input, square 2D array.
        centX : int
            Centre of array in x-axis.
        centY : int
            Centre of array in y-axis.
        
        Returns
        -------
        radialprofile :  array
            Output, 1D array.
        bins : int
            Length of radial profile.
        
        Notes
        -----
        Based on example from Stack Exchange:
        https://stackoverflow.com/questions/21242011/most-efficient-way-to-calculate-radial-profile
        If used with iradius generated from a 2D array, the output is
        the frequency for the intensity radial profile. 
        '''
        y, x = np.indices( data.shape )
        r = np.sqrt( np.square(x - centX) + np.square(y - centY) )
        r = r.astype( np.int64 )
        tbin = np.bincount( r.ravel(), data.ravel() )
        nr = np.bincount( r.ravel() )
        radialprofile = tbin / nr
        bins = np.size( nr )
        return radialprofile, bins
    
    
        # Function run each time updates.
    def processing_loop( self ):
        '''
        Function to be called every time data is updated.
        '''
        # Copy live view to the extract image.
        self.profile[:], _ = self.radial_profile( self.data.copy(), len(self.data[0])/2), len(self.data[0])/2 )
        return
    
    
    def HandleDataChangedEvent(self, flags, image):
        '''
        This function is run each time the image changes.
        '''
        try:
            if not self.stop:
                # Get ROI and data within it.
                val, val2, val3, val4 = self.roi.GetRectangle()
                self.data = self.imgref.GetNumArray()[int(val):int(val3),int(val2):int(val4)]
                
                self.processing_loop( )
                
                #Update the image displays.
                
                self.i = self.i+1
        except:
            print(traceback.format_exc())
        return
    
    
    # Destructor.
    def __del__( self ):
        print( 'Listener Deleted.\n' )
        DM.Py_ScriptObject.__del__(self)
        return
    
    
    # Function to end processing by deleting or unregistering listener.
    def RemoveListeners(self):
        try: 
            if not self.stop:
                self.stop = 1
                DM.DoEvents()
                listener.UnregisterAllListeners()
                print("Live Processing Script Ended.\n")
        except:
            print(traceback.format_exc())
        return
    
    
    #Remove listeners if source image window is closed.
    def HandleWindowClosedEvent(self, event_flags, window):
        print("Window Closed.\n")
        self.RemoveListeners()
        return
    
    
    #Remove listeners if the ROI is deleted.
    def HandleROIRemovedEvent(self, img_disp_event_flags, img_disp, roi_change_flag, roi_disp_change_flags, roi):
        print("ROI Removed.\n")
        self.RemoveListeners()
        return
    
    
    #Check if running on the main thread for using matplotlib in DM.
    def _check_thread( self ):
        if ( DM.IsScriptOnMainThread() == False ):
            print( 'MatplotLib scripts are required to be run on the main thread.\n' )
            exit()
        return


    def _np_array_to_dm_image( self, input_array, **kwargs ):
        title = kwargs.get('title', None)
        dm_image = DM.CreateImage( input_array )
        if (title != None):
            dm_image.SetName( title )
        return dm_image


# Script starts here.

# Get fron image and associated variables.
front_image = DM.GetFrontImage()
image_doc = DM.GetFrontImageDocument()
im_doc_win = image_doc.GetWindow()
image_display = front_image.GetImageDisplay(0)

# Create image listener to perform the live processing.
listener = imageListener( front_image )

# Checks to see if image or ROI is closed.
WindowClosedListenerID = listener.WindowHandleWindowClosedEvent(im_doc_win, 'pythonplugin')
ROIRemovedListenerID = listener.ImageDisplayHandleROIRemovedEvent(image_display,'pythonplugin')

# Check for if data is changed.
DataChangedListenerID = listener.ImageHandleDataChangedEvent(front_image, 'pythonplugin')

# End of script.