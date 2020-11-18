
%% Description
%-- Overall
% We used experimental data to model relationships between different
% factors such as Stress, Strain, Weight, material, and grip type with the
% strength of a bag

%-- Organization
% We created an object "Experiment" to store all of our data for each bag
% test we did. It has some self explanitory functions in it to calculate
% some of the variables. In this file, we initialize the data, declare
% Experiments, and plot different aspects of the experiments.

%-- Variables
% store                   % Name of store bag is from
% bagType                 % Bag Type (0 = paper, 1 = plastic)
% gripType                % Grip Type (0 = handle, 1 = no handle)
% thickness               % Thickness of bag (mm)
% breakingMass            % mass where bag breaks (kg) (0 if bag doesn't break)
% width                   % Width of bag (mm)
% origLength              % Height of bag (mm)
% massAry = []            % Array of the masss applied to the bag (kg)
% lengthAry = []          % Array of the lengths of the bag at each mass (mm)
% aryLength               % Length of the nonzero values in lengthAry
% dldm = []               % Change of length per change of mass
% totalDLDM = []          % Total change of length up until that point per change of mass
% force = []              % Force array at each mass (N)
% stress = []             % Stress values (N/(mm^2))
% strain = []             % Strain values
% csArea = 1.2398375      % Cross sectional area of the container inside bags is constant 1.2398375 m
% humidity = .87          % Humidity is constant 87%

%-- Notes
% Paper bags are always plotted with squares, and plastic with stars

%% Clear Everything

clear       % clears all variables from workspace
close all   % closes all open figures
clc         % clears command window

%% Initialize Variables

% massAry is the array of each mass put in the bags (intervals of .6)
massAry = [0	0.6	1.2	1.8	2.4	3	3.6	4.2	4.8	5.4	6	6.6	7.2	7.8	8.4	9	9.6	10.2	10.8	11.4];

% Array of lengths of each bag for each mass (mm) (multiplying by 25.4 to convert to mm)
% Plastic bags held by sides
tgSideLAry = 25.4*[11.5	11.625	11.75	11.875	12	12	12.125	12.25	12.25	12.375	12.5	12.5	12.5	12.625	12.625	12.625	0	0	0	0];
cvsSideLAry = 25.4*[9.125	9.375	9.5	9.625	9.625	9.625	9.75	9.875	9.875	9.875	9.875	9.875	0	0	0	0	0	0	0	0];
flSideLAry = 25.4*[13.375	13.375	13.5	13.5	13.625	13.625	13.75	13.875	14	14.125	14.25	14.25	14.375	14.5	0	0	0	0	0	0];
% Plastic bags held by handles
tgHandLAry = 25.4*[17.325	17.75	18	18.125	18.125	18.25	18.25	18.375	18.375	18.5	18.5	18.5625	18.625	18.625	18.6875	18.75	0	0	0	0];
cvsHandLAry = 25.4*[14	14.25	14.375	14.625	14.75	14.875	14.875	15	15	15.25	15.5	15.625	15.625	15.75	0	0	0	0	0	0];
flHandLAry = 25.4*[17	17	17	17	17.125	17.25	17.25	17.375	17.5	17.5	17.75	0	0	0	0	0	0	0	0	0];
% Paper bags held by sides
wfSideLAry = 25.4*[14	14	14.125	14.125	14.375	14.375	14.5	14.625	14.875	14.875	14.875	15	15	15.15	15.25	15.375	0	0	0	0];
wf1SideLAry = 25.4*[14	14	14.125	14.25	14.25	14.375	14.375	14.5	14.625	14.75	14.75	14.75	14.75	14.875	14.875	15	0	0	0	0];
tjSideLAry = 25.4*[14	14	14.25	14.25	14.25	14.375	14.375	14.375	14.5	14.5	14.5	14.5	14.625	14.625	14.625	14.875	0	0	0	0];
% Paper bags held by handles
wfHandLAry = 25.4*[17	17	17.125	17.25	17.375	17.5	17.5	17.625	17.625	17.75	17.75	17.875	18	0	0	0	0	0	0	0];
wf1HandLAry = 25.4*[17	17	17.125	17.125	17.25	17.25	17.375	17.375	17.5	17.625	17.75	17.75	17.875	0	0	0	0	0	0	0];
tjHandLAry = 25.4*[17	17.125	17.125	17.25	17.25	17.375	17.375	17.375	17.5	17.5	17.5	17.5	17.625	0	0	0	0	0	0	0];


%% Declare Experiments

% Initialize target Side Experiment
tgSide = Experiment(massAry,tgSideLAry);
tgSide.store = 'target';
tgSide.gripType = 1;
tgSide.thickness = 0.025;
tgSide.breakingMass = 0;
tgSide.width = 285.75;
tgSide.aryLength = tgSide.calculateAryLength;
tgSide.dldm = calcDwDm(tgSide);
tgSide.totalDLDM = calcTotalDLDM(tgSide);
tgSide.strain = calcStrain(tgSide);

% Initialize CVS Side Experiment
cvsSide = Experiment(massAry,cvsSideLAry);
cvsSide.store = 'CVS';
cvsSide.gripType = 1;
cvsSide.thickness = 0.0125;
cvsSide.breakingMass = 0;
cvsSide.width = 266.7;
cvsSide.aryLength = cvsSide.calculateAryLength;
cvsSide.dldm = calcDwDm(cvsSide);
cvsSide.totalDLDM = calcTotalDLDM(cvsSide);
cvsSide.strain = calcStrain(cvsSide);

% Initialize Food Lion Side Experiment
flSide = Experiment(massAry,flSideLAry);
flSide.store = 'FoodLion';
flSide.gripType = 0;
flSide.thickness = 0.015;
flSide.breakingMass = 6;
flSide.width = 260.35;
flSide.aryLength = flSide.calculateAryLength;
flSide.dldm = calcDwDm(flSide);
flSide.totalDLDM = calcTotalDLDM(flSide);
flSide.strain = calcStrain(flSide);

% Initialize tget Handle Experiment
tgHand = Experiment(massAry,tgHandLAry);
tgHand.store = 'target';
tgHand.gripType = 0;
tgHand.thickness = 0.025;
tgHand.breakingMass = 0;
tgHand.width = 285.75;
tgHand.aryLength = tgHand.calculateAryLength;
tgHand.dldm = calcDwDm(tgHand);
tgHand.totalDLDM = calcTotalDLDM(tgHand);
tgHand.strain = calcStrain(tgHand);

% Initialize CVS Handle Experiment
cvsHand = Experiment(massAry,cvsHandLAry);
cvsHand.store = 'CVS';
cvsHand.gripType = 0;
cvsHand.thickness = 0.0125;
cvsHand.breakingMass = 15.5;
cvsHand.width = 266.7;
cvsHand.aryLength = cvsHand.calculateAryLength;
cvsHand.dldm = calcDwDm(cvsHand);
cvsHand.totalDLDM = calcTotalDLDM(cvsHand);
cvsHand.strain = calcStrain(cvsHand);

% Initialize Food Lion Handle Experiment
flHand = Experiment(massAry,flHandLAry);
flHand.store = 'FoodLion';
flHand.gripType = 0;
flHand.thickness = 0.015;
flHand.breakingMass = 6;
flHand.width = 260.35;
flHand.aryLength = flHand.calculateAryLength;
flHand.dldm = calcDwDm(flHand);
flHand.totalDLDM = calcTotalDLDM(flHand);
flHand.strain = calcStrain(flHand);

% Initialize Whole Foods Side Experiment 0
wfSide = Experiment(massAry,wfSideLAry);
wfSide.store = 'WholeFoods';
wfSide.gripType = 0;
wfSide.thickness = 0.17;
wfSide.breakingMass = 6;
wfSide.width = 301.625;
wfSide.aryLength = wfSide.calculateAryLength;
wfSide.dldm = calcDwDm(wfSide);
wfSide.totalDLDM = calcTotalDLDM(wfSide);
wfSide.strain = calcStrain(wfSide);

% Initialize Whole Foods Side Experiment 1
wf1Side = Experiment(massAry,wf1SideLAry);
wf1Side.store = 'WholeFoods';
wf1Side.gripType = 0;
wf1Side.thickness = 0.17;
wf1Side.breakingMass = 6;
wf1Side.width = 301.625;
wf1Side.aryLength = wf1Side.calculateAryLength;
wf1Side.dldm = calcDwDm(wf1Side);
wf1Side.totalDLDM = calcTotalDLDM(wf1Side);
wf1Side.strain = calcStrain(wf1Side);

% Initialize Trader Joe's Side Experiment
tjSide = Experiment(massAry,tjSideLAry);
tjSide.store = 'TraderJoes';
tjSide.gripType = 0;
tjSide.thickness = 0.12;
tjSide.breakingMass = 6;
tjSide.width = 304.8;
tjSide.aryLength = tjSide.calculateAryLength;
tjSide.dldm = calcDwDm(tjSide);
tjSide.totalDLDM = calcTotalDLDM(tjSide);
tjSide.strain = calcStrain(tjSide);

% Initialize Whole Foods Handle Experiment 0
wfHand = Experiment(massAry,wfHandLAry);
wfHand.store = 'WholeFoods';
wfHand.gripType = 0;
wfHand.thickness = 0.17;
wfHand.breakingMass = 6;
wfHand.width = 301.625;
wfHand.aryLength = wfHand.calculateAryLength;
wfHand.dldm = calcDwDm(wfHand);
wfHand.totalDLDM = calcTotalDLDM(wfHand);
wfHand.strain = calcStrain(wfHand);

% Initialize Whole Foods Handle Experiment 1
wf1Hand = Experiment(massAry,wf1HandLAry);
wf1Hand.store = 'WholeFoods';
wf1Hand.gripType = 0;
wf1Hand.thickness = 0.17;
wf1Hand.breakingMass = 6;
wf1Hand.width = 301.625;
wf1Hand.aryLength = wf1Hand.calculateAryLength;
wf1Hand.dldm = calcDwDm(wf1Hand);
wf1Hand.totalDLDM = calcTotalDLDM(wf1Hand);
wf1Hand.strain = calcStrain(wf1Hand);

% Initialize Trader Joe's Handle Experiment
tjHand = Experiment(massAry,tjHandLAry);
tjHand.store = 'TraderJoes';
tjHand.gripType = 0;
tjHand.thickness = 0.12;
tjHand.breakingMass = 6;
tjHand.width = 304.8;
tjHand.aryLength = tjHand.calculateAryLength;
tjHand.dldm = calcDwDm(tjHand);
tjHand.totalDLDM = calcTotalDLDM(tjHand);
tjHand.strain = calcStrain(tjHand);


clearvars -except tgSide cvsSide flSide tgHand cvsHand flHand wfSide wf1Side tjSide wfHand wf1Hand tjHand


%% %%% Plots

%% Plot Full Length vs Mass
%&% Plot length holding by handles plastic vs paper 
figure(1)
plot(cvsHand.massAry(1:cvsHand.aryLength),cvsHand.lengthAry(1:cvsHand.aryLength), '-*')
hold on
plot(flHand.massAry(1:flHand.aryLength),flHand.lengthAry(1:flHand.aryLength), '-*')
hold on
plot(tgHand.massAry(1:tgHand.aryLength),tgHand.lengthAry(1:tgHand.aryLength), '-*')
hold on
plot(wfHand.massAry(1:wfHand.aryLength),wfHand.lengthAry(1:wfHand.aryLength), '-s')
hold on
plot(wf1Hand.massAry(1:wf1Hand.aryLength),wf1Hand.lengthAry(1:wf1Hand.aryLength), '-s')
hold on
plot(tjHand.massAry(1:tjHand.aryLength),tjHand.lengthAry(1:tjHand.aryLength), '-s')
hold on
title('Bag Length vs Mass in Bag - Handles')
xlabel('Mass in Bag (kg)') 
ylabel('Length of Bag (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'eastoutside')
hold off

%&% Plot length holding by sides plastic vs paper 
figure(2)
plot(cvsSide.massAry(1:cvsSide.aryLength),cvsSide.lengthAry(1:cvsSide.aryLength), '-*')
hold on
plot(flSide.massAry(1:flSide.aryLength),flSide.lengthAry(1:flSide.aryLength), '-*')
hold on
plot(tgSide.massAry(1:tgSide.aryLength),tgSide.lengthAry(1:tgSide.aryLength), '-*')
hold on
plot(wfSide.massAry(1:wfSide.aryLength),wfSide.lengthAry(1:wfSide.aryLength), '-s')
hold on
plot(wf1Side.massAry(1:wf1Side.aryLength),wf1Side.lengthAry(1:wf1Side.aryLength), '-s')
hold on
plot(tjSide.massAry(1:tjSide.aryLength),tjSide.lengthAry(1:tjSide.aryLength), '-s')
hold on
title('Bag Length vs Mass in Bag - Sides')
xlabel('Mass in Bag (kg)') 
ylabel('Length of Bag (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'eastoutside')
hold off


%% Plot Change of length vs Mass

%&% Plot change of length over mass by handles plastic vs paper
figure(3)
plot(cvsHand.massAry(1:cvsHand.aryLength),cvsHand.dldm(1:cvsHand.aryLength), '-*')
hold on
plot(flHand.massAry(1:flHand.aryLength),flHand.dldm(1:flHand.aryLength), '-*')
hold on
plot(tgHand.massAry(1:tgHand.aryLength),tgHand.dldm(1:tgHand.aryLength), '-*')
hold on
plot(wfHand.massAry(1:wfHand.aryLength),wfHand.dldm(1:wfHand.aryLength), '-s')
hold on
plot(wf1Hand.massAry(1:wf1Hand.aryLength),wf1Hand.dldm(1:wf1Hand.aryLength), '-s')
hold on
plot(tjHand.massAry(1:tjHand.aryLength),tjHand.dldm(1:tjHand.aryLength), '-s')
hold on
title('Change in Mass vs Change in Length - Handles')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'})
hold off

%&% Plot change of length over mass by sides plastic vs paper
figure(4)
plot(cvsSide.massAry(1:cvsSide.aryLength),cvsSide.dldm(1:cvsSide.aryLength), '-*')
hold on
plot(flSide.massAry(1:flSide.aryLength),flSide.dldm(1:flSide.aryLength), '-*')
hold on
plot(tgSide.massAry(1:tgSide.aryLength),tgSide.dldm(1:tgSide.aryLength), '-*')
hold on
plot(wfSide.massAry(1:wfSide.aryLength),wfSide.dldm(1:wfSide.aryLength), '-s')
hold on
plot(wf1Side.massAry(1:wf1Side.aryLength),wf1Side.dldm(1:wf1Side.aryLength), '-s')
hold on
plot(tjSide.massAry(1:tjSide.aryLength),tjSide.dldm(1:tjSide.aryLength), '-s')
hold on
title('Change in Mass vs Change in Length - Sides')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'})
hold off


%% Plot Total change of length vs Mass

%&% Plot total change of length over mass by handles plastic vs paper
figure(5)
plot(cvsHand.massAry(1:cvsHand.aryLength),cvsHand.totalDLDM(1:cvsHand.aryLength), '-*')
hold on
plot(flHand.massAry(1:flHand.aryLength),flHand.totalDLDM(1:flHand.aryLength), '-*')
hold on
plot(tgHand.massAry(1:tgHand.aryLength),tgHand.totalDLDM(1:tgHand.aryLength), '-*')
hold on
plot(wfHand.massAry(1:wfHand.aryLength),wfHand.totalDLDM(1:wfHand.aryLength), '-s')
hold on
plot(wf1Hand.massAry(1:wf1Hand.aryLength),wf1Hand.totalDLDM(1:wf1Hand.aryLength), '-s')
hold on
plot(tjHand.massAry(1:tjHand.aryLength),tjHand.totalDLDM(1:tjHand.aryLength), '-s')
hold on
title('Change in Mass vs Total Change in Bag Length - Handles')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'northwest')
hold off

%&% Plot total change of length over mass by handles plastic
figure(6)
plot(cvsHand.massAry(1:cvsHand.aryLength),cvsHand.totalDLDM(1:cvsHand.aryLength), '-*')
hold on
plot(flHand.massAry(1:flHand.aryLength),flHand.totalDLDM(1:flHand.aryLength), '-*')
hold on
plot(tgHand.massAry(1:tgHand.aryLength),tgHand.totalDLDM(1:tgHand.aryLength), '-*')
hold on
title('Change in Mass vs Total Change in Bag Length - Plastic Handles')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by handles paper
figure(7)
plot(wfHand.massAry(1:wfHand.aryLength),wfHand.totalDLDM(1:wfHand.aryLength), '-s')
hold on
plot(wf1Hand.massAry(1:wf1Hand.aryLength),wf1Hand.totalDLDM(1:wf1Hand.aryLength), '-s')
hold on
plot(tjHand.massAry(1:tjHand.aryLength),tjHand.totalDLDM(1:tjHand.aryLength), '-s')
hold on
title('Change in Mass vs Total Change in Bag Length - Paper Handles')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off


%&% Plot total change of length over mass by sides plastic vs paper
figure(8)
plot(cvsSide.massAry(1:cvsSide.aryLength),cvsSide.totalDLDM(1:cvsSide.aryLength), '-*')
hold on
plot(flSide.massAry(1:flSide.aryLength),flSide.totalDLDM(1:flSide.aryLength), '-*')
hold on
plot(tgSide.massAry(1:tgSide.aryLength),tgSide.totalDLDM(1:tgSide.aryLength), '-*')
hold on
plot(wfSide.massAry(1:wfSide.aryLength),wfSide.totalDLDM(1:wfSide.aryLength), '-s')
hold on
plot(wf1Side.massAry(1:wf1Side.aryLength),wf1Side.totalDLDM(1:wf1Side.aryLength), '-s')
hold on
plot(tjSide.massAry(1:tjSide.aryLength),tjSide.totalDLDM(1:tjSide.aryLength), '-s')
hold on
title('Change in Mass vs Total Change in Bag Length - Sides')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by Sides plastic
figure(9)
plot(cvsSide.massAry(1:cvsSide.aryLength),cvsSide.totalDLDM(1:cvsSide.aryLength), '-*')
hold on
plot(flSide.massAry(1:flSide.aryLength),flSide.totalDLDM(1:flSide.aryLength), '-*')
hold on
plot(tgSide.massAry(1:tgSide.aryLength),tgSide.totalDLDM(1:tgSide.aryLength), '-*')
hold on
title('Change in Mass vs Total Change in Bag Length - Plastic Sides')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by Sides paper
figure(10)
plot(wfSide.massAry(1:wfSide.aryLength),wfSide.totalDLDM(1:wfSide.aryLength), '-s')
hold on
plot(wf1Side.massAry(1:wf1Side.aryLength),wf1Side.totalDLDM(1:wf1Side.aryLength), '-s')
hold on
plot(tjSide.massAry(1:tjSide.aryLength),tjSide.totalDLDM(1:tjSide.aryLength), '-s')
hold on
title('Change in Mass vs Total Change in Bag Length - Paper Sides')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off


%% Plot Stress vs Strain

%&% Plot Stress vs Strain for plastic bags held from Handles
figure(11)
plot(cvsHand.strain(1:cvsHand.aryLength),cvsHand.stress(1:cvsHand.aryLength), '-*')
hold on
plot(flHand.strain(1:flHand.aryLength),flHand.stress(1:flHand.aryLength), '-*')
hold on
plot(tgHand.strain(1:tgHand.aryLength),tgHand.stress(1:tgHand.aryLength), '-*')
hold on
title('Strain vs Stress - Plastic Handles')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg'}, 'Location', 'southeast')
hold off

%&% Plot Stress vs Strain for paper bags held from Handles
figure(12)
plot(wfHand.strain(1:wfHand.aryLength),wfHand.stress(1:wfHand.aryLength), '-s')
hold on
plot(wf1Hand.strain(1:wf1Hand.aryLength),wf1Hand.stress(1:wf1Hand.aryLength), '-s')
hold on
plot(tjHand.strain(1:tjHand.aryLength),tjHand.stress(1:tjHand.aryLength), '-s')
hold on
title('Strain vs Stress - Paper Handles')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off

%&% Plot Stress vs Strain for plastic bags held from side
figure(13)
plot(cvsSide.strain(1:cvsSide.aryLength),cvsSide.stress(1:cvsSide.aryLength), '-*')
hold on
plot(flSide.strain(1:flSide.aryLength),flSide.stress(1:flSide.aryLength), '-*')
hold on
plot(tgSide.strain(1:tgSide.aryLength),tgSide.stress(1:tgSide.aryLength), '-*')
hold on
title('Strain vs Stress - Plastic Sides')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg'}, 'Location', 'southeast')
hold off

%&% Plot Stress vs Strain for paper bags held from side
figure(14)
plot(wfSide.strain(1:wfSide.aryLength),wfSide.stress(1:wfSide.aryLength), '-s')
hold on
plot(wf1Side.strain(1:wf1Side.aryLength),wf1Side.stress(1:wf1Side.aryLength), '-s')
hold on
plot(tjSide.strain(1:tjSide.aryLength),tjSide.stress(1:tjSide.aryLength), '-s')
hold on
title('Strain vs Stress - Paper Sides')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off


%% Functions

%Return a new array that is 3 arrays appended together
function newArray = appendArrays(a1, a2, a3)
    newArray = zeros(1,length(a1)+length(a2)+length(a3));
    % Add first array to newArray
    for j = 1:length(a1)
        newArray(j) = a1(j);
    end
    % Add second array to newArray
    for j = 1:length(a2)
        newArray(j + length(a1)) = a2(j);
    end
    % Add third array to newArray
    for j = 1:length(a3)
        newArray(j + length(a1) + length(a2)) = a3(j);
    end
end

% Return a new array that is the input repeated 3 times
function newArray = tripleArray(a)
    newArray = zeros(1,length(a)*3);
    for i = 1:3
        % Add each array to newArray (each meaning the singular array)
        for j = 1:length(a)
            newArray((i-1)*j + j) = a(j);
        end
    end
end
