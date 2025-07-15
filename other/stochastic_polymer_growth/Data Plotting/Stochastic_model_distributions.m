%% Monte Carlo Distributions
%x = Results_6_covalency_1000_repeats_5000_monomers.One_Bond;
%binning = round(sqrt(1000));
%histfit(x,binning,'normal');
%clear x
hold on;
histfit(Results_6_covalency_1000_repeats_5000_monomers.One_Bond,binning,'normal');
histfit(Results_6_covalency_1000_repeats_5000_monomers. Two_Bond,binning,'normal');
histfit(Results_6_covalency_1000_repeats_5000_monomers.Three_Bond,binning,'normal');
histfit(Results_6_covalency_1000_repeats_5000_monomers.Four_Bond,binning,'normal');
histfit(Results_6_covalency_1000_repeats_5000_monomers.Five_Bond,binning,'normal');
histfit(Results_6_covalency_1000_repeats_5000_monomers.Six_Bond,binning,'normal');
hold off