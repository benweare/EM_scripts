%% Adding noise to v6 graphs
%adds random noise in the range (a,b) where a = -b and a = coordinate
randLowerLimit = -0.80;
randUpperLimit = 0.80;
for x = 1:1:length(CoOrdMat_0_noise)
    CoOrdMat(x,1) = (CoOrdMat_0_noise(x,1)) + ((randUpperLimit-randLowerLimit)*rand() + randLowerLimit);
    CoOrdMat(x,2) = (CoOrdMat_0_noise(x,2)) + ((randUpperLimit-randLowerLimit)*rand() + randLowerLimit);
    CoOrdMat(x,3) = (CoOrdMat_0_noise(x,3)) + ((randUpperLimit-randLowerLimit)*rand() + randLowerLimit);
end


close;
x=CoOrdMat_0_noise;
CovBonGraph_plot=plot(CovBonGraph,'XData',x(:,1),'YData',x(:,2),'ZData',x(:,3));
axis square
CovBonGraph_plot.NodeColor=1/255*[19 159 255];
CovBonGraph_plot.EdgeColor=1/255*[0 0 0];
CovBonGraph_plot.EdgeAlpha=0;
CovBonGraph_plot.LineWidth=4;
CovBonGraph_plot.MarkerSize=8;
ylim([-20, 25])
xlim([-10, 8])
view(0,90);

saveas(gcf,num2str(x),'jpeg')
x=x+5;

hold on
scatter(percent,one)
scatter(percent,two)
scatter(percent,noise)
plot(one_fit)
plot(two_fit)


function noise = randNoise(a,b)
noise = (b-a)*rand() + a;
end
%line profile