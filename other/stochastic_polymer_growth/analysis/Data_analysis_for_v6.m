Data = table2array(Results_1000_monomers_1000_repeats_90_abs_probability_Ads_v6);
Table_row = 9;
Probability = 0.9;
%Mean_results = zeros(21,10);
Mean_results_v5(Table_row,1)=Probability;
%% Mean total number of bonds
Mean_results_v5(Table_row,2)=mean(Data(:,4));
Mean_results_v5(Table_row,3)=std(Data(:,4));
%% Mean ratio number of bonds to number monomers
Mean_results_v5(Table_row,4)=mean(Data(:,5));
Mean_results_v5(Table_row,5)=std(Data(:,5));
%% Mean growth direction (octants)
%---
Mean_results_v5(Table_row,6)=mean(Data(:,7));
Mean_results_v5(Table_row,7)=std(Data(:,7));
%+++
Mean_results_v5(Table_row,8)=mean(Data(:,8));
Mean_results_v5(Table_row,9)=std(Data(:,8));
%-++
Mean_results_v5(Table_row,10)=mean(Data(:,9));
Mean_results_v5(Table_row,11)=std(Data(:,9));
%--+
Mean_results_v5(Table_row,12)=mean(Data(:,10));
Mean_results_v5(Table_row,13)=std(Data(:,10));
%++-
Mean_results_v5(Table_row,14)=mean(Data(:,11));
Mean_results_v5(Table_row,15)=std(Data(:,11));
%+-+
Mean_results_v5(Table_row,16)=mean(Data(:,12));
Mean_results_v5(Table_row,17)=std(Data(:,12));
%+--
Mean_results_v5(Table_row,18)=mean(Data(:,13));
Mean_results_v5(Table_row,19)=std(Data(:,13));
%-+-
Mean_results_v5(Table_row,20)=mean(Data(:,14));
Mean_results_v5(Table_row,21)=std(Data(:,14));

%% Mean ratio of number of bonds per monomer
%3 bonds
Mean_results_v5(Table_row,22)=mean(Data(:,15)./Data(:,1));
Mean_results_v5(Table_row,23)=std(Data(:,15)./Data(:,1));
%2 bonds
Mean_results_v5(Table_row,24)=mean(Data(:,16)./Data(:,1));
Mean_results_v5(Table_row,25)=std(Data(:,16)./Data(:,1));
%1 bonds
Mean_results_v5(Table_row,26)=mean(Data(:,17)./Data(:,1));
Mean_results_v5(Table_row,27)=std(Data(:,17)./Data(:,1));
%% Mean simulation time
Mean_results_v5(Table_row,28)=mean(Data(:,6));
Mean_results_v5(Table_row,29)=std(Data(:,6));
%% Mean nodes per layer
Mean_results_v5(Table_row,30)=mean(Data(:,20));%mean layers
Mean_results_v5(Table_row,31)=std(Data(:,20));
Mean_results_v5(Table_row,32)=mean(Data(:,19));%mean nodes per layer
Mean_results_v5(Table_row,33)=std(Data(:,19));
clear Data;