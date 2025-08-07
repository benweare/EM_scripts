// dynamic background subtraction
image img = GetFrontImage()

number background// = mean(img[0, 0, 1, 50])// top, left, bottom, right

number width = ImageGetDimensionSize( input, 0)
number height = ImageGetDimensionSize( input, 1)

for (i = 1; i < height; i++)
{
	background = mean(img[i-1, 0, i, 50])// top, left, bottom, right
	img[img[0, 0, 1, width] - background
}
