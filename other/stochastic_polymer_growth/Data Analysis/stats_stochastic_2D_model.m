% gets some numerical info from the model
x=Results_2500m_rf_1000rpts;
%% Basic stats
Stats_results = table;
Stats_results.Var1=mean(x.Total_bonds);
Stats_results.Var2=2*std(x.Total_bonds);
Stats_results.Var3=median(x.Total_bonds);
Stats_results.Var4=max(x.Total_bonds);
Stats_results.Var5=min(x.Total_bonds);
Stats_results.Var6=mean(x.Ratio_bonds_to_monomers);
Stats_results.Var7=2*std(x.Ratio_bonds_to_monomers);
Stats_results.Var8=mean(x.Total_time_s);
Stats_results.Var9=2*std(x.Total_time_s,0); %sample standard deviation
%% Stats results table
Stats_results.Properties.VariableNames{1} = 'Mean_total_bonds';
Stats_results.Properties.VariableNames{2} = 'std_dv_mean_total_bonds';
Stats_results.Properties.VariableNames{3} = 'Median_total_bonds';
Stats_results.Properties.VariableNames{4} = 'Max_total_bonds';
Stats_results.Properties.VariableNames{5} = 'Min_total_bonds';
Stats_results.Properties.VariableNames{6} = 'Mean_ratio_bonds_to_monomers';
Stats_results.Properties.VariableNames{7} = 'std_dv_ratio';
Stats_results.Properties.VariableNames{8} = 'Mean_total_time';
Stats_results.Properties.VariableNames{9} = 'std_dv_time';

%% Time predictions
timePredict = 0;
if timePredict == 1
noMonomers = 100000;
predicted_time_s = 2.216e-06*(noMonomers)^2 + 3.531e-4*noMonomers - 4.658e-2
predicted_time_min = predicted_time_s/60
predicetd_time_min_1000 = predicted_time_min * 1000
predicetd_time_hour_1000 = (predicted_time_min/60)
predicetd_time_hour_1000 = (predicted_time_min/60)*1000
end

clear x timePredict