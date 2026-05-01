%% Nanotube length loss linear model
% This very simple model models length loss of nanotubes over time as a linear function using
% normally distributed data. Input is a mean, standard deviation and sample
% size

stdev = 100; %standard deviation in tube length, in nm
mean = 1000; %mean tube length, in nm
sampleSize = 1000; %number of tubes
gaussDist1 = stdev.*randn(sampleSize,1) + mean;

deltaLoss = 10;%length loss per unit time, in nm per min
deltaTime = 100;%change in  time, in min

gaussDist2 = gaussDist1 - deltaLoss*deltaTime;%linear length loss function

for n = 1:length(gaussDist1)
    if gaussDist1(n,1) < 0
        gaussDist1(n,1) = 0;
    end
end
gaussDist1 = nonzeros(gaussDist1);

for n = 1:length(gaussDist2)
    if gaussDist2(n,1) < 0
        gaussDist2(n,1) = 0;
    end
end
gaussDist2 = nonzeros(gaussDist2);

v=length(nonzeros(gaussDist1));
disp(['Number of tubes at start: ',num2str(v)]);
v=length(nonzeros(gaussDist2));
disp(['Number of tubes at end: ',num2str(v)]);
clear v w;

hold on;
histfit(gaussDist1)
histfit(gaussDist2)
hold off;

xlim([0.1,inf]);
ylim([-inf,inf]);
xlabel('Length of tube / nm');
ylabel('Frequency');

clear gaussDist1 gaussDist2 deltaLoss deltaTime sampleSize stdev mean n