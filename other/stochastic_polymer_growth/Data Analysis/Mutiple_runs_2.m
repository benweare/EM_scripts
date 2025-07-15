%% Multiple Runs
%Runs the script n times and writes the output to a table
%number of times to run script
%% v6 runs
%% Run 1
Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.1;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_10_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 
%%
Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 500;
AdsorptionProbability = 0.2;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_20_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 
%%
Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.3;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_30_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

%%

Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.4;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_40_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

%%

Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.5;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_50_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

%% 

Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.6;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_60_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.7;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_70_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.8;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_80_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

%%

Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 1000;
AdsorptionProbability = 0.9;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_6.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all=MakeResultsTable(Results_all);
Results_1000_monomers_1000_repeats_90_abs_probability_Ads_v6 = Results_all;
clear numberRuns Results AdsorptionProbability 

%% End
disp("end");

function [Results_all]=MakeResultsTable(Results_all)
Results_all.Properties.VariableNames{1} = 'Monomers';
Results_all.Properties.VariableNames{2} = 'Covalency';
Results_all.Properties.VariableNames{3} = 'Total_possible_bonds';
Results_all.Properties.VariableNames{4} = 'Total_bonds';
Results_all.Properties.VariableNames{5} = 'Ratio_bonds_to_monomers';
Results_all.Properties.VariableNames{6} = 'Total_time_s';
Results_all.Properties.VariableNames{7} = 'nxnynz';
Results_all.Properties.VariableNames{8} = 'pxpypz';
Results_all.Properties.VariableNames{9} = 'nxpypz';
Results_all.Properties.VariableNames{10} = 'nxnypz';
Results_all.Properties.VariableNames{11} = 'pxpynz';
Results_all.Properties.VariableNames{12} = 'pxnypz';
Results_all.Properties.VariableNames{13} = 'pxnynz';
Results_all.Properties.VariableNames{14} = 'nxpynz';
Results_all.Properties.VariableNames{15} = 'One_Bond';
Results_all.Properties.VariableNames{16} = 'Two_Bond';
Results_all.Properties.VariableNames{17} = 'Three_Bond';
Results_all.Properties.VariableNames{18} = 'Ratio_AdsCov';
end

%% v1 runs
%% Run 1
%{
Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 5000;
covalency = 2;
plotting = 0;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_1.m")
Results_all(numberRuns,:) = Results(1,:);

end
%% Results table
Results_all.Properties.VariableNames{1} = 'Monomers';
Results_all.Properties.VariableNames{2} = 'Covalency';
Results_all.Properties.VariableNames{3} = 'Total_possible_bonds';
Results_all.Properties.VariableNames{4} = 'Total_bonds';
Results_all.Properties.VariableNames{5} = 'Ratio_bonds_to_monomers';
Results_all.Properties.VariableNames{6} = 'Total_time_s';
Results_all.Properties.VariableNames{7} = 'One_Bond';
Results_all.Properties.VariableNames{8} = 'Two_Bond';
Results_all.Properties.VariableNames{9} = 'Three_Bond';
Results_all.Properties.VariableNames{10} = 'Four_Bond';
Results_all.Properties.VariableNames{11} = 'Five_Bond';
Results_all.Properties.VariableNames{12} = 'Six_Bond';

Results_2_covalency_1000_repeats_5000_monomers = Results_all;
clear numberRuns loop_no


%% v5 runs
%% Run 1
Results_all = table;
for numberRuns = 1:1:1000
noMonomers = 5000;
RingProbability = 1;
StatisticalAnalysis = 1;
run("Monte_Carlo_2D_polymer_simulation_ver_5.m")
Results_all(numberRuns,:) = Results(1,:);
end
%% Results table
Results_all.Properties.VariableNames{1} = 'Monomers';
Results_all.Properties.VariableNames{2} = 'Covalency';
Results_all.Properties.VariableNames{3} = 'Total_possible_bonds';
Results_all.Properties.VariableNames{4} = 'Total_bonds';
Results_all.Properties.VariableNames{5} = 'Ratio_bonds_to_monomers';
Results_all.Properties.VariableNames{6} = 'Total_time_s';
Results_all.Properties.VariableNames{7} = '-x-y';
Results_all.Properties.VariableNames{8} = '+x+y';
Results_all.Properties.VariableNames{9} = '-x+y';
Results_all.Properties.VariableNames{10} = '+x-y';
Results_all.Properties.VariableNames{11} = 'One_Bond';
Results_all.Properties.VariableNames{12} = 'Two_Bond';
Results_all.Properties.VariableNames{13} = 'Three_Bond';
Results_5000_monomers_1000_repeats_100_probability_ring_closing = Results_all;
clear numberRuns Results
%}
