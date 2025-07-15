// script to test how far image is shifted using beam shifts
// takes image from Live View in Digital Micrograph, could also use image acquire commands
image GetShiftedImage( number deltax, number deltay, number stagex, number stagey )
{
	EMSetImageShift( stagex + deltax, stagey + deltay )
	image output = GetFrontImage()
	result((stagex + deltax) + " " + (stagey+deltay) + "\n")
	sleep(0.2)
	EMSetImageShift( stagex, stagey )
	return output
}

number xscale, yscale, stage_x, stage_y
image image_00 = GetFrontImage()

number deltax = 1000
number deltay = 1000

string name = "image shift of " + deltax

EMGetImageShift(stage_x, stage_y)
result(stage_x + " " + stage_y + "\n")

image image_01 = GetShiftedImage( deltax, 0, stage_x, stage_y ) //shift x
sleep( 0.5 )
image image_02 = GetShiftedImage( 0, deltay, stage_x, stage_y )// shift y

// sum images
image sumimage = image_00  - image_01// - image_02
GetScale( image_00, xscale, yscale )
SetScale(sumimage, xscale, yscale)
showimage(sumimage)
setname(sumimage, name)

result(stage_x + " " + stage_y + "\n" )

//ShowImage(image_00)
ShowImage(image_01)
setname(image_01, "x shift")
ShowImage(image_02)
setname(image_02, "y shift")
CloseImage(image_00)
//CloseImage(image_01)
//CloseImage(image_02)

