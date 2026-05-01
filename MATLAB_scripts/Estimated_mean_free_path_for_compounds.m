%% Mean free path calculations 
% estimating mean free path of a compound. 
% results not validated as accurate, use with caution
%Set the atomic percents (sum should be 1), and set the upper and lower
%density limits. 
% https://srdata.nist.gov/SRD64/Elastic
%% Atomic weights,  in kg per mol
Atomic_weight_carbon=12/1000; %atomic weight of element,
Atomic_weight_oxygen=16/1000; %atomic weight of element,
Atomic_weight_boron=10/1000; %atomic weight of element,
Atomic_weight_hydrogen=1/1000; %atomic weight of element,
%% Atomic percentage factors
Atomic_percent_carbon = 0.649;
Atomic_percent_oxygen = 0.054;
Atomic_percent_boron = 0.027;
Atomic_percent_hydrogen = 0.27;
total = Atomic_percent_hydrogen+Atomic_percent_boron+Atomic_percent_oxygen+Atomic_percent_carbon;
%% Elastic Scattering Cross sections, 80 keV, from NIST, in m^2

kV = 80;
cross_sec_carbon=(3.420123e-2)*(2.8001852e-21);
cross_sec_oxygen=(3.879368e-2)*(2.8001852e-21);
cross_sec_boron=(3.036695e-2)*(2.8001852e-21);
cross_sec_hydrogen=(1.546793e-3)*(2.8001852e-21);

%% Elastic Scattering Cross sections, 200 keV, from NIST
%{
kV = 200;
cross_sec_carbon=(1.78710e-2)*(2.8001852e-21);
cross_sec_oxygen=(2.029453e-2)*(2.8001852e-21);
cross_sec_boron=(1.586161e-2)*(2.8001852e-21);
cross_sec_hydrogen=(8.074338e-4)*(2.8001852e-21);
%}
%% Atomic approximations
carbon_approx = Atomic_percent_carbon*(Atomic_weight_carbon/cross_sec_carbon);
oxygen_approx = Atomic_percent_oxygen*(Atomic_weight_oxygen/cross_sec_oxygen);
boron_approx = Atomic_percent_boron*(Atomic_weight_boron/cross_sec_boron);
hydrogen_approx = Atomic_percent_hydrogen*(Atomic_weight_hydrogen/cross_sec_hydrogen);
%% Physical Constants
density_median=565;
density_lower_limit=density_median-100; %density of element, kg per m^-3
density_upper_limit=density_median+100; %density of element, kg per m^-3
Avogad=6.02214076e23; %Avogadro's number, in atoms per mol
Mean_free_path_approx_lower_m=(1/(Avogad*density_lower_limit))*(carbon_approx+oxygen_approx+boron_approx+hydrogen_approx);
Mean_free_path_approx_upper_m=(1/(Avogad*density_upper_limit))*(carbon_approx+oxygen_approx+boron_approx+hydrogen_approx); 
Mean_free_path_approx_median_m=(1/(Avogad*density_median))*(carbon_approx+oxygen_approx+boron_approx+hydrogen_approx);
Mean_free_path_approx_lower_nm=Mean_free_path_approx_lower_m*(10^9);
Mean_free_path_approx_upper_nm=Mean_free_path_approx_upper_m*(10^9);
Mean_free_path_approx_median_nm = Mean_free_path_approx_median_m*(10^9);
%% Results
Result = [num2str(kV),' kV: ','Lower density = ',num2str(Mean_free_path_approx_lower_nm), ' nm, ','Upper density = ',num2str(Mean_free_path_approx_upper_nm), ' nm, ','Median = ',num2str(Mean_free_path_approx_median_nm),' nm'];
disp(Result);