%% Data plotting for v6 results

%% Mean ratio no bonds to monomers versus probability
Probability = Mean_results_v5(:,1);
Ratio_3_bonds =  Mean_results_v5(:,14);
Ratio_2_bonds =  Mean_results_v5(:,12);
Ratio_1_bonds =  Mean_results_v5(:,10);
hold on
%scatter(Probability,Ratio_3_bonds);
subplot(2,3,1);
errorbar(Probability,Mean_results_v5(:,14),Mean_results_v5(:,15),Mean_results_v5(:,15),'o')
title('3 bond : No Monomers')
%scatter(Probability,Ratio_2_bonds);
subplot(2,3,2);
errorbar(Probability,Mean_results_v5(:,16),Mean_results_v5(:,17),Mean_results_v5(:,17),'o')
title('2 bond : No Monomers')
%scatter(Probability,Ratio_1_bonds);
subplot(2,3,3);
errorbar(Probability,Mean_results_v5(:,18),Mean_results_v5(:,19),Mean_results_v5(:,19),'o')
title('1 bond : No Monomers')
hold off
%% Growth direction
colormap viridis
%subplot(2,3,4);
b=bar(Mean_results_v6_ads(:,6:2:20),'stacked','FaceColor','flat');
for k = 1:8
    b(k).CData = k;
end
title('Growth Direction')
legend('---', '+++','-++','--+','++-','+-+','+--','-+-');
%% Ratio total bonds to monomers
subplot(2,3,5);
errorbar(Probability,Mean_results_v5(:,4),Mean_results_v5(:,5),Mean_results_v5(:,5),'o')
title('Total bonds:No Monomers')
%{
%% Histogram for individual data sets
Data = Results_5000_monomers_1000_repeats_50_probability_ring_closing;
binning = round(sqrt(1000));
%%
subplot(2,4,1);
histfit(Data.Ratio_bonds_to_monomers,binning,'normal');
title('Bonds : no monomers')
%%
subplot(2,4,2);
histfit(Data.nxny,binning,'lognormal');
title('nXnY')
%%
subplot(2,4,3);
histfit(Data.pxpy,binning,'normal');
title('pXpY')
%%
subplot(2,4,4);
histfit(Data.pxny,binning,'normal');
title('pXnY')
%%
subplot(2,4,5);
histfit(Data.nxpy,binning,'normal');
title('nXpY')
%%
subplot(2,4,6);
histfit(Data.One_Bond,binning,'normal');
title('One Bond')
%%
subplot(2,4,7);
histfit(Data.Two_Bond,binning,'normal');
title('Two Bond')
%%
subplot(2,4,8);
histfit(Data.Three_Bond,binning,'normal');
title('Three Bond')
%}