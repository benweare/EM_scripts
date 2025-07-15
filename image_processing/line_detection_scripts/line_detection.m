%% Line detection using Hough transform 
% This script attempts to find lines in images using the Hough transform
% It works reasonably well on good-quality images, but I'd tend to use Python nowadays for this
%Requires image processing toolbox
%figure, imshow()
SourceImage =imread('FT_mask_example.png'); %reads source image, should be 16-bit at most
%% Noise Reduction Options
GaussianFiltering = 1; %on = 1 off = 0
NoiseReduction = 0; %on = 1 off = 0
%% Line Detection Options
numpeaks = 10;
detection_factor = 0.5; %0-1
MinimumLineLength = 100; %minimum line length to be found
NHoodMatrix = [1;1]; %2-element row matrix of odd intergers, the area around each peak that is set to 0
%% Binary Thresholding 
threshold = 0.6; %adaptive or global or 0 - 1, used to decide which pixels are 1 or 0
%% Gaussian Filter Options
GaussianSigma = 1; %number of standard deviations used in Gaussian filter
FilterSize = 1; %filter size for Gaussian filter, odd number
%% Hough Transform
close all
if NoiseReduction == 1
    %SourceImageFiltered = medfilt2(SourceImage,[5,5]); %reduces noise by averaging pixels in a n*m area
elseif GaussianFiltering ==1
    SourceImageFiltered = imgaussfilt(SourceImage,GaussianSigma,'FilterSize',FilterSize); %reduces noise via a gaussian filter 
else
    SourceImageFiltered = SourceImage;
end
%SourceImage2=imfilter(SourceImage,h); 
BWImage=imbinarize(SourceImageFiltered,threshold); %converts to 2-bit
%BWImage=wiener2(BWImage); %reduces noise in 2-bit image
[HoughTransformMatrix,HoughTheta,HoughRho] = hough(BWImage);
subplot(2,2,1), imshow(SourceImage)
title('Original image')
subplot(2,2,2), imshow(BWImage)
title('2-bit image')
subplot(2,2,3), imshow(imadjust(rescale(HoughTransformMatrix)),'XData',HoughTheta,'YData',HoughRho,'InitialMagnification','fit');
title('Sinogram of 2-bit image')
colormap(gca,hot); % parula turbo hsv hot cool spring summer autumn winter gray bone copper
xlabel('\theta')
ylabel('\rho');
axis on, axis normal;
%% Finding maxima on sinogram
%houghpeaks detects up to a maximum number of peaks, threshold is minimum
%value to considered a peak as a function of the maximum intensity
%Peaks  = houghpeaks(HoughTransformMatrix,numpeaks,'threshold',ceil(detection_factor*max(HoughTransformMatrix(:))));%'NHoodSize',NHoodMatrix,
Peaks = houghpeaks(HoughTransformMatrix,numpeaks,'threshold',ceil(detection_factor*max(HoughTransformMatrix(:))));
x = HoughTheta(Peaks(:,2));
y = HoughRho(Peaks(:,1));
hold on
plot(x,y,'s','color',1/255*[0 0 255]);
%% Plotting lines on image
%houghlines find lines based on the binning from houghpeaks
lines = houghlines(BWImage,HoughTheta,HoughRho,Peaks,'FillGap',5,'MinLength',MinimumLineLength); 
subplot(2,2,4), imshow(SourceImage), hold on
%subplot(2,2,4), imshow(BWImage), hold on
title('Found lines')
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',1/255*[0 0 255]);

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color',1/255*[255 0 0]);
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
clear k len max_len numpeaks HoughRho HoughTheta title threshold thresholdtype x xy xy_long y
set(0,'defaultfigurecolor',[1 1 1]);