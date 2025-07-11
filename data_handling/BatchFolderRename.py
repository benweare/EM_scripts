import os
from os import path
import shutil

Source_Path = 'C:/Users/pczbw2/Desktop/TEMP/NDGMED_03_raw'
Destination = 'C:/Users/pczbw2/Desktop/TEMP/NDGMED_03_raw/conversion'

if os.path.isdir(Destination):
    print("Adding files to existing folder, will throw error if files of same destination name exist")
else:
    print("Making new folder")
    os.mkdir(Destination)


# Renames files and moves them from the original source folder to a new destination folder
def main():
    for count, filename in enumerate(os.listdir(Source_Path)):
        #Modify this line to give new filename
        dst =  "Conversion" + str(count) + ".raw"
        

        # rename all the files
        os.rename(os.path.join(Source_Path, filename),  os.path.join(Destination, dst))


# Driver Code
if __name__ == '__main__':
    main()
