# script to convert a list of DM4 files
import glob
import os
from os import path
import numpy as np

import DigitalMicrograph as DM
#Hybrid script as python can't access menu commands?

Dir = 'dummy'
dmScript = 'string folder , outputFolder' + '\n'
dmScript += 'if ( !GetDirectoryDialog( "Select folder" , "" , folder ) ) ' + '\n'
dmScript += '     Result(folder)' + '\n'
dmScript += '     string Dir = folder' + '\n'
dmScript += '     TagGroup tg = GetPersistentTagGroup( ) ' + '\n'
dmScript += '     tg.TagGroupSetTagAsString( "DM2Python String", folder )' + '\n'

#Execute the script
DM.ExecuteScriptString( dmScript )

#Get the selection data into python
TGp = DM.GetPersistentTagGroup()
returnVal, val = TGp.GetTagAsText('DM2Python String')

print("\n Opening directory "+str(val))

#val is the python string containing the folder

os.chdir(val)
os.getcwd()
os.listdir()
pth = os.getcwd()
pthA = pth + '\\*.dm4'
list_of_files = glob.glob(pthA) # * means all, if need specific format then *.dm4
#print(list_of_files)

#Process files routine
def ProcessFiles (list_of_files):
    #Check if directory exists
    dpath = os.path.dirname(list_of_files[0]) + "/raw"
    isExist = os.path.exists(dpath)
    if not isExist:
        os.makedirs(dpath)
        print("directory for files is "+dpath)
    for n in list_of_files:
        #print(n)
        dmImg = DM.OpenImage(n)
        #dmImg.ShowImage()
        #Type check here if need be?
        sx = dmImg.GetDimensionSize(0)
        sy = dmImg.GetDimensionSize(1)
        
        
        if sy % 4 == 1:#moduo 4
            sy = sy - 1
        elif sy % 4 == 2:
            sy = sy - 2
        elif sy % 4 == 3:
            sy = sy - 3
            
        if sx % 4 == 1:
            sx = sx - 1
        elif sx % 4 == 2:
            sx = sx - 2
        elif sx % 4 == 3:
            sx = sx - 3
        
        print("SY:" + str(sy))
        print("SX:" + str(sx))
        
        sdiff = np.abs((sx-sy)/2)
        image = dmImg.GetNumArray() # Get NumpyArray to image data
        pa = int(sdiff)
        pb = int(sy+sdiff)
        imdat = image[0:sy,pa:pb]
        imdat = image[0:sy,0:sx]
        fout = os.path.dirname(n) + "/raw/"+os.path.splitext(os.path.basename(n))[0]+".raw"
        bin_file = imdat.tofile(fout)
        #Close file
        DM.CloseImage(dmImg)
        del(dmImg)
        
# End of def ProcessFiles

ProcessFiles(list_of_files)

print("done")