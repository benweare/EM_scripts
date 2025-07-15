%% Mean free path calculations 
tic;
%% Data
Atomic_weight=12/1000; %atomic weight of element, in kg per mol
Avogad=6.02214076e23; %Avogadro's number, in atoms per mol
density=(0.58002)*1000; %density of element, kg per m^-3
thicc=100;%sample thickness, in nm
cross_sec=(1.787180e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 200 keV
%cross_sec=(3.420123e-2)*(2.8001852e-21);%total atomic elastic scattering cross-section in m^2, from NIST, C 80 keV
%% For Loop Control
loop_no=1;
Thickness = zeros(length(loop_no),1);
Density = zeros(length(loop_no),1);
Mean_free_path_m = zeros(length(loop_no),1);
Mean_free_path_nm = zeros(length(loop_no),1);
Scattering_probability = zeros(length(loop_no),1);
Mass_thickness = zeros(length(loop_no),1);
for loop_no =1:4000
%% Defining parameters
%Choose whether to alter the density or thickness in each itertion
density = loop_no; 
%thicc = loop_no;

%% Calculating Mean Free path
mean_free_path_m=(Atomic_weight)/(Avogad*cross_sec*density);
mean_free_path_nm=mean_free_path_m*(10^9);

Thickness(loop_no)=thicc;
Density(loop_no)=density;
Mean_free_path_m(loop_no)=mean_free_path_m;
Mean_free_path_nm(loop_no)=mean_free_path_nm;
Scattering_probability(loop_no)=(thicc/mean_free_path_nm);
Mass_thickness(loop_no)=density*thicc;

end
%% Building Results Table
Thickness = Thickness.';
Density = Density.';
Mass_thickness=Mass_thickness.';
Mean_free_path_m = Mean_free_path_m.';
Mean_free_path_nm = Mean_free_path_nm.';
Scattering_probability = Scattering_probability.';
Results=table(Thickness, Density, Mass_thickness, Mean_free_path_m, Mean_free_path_nm, Scattering_probability);
Results.Properties.VariableNames{1} = 'Thickness';
Results.Properties.VariableNames{2} = 'Density';
Results.Properties.VariableNames{3} = 'Mass_thickness';
Results.Properties.VariableNames{4} = 'Mean_free_path_m';
Results.Properties.VariableNames{5} = 'Mean_free_path_nm';
Results.Properties.VariableNames{6} = 'Scattering_probability';
Mean_free_path_carbon_80keV_density=Results; %enter table name here
clear Mass_thickness Atomic_weight Avogad cross_sec density thicc Results Density loop_no Mean_free_path mean_free_path_m Mean_free_path_m mean_free_path_nm Mean_free_path_nm Scattering_probability Thickness;
%% Plot Results
%plot(Mean_free_path_carbon_200keV.Mean_free_path_nm, Mean_free_path_carbon_200keV.Density,'Color', 1/255*[255 0 0],'LineWidth',2);
%semilogy(Mean_free_path_carbon_200keV.Mean_free_path_nm, Mean_free_path_carbon_200keV.Density,'Color', 1/255*[255 0 0],'LineWidth',2);
%loglog(Mean_free_path_carbon_200keV.Mean_free_path_nm, Mean_free_path_carbon_200keV.Density,'Color', 1/255*[255 0 0],'LineWidth',2);
%plot(Mean_free_path_carbon_200keV.Density, Mean_free_path_carbon_200keV.Scattering_probability,'Color', 1/255*[255 0 0],'LineWidth',2);
%xlabel('Mean free path / nm','FontSize',36,'FontName','Calibri');
%ylabel('Density / kg m^-^3','FontSize',36,'FontName','Calibri');
%% Thickess versus probability plot
%plot(Mean_free_path_carbon_200keV_thickness.Thickness, Mean_free_path_carbon_200keV_thickness.Scattering_probability,'Color', 1/255*[255 0 0],'LineWidth',2);
%xlim([0,100])
ylim([0,1])
xlabel('Thickness / nm','FontSize',36,'FontName','Calibri');
ylabel('Scattering probaility','FontSize',36,'FontName','Calibri');
%%
set(gca,'FontName','Calibri')
set(gca, 'linewidth', 2);
set(gca, 'FontSize', 28);
set(gca,'TickDir','out');
set(0,'defaultfigurecolor',[1 1 1]);