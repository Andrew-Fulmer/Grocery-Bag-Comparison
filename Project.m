
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
% gripType                % Grip Type (0 = handle, 1 = side)
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

%% Initialize Raw Data

% massAry is the array of each mass put in the bags (intervals of .6)
massAry = [0 0.6 1.2 1.8 2.4 3 3.6 4.2 4.8 5.4 6 6.6 7.2 7.8 8.4 9 9.6 10.2 10.8 11.4];

% Array of lengths of each bag for each mass (mm) (multiplying by 25.4 to convert to mm)
% Plastic bags held by sides
tgSideLAry = 25.4*[11.5     11.625	11.75	11.875	12      12      12.125	12.25	12.25	12.375	12.5	12.5	12.5	12.625	12.625	12.625];
tgSideLAry2 = 25.4*[11.5	11.5	11.6875	11.6875	11.875	12      12      12.375	12.5	12.5625	12.5625	12.5625	12.5625	12.5625	12.875	12.875];
tgSideLAry3 = 25.4*[11.5	11.5	11.625	12.125	12.1875	12.1875	12.1875	12.25	12.375	12.5	12.5	12.75	12.75	12.75	12.75	12.75];
tgSideAvg = avgAry(tgSideLAry,tgSideLAry2,tgSideLAry3);
tgSideTotalLAry = [tgSideLAry(1:length(tgSideLAry)),tgSideLAry2(1:length(tgSideLAry2)),tgSideLAry3(1:length(tgSideLAry3))];
cvsSideLAry = 25.4*[9.125	9.375	9.5	9.625	9.625	9.625	9.75	9.875	9.875	9.875	9.875	9.875];
cvsSideLAry2 = 25.4*[9.125	9.25	9.625	9.8125	9.8125	9.8125	9.8125	9.9375	9.9375	9.9375	9.9375	9.9375];
cvsSideLAry3 = 25.4*[9.125	9.125	9.5	9.5625	9.5625	9.5625	9.625	10.0625	10.0625	10.0625	10.0625	10.0625];
cvsSideAvg = avgAry(cvsSideLAry,cvsSideLAry2,cvsSideLAry3);
cvsSideTotalLAry = [cvsSideLAry(1:length(cvsSideLAry)),cvsSideLAry2(1:length(cvsSideLAry2)),cvsSideLAry3(1:length(cvsSideLAry3))];
flSideLAry = 25.4*[13.375	13.375	13.5	13.5	13.625	13.625	13.75	13.875	14	14.125	14.25	14.25	14.375	14.5];
flSideLAry2 = 25.4*[13.375	13.5625	13.5625	13.5625	13.875	13.875	13.875	13.875	13.875	13.875	14.3125	14.5	14.5	14.625];
flSideLAry3 = 25.4*[13.375	13.4375	13.4375	13.625	13.625	13.625	13.6875	14.0625	14.0625	14.0625	14.3125	14.3125	14.625	14.625];
flSideAvg = avgAry(flSideLAry,flSideLAry2,flSideLAry3);
flSideTotalLAry = [flSideLAry(1:length(flSideLAry)),flSideLAry2(1:length(flSideLAry2)),flSideLAry3(1:length(flSideLAry3))];
% Plastic bags held by handles
tgHandLAry = 25.4*[17.325	17.75	18	18.125	18.125	18.25	18.25	18.375	18.375	18.5	18.5	18.5625	18.625	18.625	18.6875	18.75];
tgHandLAry2 = 25.4*[17.325	17.325	17.6875	18.0625	18.0625	18.4375	18.4375	18.4375	18.4375	18.5625	18.5625	18.6875	18.6875	18.6875	18.6875	18.6875];
tgHandLAry3 = 25.4*[17.325	17.9375	17.9375	17.9375	18.0625	18.4375	18.4375	18.4375	18.4375	18.75	18.75	18.75	18.75	18.75	18.75	18.75];
tgHandAvg = avgAry(tgHandLAry,tgHandLAry2,tgHandLAry3);
tgHandTotalLAry = [tgHandLAry(1:length(tgHandLAry)),tgHandLAry2(1:length(tgHandLAry2)),tgHandLAry3(1:length(tgHandLAry3))];
cvsHandLAry = 25.4*[14	14.25	14.375	14.625	14.75	14.875	14.875	15	15	15.25	15.5	15.625	15.625	15.75];
cvsHandLAry2 = 25.4*[14	14.4375	14.4375	14.4375	14.4375	14.5	14.6875	14.6875	14.6875	15.3125	15.3125	15.75	15.75	15.75];
cvsHandLAry3 = 25.4*[14	14.25	14.5	14.8125	15	15.1875	15.25	15.25	15.3125	15.3125	15.3125	15.4375	15.625	15.9375];
cvsHandAvg = avgAry(cvsHandLAry,cvsHandLAry2,cvsHandLAry3);
cvsHandTotalLAry = [cvsHandLAry(1:length(cvsHandLAry)),cvsHandLAry2(1:length(cvsHandLAry2)),cvsHandLAry3(1:length(cvsHandLAry3))];
flHandLAry = 25.4*[17	17	17.0625	17.0625	17.125	17.25	17.25	17.375	17.5	17.5	17.75];
flHandLAry2 = 25.4*[17	17.1625	17.0625	17.0625	17.0625	17.375	17.375	17.4375	17.625	17.625	18];
flHandLAry3 = 25.4*[17	17.25	17.25	17.25	17.25	17.25	17.4375	17.4375	17.6875	17.6875	17.6875];
flHandAvg = avgAry(flHandLAry,flHandLAry2,flHandLAry3);
flHandTotalLAry = [flHandLAry(1:length(flHandLAry)),flHandLAry2(1:length(flHandLAry2)),flHandLAry3(1:length(flHandLAry3))];
% Paper bags held by sides
wfSideLAry = 25.4*[14	14	14.125	14.125	14.375	14.375	14.5	14.625	14.875	14.875	14.875	15	15	15.15	15.25	15.375];
wfSideLAry2 = 25.4*[14	14.0875	14.375	14.375	14.375	14.375	14.4375	14.4375	14.5	14.625	14.625	15.0625	15.0625	15.0875	15.0875	15.5];
wfSideLAry3 = 25.4*[14	14.25	14.25	14.25	14.25	14.375	14.625	14.6875	14.6875	15	15	15	15.0625	15.275	15.275	15.4375];
wfSideAvg = avgAry(wfSideLAry,wfSideLAry2,wfSideLAry3);
wfSideTotalLAry = [wfSideLAry(1:length(wfSideLAry)),wfSideLAry2(1:length(wfSideLAry2)),wfSideLAry3(1:length(wfSideLAry3))];
wf1SideLAry = 25.4*[14	14	14.125	14.25	14.25	14.375	14.375	14.5	14.625	14.75	14.75	14.75	14.75	14.875	14.875	15];
wf1SideLAry2 = 25.4*[14	14	14.375	14.375	14.5	14.5	14.625	14.625	14.625	14.875	14.875	15	15	15	15	15.125];
wf1SideLAry3 = 25.4*[14	14	14.0625	14.375	14.375	14.375	14.5625	14.5625	14.875	14.875	14.875	14.875	14.875	14.875	14.875	14.9375];
wf1SideAvg = avgAry(wf1SideLAry,wf1SideLAry2,wf1SideLAry3);
wf1SideTotalLAry = [wf1SideLAry(1:length(wf1SideLAry)),wf1SideLAry2(1:length(wf1SideLAry2)),wf1SideLAry3(1:length(wf1SideLAry3))];
tjSideLAry = 25.4*[14	14	14.25	14.25	14.25	14.375	14.375	14.375	14.5	14.5	14.5	14.5	14.625	14.625	14.625	14.875];
tjSideLAry2 = 25.4*[14	14.25	14.25	14.25	14.25	14.5625	14.5625	14.5625	14.625	14.625	14.625	14.625	14.625	14.75	14.75	14.75];
tjSideLAry3 = 25.4*[14	14.125	14.125	14.25	14.5	14.5	14.5	14.625	14.75	14.75	14.75	14.75	14.75	14.875	14.875	15.125];
tjSideAvg = avgAry(tjSideLAry,tjSideLAry2,tjSideLAry3);
tjSideTotalLAry = [tjSideLAry(1:length(tjSideLAry)),tjSideLAry2(1:length(tjSideLAry2)),tjSideLAry3(1:length(tjSideLAry3))];
% Paper bags held by handles
wfHandLAry = 25.4*[17	17	17.125	17.25	17.375	17.5	17.5	17.625	17.625	17.75	17.75	17.875	18];
wfHandLAry2 = 25.4*[17	17	17.25	17.5	17.5	17.5	17.5625	17.5625	17.5625	17.9375	17.9375	17.9375	17.9375];
wfHandLAry3 = 25.4*[17	17	17.3125	17.3125	17.4375	17.4375	17.625	17.625	17.875	17.9375	17.9375	17.9375	17.9375];
wfHandAvg = avgAry(wfHandLAry,wfHandLAry2,wfHandLAry3);
wfHandTotalLAry = [wfHandLAry(1:length(wfHandLAry)),wfHandLAry2(1:length(wfHandLAry2)),wfHandLAry3(1:length(wfHandLAry3))];
wf1HandLAry = 25.4*[17	17	17.125	17.125	17.25	17.25	17.375	17.375	17.5	17.625	17.75	17.75	17.875];
wf1HandLAry2 = 25.4*[17	17	17	17.1875	17.1875	17.1875	17.1875	17.1875	17.5625	17.5625	18	18	18];
wf1HandLAry3 = 25.4*[17	17.1875	17.1875	17.1875	17.1875	17.5	17.5	17.5	17.5	17.625	17.9375	17.9375	18];
wf1HandAvg = avgAry(wf1HandLAry,wf1HandLAry2,wf1HandLAry3);
wf1HandTotalLAry = [wf1HandLAry(1:length(wf1HandLAry)),wf1HandLAry2(1:length(wf1HandLAry2)),wf1HandLAry3(1:length(wf1HandLAry3))];
tjHandLAry = 25.4*[17	17.125	17.125	17.25	17.25	17.375	17.375	17.375	17.5	17.5	17.5	17.5	17.625];
tjHandLAry2 = 25.4*[17	17	17.3125	17.375	17.375	17.375	17.375	17.5	17.625	17.625	17.625	17.625	17.6875];
tjHandLAry3 = 25.4*[17	17.3125	17.3125	17.3125	17.5	17.5	17.5	17.625	17.625	17.625	17.625	17.6875	17.6875];
tjHandAvg = avgAry(tjHandLAry,tjHandLAry2,tjHandLAry3);
tjHandTotalLAry = [tjHandLAry(1:length(tjHandLAry)),tjHandLAry2(1:length(tjHandLAry2)),tjHandLAry3(1:length(tjHandLAry3))];

%wfSideTotalLAry = [wfSideLAry(1:length(wfSideLAry)),wfSideLAry2(1:length(wfSideLAry)),wfSideLAry3(1:length(wfSideLAry3))];

%% Declare Experiments

% Initialize Target Side Experiment
tgSide = Experiment(massAry,tgSideLAry,'Target','side');
tgSide.breakingMass = 0;
tgSide2 = Experiment(massAry,tgSideLAry2,'Target','side');
tgSide2.breakingMass = 0;
tgSide3 = Experiment(massAry,tgSideLAry3,'Target','side');
tgSide3.breakingMass = 0;
% Initialize Target Average Side Experiment
tgSideAvg = Experiment(massAry,tgSideAvg,'Target','side');
% Initialize Target Side Experiment Total
tgSideTotal = Experiment([massAry,massAry,massAry],tgSideTotalLAry,'Target','side');
tgSideTotal.massAry = [massAry(1:tgSideTotal.aryLength/3),massAry(1:tgSideTotal.aryLength/3),massAry(1:tgSideTotal.aryLength/3)];

% Initialize CVS Side Experiment
cvsSide = Experiment(massAry,cvsSideLAry,'CVS','side');
cvsSide.breakingMass = 0;
cvsSide2 = Experiment(massAry,cvsSideLAry2,'CVS','side');
cvsSide2.breakingMass = 0;
cvsSide3 = Experiment(massAry,cvsSideLAry3,'CVS','side');
cvsSide3.breakingMass = 0;
% Initialize CVS Average Side Experiment
cvsSideAvg = Experiment(massAry,cvsSideAvg,'CVS','side');
% Initialize CVS Side Experiment Total
cvsSideTotal = Experiment([massAry,massAry,massAry],cvsSideTotalLAry,'CVS','side');
cvsSideTotal.massAry = [massAry(1:cvsSideTotal.aryLength/3),massAry(1:cvsSideTotal.aryLength/3),massAry(1:cvsSideTotal.aryLength/3)];

% Initialize Food Lion Side Experiment
flSide = Experiment(massAry,flSideLAry,'FoodLion','side');
flSide.breakingMass = 6;
flSide2 = Experiment(massAry,flSideLAry2,'FoodLion','side');
flSide2.breakingMass = 6;
flSide3 = Experiment(massAry,flSideLAry3,'FoodLion','side');
flSide3.breakingMass = 6;
% Initialize Food Lion Average Side Experiment
flSideAvg = Experiment(massAry,flSideAvg,'FoodLion','side');
% Initialize Food Lion Side Experiment Total
flSideTotal = Experiment([massAry,massAry,massAry],flSideTotalLAry,'FoodLion','side');
flSideTotal.massAry = [massAry(1:flSideTotal.aryLength/3),massAry(1:flSideTotal.aryLength/3),massAry(1:flSideTotal.aryLength/3)];

% Initialize Target Handle Experiment
tgHand = Experiment(massAry,tgHandLAry,'Target','handle');
tgHand.breakingMass = 0;
tgHand2 = Experiment(massAry,tgHandLAry2,'Target','handle');
tgHand2.breakingMass = 0;
tgHand3 = Experiment(massAry,tgHandLAry3,'Target','handle');
tgHand3.breakingMass = 0;
% Initialize Target Average Handle Experiment
tgHandAvg = Experiment(massAry,tgHandAvg,'Target','handle');
% Initialize Target Handle Experiment Total
tgHandTotal = Experiment([massAry,massAry,massAry],tgHandTotalLAry,'Target','handle');
tgHandTotal.massAry = [massAry(1:tgHandTotal.aryLength/3),massAry(1:tgHandTotal.aryLength/3),massAry(1:tgHandTotal.aryLength/3)];

% Initialize CVS Handle Experiment
cvsHand = Experiment(massAry,cvsHandLAry,'CVS','handle');
cvsHand.breakingMass = 15.5;
cvsHand2 = Experiment(massAry,cvsHandLAry3,'CVS','handle');
cvsHand2.breakingMass = 15.5;
cvsHand3 = Experiment(massAry,cvsHandLAry3,'CVS','handle');
cvsHand3.breakingMass = 15.5;
% Initialize CVS Average Handle Experiment
cvsHandAvg = Experiment(massAry,cvsHandAvg,'CVS','handle');
% Initialize CVS Handle Experiment Total
cvsHandTotal = Experiment([massAry,massAry,massAry],cvsHandTotalLAry,'CVS','handle');
cvsHandTotal.massAry = [massAry(1:cvsHandTotal.aryLength/3),massAry(1:cvsHandTotal.aryLength/3),massAry(1:cvsHandTotal.aryLength/3)];

% Initialize Food Lion Handle Experiments
flHand = Experiment(massAry,flHandLAry,'FoodLion','handle');
flHand.breakingMass = 6;
flHand2 = Experiment(massAry,flHandLAry2,'FoodLion','handle');
flHand2.breakingMass = 6;
flHand3 = Experiment(massAry,flHandLAry3,'FoodLion','handle');
flHand3.breakingMass = 6;
% Initialize Food Lion Average Handle Experiment
flHandAvg = Experiment(massAry,flHandAvg,'FoodLion','handle');
% Initialize Food Lion Handle Experiment Total
flHandTotal = Experiment([massAry,massAry,massAry],flHandTotalLAry,'FoodLion','handle');
flHandTotal.massAry = [massAry(1:flHandTotal.aryLength/3),massAry(1:flHandTotal.aryLength/3),massAry(1:flHandTotal.aryLength/3)];

% Initialize Whole Foods 0 Side Experiments
wfSide = Experiment(massAry,wfSideLAry,'WholeFoods','side');
wfSide.breakingMass = 6;
wfSide2 = Experiment(massAry,wfSideLAry2,'WholeFoods','side');
wfSide2.breakingMass = 6;
wfSide3 = Experiment(massAry,wfSideLAry3,'WholeFoods','side');
wfSide3.breakingMass = 6;
% Initialize Whole Foods Average Side Experiment
wfSideAvg = Experiment(massAry,wfSideAvg,'WholeFoods','side');
% Initialize Whole Foods 0 Side Experiment Total
wfSideTotal = Experiment([massAry,massAry,massAry],wfSideTotalLAry,'WholeFoods','side');
wfSideTotal.massAry = [massAry(1:wfSideTotal.aryLength/3),massAry(1:wfSideTotal.aryLength/3),massAry(1:wfSideTotal.aryLength/3)];

% Initialize Whole Foods 1 Side Experiments (the second group of 3)
wf1Side = Experiment(massAry,wf1SideLAry,'WholeFoods','side');
wf1Side.breakingMass = 6;
wf1Side2 = Experiment(massAry,wf1SideLAry2,'WholeFoods','side');
wf1Side2.breakingMass = 6;
wf1Side3 = Experiment(massAry,wf1SideLAry3,'WholeFoods','side');
wf1Side3.breakingMass = 6;
% Initialize Whole Foods 1 Average Side Experiment
wf1SideAvg = Experiment(massAry,wf1SideAvg,'WholeFoods','side');
% Initialize Whole Foods 1 Side Experiment Total
wf1SideTotal = Experiment([massAry,massAry,massAry],wf1SideTotalLAry,'WholeFoods','side');
wf1SideTotal.massAry = [massAry(1:wf1SideTotal.aryLength/3),massAry(1:wf1SideTotal.aryLength/3),massAry(1:wfSideTotal.aryLength/3)];

% Initialize Trader Joe's Side Experiments
tjSide = Experiment(massAry,tjSideLAry,'TraderJoes','side');
tjSide.breakingMass = 6;
tjSide2 = Experiment(massAry,tjSideLAry2,'TraderJoes','side');
tjSide2.breakingMass = 6;
tjSide3 = Experiment(massAry,tjSideLAry3,'TraderJoes','side');
tjSide3.breakingMass = 6;
% Initialize Trader Joe's Average Side Experiment
tjSideAvg = Experiment(massAry,tjSideAvg,'TraderJoes','side');
% Initialize Trader Joe's Side Experiment Total
tjSideTotal = Experiment([massAry,massAry,massAry],tjSideTotalLAry,'TraderJoes','side');
tjSideTotal.massAry = [massAry(1:tjSideTotal.aryLength/3),massAry(1:tjSideTotal.aryLength/3),massAry(1:tjSideTotal.aryLength/3)];

% Initialize Whole Foods 0 Handle Experiments
wfHand = Experiment(massAry,wfHandLAry,'WholeFoods','handle');
wfHand.breakingMass = 6;
wfHand2 = Experiment(massAry,wfHandLAry2,'WholeFoods','handle');
wfHand2.breakingMass = 6;
wfHand3 = Experiment(massAry,wfHandLAry3,'WholeFoods','handle');
wfHand3.breakingMass = 6;
% Initialize Whole Foods Average Handle Experiment
wfHandAvg = Experiment(massAry,wfHandAvg,'WholeFoods','handle');
% Initialize Whole Foods 0 Handle Experiment Total
wfHandTotal = Experiment([massAry,massAry,massAry],wfHandTotalLAry,'WholeFoods','handle');
wfHandTotal.massAry = [massAry(1:wfHandTotal.aryLength/3),massAry(1:wfHandTotal.aryLength/3),massAry(1:wfHandTotal.aryLength/3)];

% Initialize Whole Foods 1 Handle Experiment
wf1Hand = Experiment(massAry,wf1HandLAry,'WholeFoods','handle');
wf1Hand.breakingMass = 6;
wf1Hand2 = Experiment(massAry,wf1HandLAry2,'WholeFoods','handle');
wf1Hand2.breakingMass = 6;
wf1Hand3 = Experiment(massAry,wf1HandLAry3,'WholeFoods','handle');
wf1Hand3.breakingMass = 6;
% Initialize Whole Foods 1 Average Handle Experiment
wf1HandAvg = Experiment(massAry,wf1HandAvg,'WholeFoods','handle');
% Initialize Whole Foods 1 Handle Experiment Total
wf1HandTotal = Experiment([massAry,massAry,massAry],wf1HandTotalLAry,'WholeFoods','handle');
wf1HandTotal.massAry = [massAry(1:wf1HandTotal.aryLength/3),massAry(1:wf1HandTotal.aryLength/3),massAry(1:wf1HandTotal.aryLength/3)];

% Initialize Trader Joe's Handle Experiment
tjHand = Experiment(massAry,tjHandLAry,'TraderJoes','handle');
tjHand.breakingMass = 6;
tjHand2 = Experiment(massAry,tjHandLAry2,'TraderJoes','handle');
tjHand2.breakingMass = 6;
tjHand3 = Experiment(massAry,tjHandLAry3,'TraderJoes','handle');
tjHand3.breakingMass = 6;
% Initialize Trader Joe's Average Handle Experiment
tjHandAvg = Experiment(massAry,tjHandAvg,'TraderJoes','handle');
% Initialize Trader Joe's Handle Experiment Total
tjHandTotal = Experiment([massAry,massAry,massAry],tjHandTotalLAry,'TraderJoes','handle');
tjHandTotal.massAry = [massAry(1:tjHandTotal.aryLength/3),massAry(1:tjHandTotal.aryLength/3),massAry(1:tjHandTotal.aryLength/3)];


%% %%% Plots

%% Plot Full Length vs Mass
%&% Plot length averages holding by handles plastic vs paper 
figure(1)
plot(cvsHandAvg.massAry(1:cvsHandAvg.aryLength),cvsHandAvg.lengthAry(1:cvsHandAvg.aryLength), '-*')
hold on
plot(flHandAvg.massAry(1:flHandAvg.aryLength),flHandAvg.lengthAry(1:flHandAvg.aryLength), '-*')
hold on
plot(tgHandAvg.massAry(1:tgHandAvg.aryLength),tgHandAvg.lengthAry(1:tgHandAvg.aryLength), '-*')
hold on
plot(wfHandAvg.massAry(1:wfHandAvg.aryLength),wfHandAvg.lengthAry(1:wfHandAvg.aryLength), '-s')
hold on
plot(wf1HandAvg.massAry(1:wf1HandAvg.aryLength),wf1HandAvg.lengthAry(1:wf1HandAvg.aryLength), '-s')
hold on
plot(tjHandAvg.massAry(1:tjHandAvg.aryLength),tjHandAvg.lengthAry(1:tjHandAvg.aryLength), '-s')
hold on
title('Bag Length vs Mass in Bag Averages - Handles')
xlabel('Mass in Bag (kg)') 
ylabel('Length of Bag (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'eastoutside')
hold off


%&% Plot length averages holding by sides plastic vs paper 
figure(2)
plot(cvsSideAvg.massAry(1:cvsSideAvg.aryLength),cvsSideAvg.lengthAry(1:cvsSideAvg.aryLength), '-*')
hold on
plot(flSideAvg.massAry(1:flSideAvg.aryLength),flSideAvg.lengthAry(1:flSideAvg.aryLength), '-*')
hold on
plot(tgSideAvg.massAry(1:tgSideAvg.aryLength),tgSideAvg.lengthAry(1:tgSideAvg.aryLength), '-*')
hold on
plot(wfSideAvg.massAry(1:wfSideAvg.aryLength),wfSideAvg.lengthAry(1:wfSideAvg.aryLength), '-s')
hold on
plot(wf1SideAvg.massAry(1:wf1SideAvg.aryLength),wf1SideAvg.lengthAry(1:wf1SideAvg.aryLength), '-s')
hold on
plot(tjSideAvg.massAry(1:tjSideAvg.aryLength),tjSideAvg.lengthAry(1:tjSideAvg.aryLength), '-s')
hold on
title('Bag Length vs Mass in Bag Averages - Sides')
xlabel('Mass in Bag (kg)') 
ylabel('Length of Bag (mm)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'eastoutside')
hold off


%% Plot Change of length vs Mass

%&% Plot change of length over mass (averages) by handles plastic vs paper
figure(3)
plot(cvsHandAvg.massAry(1:cvsHandAvg.aryLength),cvsHandAvg.dldm(1:cvsHandAvg.aryLength), '-*')
hold on
plot(flHandAvg.massAry(1:flHandAvg.aryLength),flHandAvg.dldm(1:flHandAvg.aryLength), '-*')
hold on
plot(tgHandAvg.massAry(1:tgHandAvg.aryLength),tgHandAvg.dldm(1:tgHandAvg.aryLength), '-*')
hold on
plot(wfHandAvg.massAry(1:wfHandAvg.aryLength),wfHandAvg.dldm(1:wfHandAvg.aryLength), '-s')
hold on
plot(wf1HandAvg.massAry(1:wf1HandAvg.aryLength),wf1HandAvg.dldm(1:wf1HandAvg.aryLength), '-s')
hold on
plot(tjHandAvg.massAry(1:tjHandAvg.aryLength),tjHandAvg.dldm(1:tjHandAvg.aryLength), '-s')
hold on
title('Change in Mass vs Change in Length (Averages) - Handles')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1 cvs','Plastic2 fl','Plastic3 tg','Paper1 wf','Paper2 wf1','Paper3 tj'})
hold off

%&% Plot change of length over mass by sides plastic vs paper
figure(4)
plot(cvsSideAvg.massAry(1:cvsSideAvg.aryLength),cvsSideAvg.dldm(1:cvsSideAvg.aryLength), '-*')
hold on
plot(flSideAvg.massAry(1:flSideAvg.aryLength),flSideAvg.dldm(1:flSideAvg.aryLength), '-*')
hold on
plot(tgSideAvg.massAry(1:tgSideAvg.aryLength),tgSideAvg.dldm(1:tgSideAvg.aryLength), '-*')
hold on
plot(wfSideAvg.massAry(1:wfSideAvg.aryLength),wfSideAvg.dldm(1:wfSideAvg.aryLength), '-s')
hold on
plot(wf1SideAvg.massAry(1:wf1SideAvg.aryLength),wf1SideAvg.dldm(1:wf1SideAvg.aryLength), '-s')
hold on
plot(tjSideAvg.massAry(1:tjSideAvg.aryLength),tjSideAvg.dldm(1:tjSideAvg.aryLength), '-s')
hold on
title('Change in Mass vs Change in Length (Averages) - Sides')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1 cvs','Plastic2 fl','Plastic3 tg','Paper1 wf','Paper2 wf1','Paper3 tj'})
hold off


%% Plot Total change of length vs Mass

%&% Plot total change of length over mass by handles plastic vs paper (averages)
figure(5)
plot(cvsHandAvg.massAry(1:cvsHandAvg.aryLength),cvsHandAvg.totalDLDM(1:cvsHandAvg.aryLength), '-*')
hold on
plot(flHandAvg.massAry(1:flHandAvg.aryLength),flHandAvg.totalDLDM(1:flHandAvg.aryLength), '-*')
hold on
plot(tgHandAvg.massAry(1:tgHandAvg.aryLength),tgHandAvg.totalDLDM(1:tgHandAvg.aryLength), '-*')
hold on
plot(wfHandAvg.massAry(1:wfHandAvg.aryLength),wfHandAvg.totalDLDM(1:wfHandAvg.aryLength), '-s')
hold on
plot(wf1HandAvg.massAry(1:wf1HandAvg.aryLength),wf1HandAvg.totalDLDM(1:wf1HandAvg.aryLength), '-s')
hold on
plot(tjHandAvg.massAry(1:tjHandAvg.aryLength),tjHandAvg.totalDLDM(1:tjHandAvg.aryLength), '-s')
hold on
title('Change in Mass vs Total Change in Bag Length - Handles')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic1 cvs','Plastic2 fl','Plastic3 tg','Paper1 wf','Paper2 wf1','Paper3 tj'}, 'Location', 'northwest')
hold off

%&% Plot total change of length over mass by Handles Plastic
figure(6)
plotdldm(tgHandTotal,'r','s');
plotdldm(cvsHandTotal,'k','.');
plotdldm(flHandTotal,'b','x');
title('Change in Mass vs Total Change in Bag Length - Plastic Handles')
legend({'tg Best Fit','tg Data','cvs Best Fit','cvs Data','fl Best Fit', 'fl Data'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by Handles Paper
figure(7)
plotdldm(wfHandTotal,'r','s')
plotdldm(wf1HandTotal,'k','.');
plotdldm(tjHandTotal,'b','x');
title('Change in Mass vs Total Change in Bag Length - Paper Handles')
legend({'wf Best Fit','wf Data','wf1 Best Fit','wf1 Data','tj Best Fit', 'tj Data'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by sides plastic vs paper (averages)
figure(8)
plot(tgSideAvg.massAry(1:tgSideAvg.aryLength),tgSideAvg.totalDLDM(1:tgSideAvg.aryLength), '-*')
hold on
plot(cvsSideAvg.massAry(1:cvsSideAvg.aryLength),cvsSideAvg.totalDLDM(1:cvsSideAvg.aryLength), '-*')
hold on
plot(flSideAvg.massAry(1:flSideAvg.aryLength),flSideAvg.totalDLDM(1:flSideAvg.aryLength), '-*')
hold on
plot(wfSideAvg.massAry(1:wfSideAvg.aryLength),wfSideAvg.totalDLDM(1:wfSideAvg.aryLength), '-s')
hold on
plot(wf1SideAvg.massAry(1:wf1SideAvg.aryLength),wf1SideAvg.totalDLDM(1:wf1SideAvg.aryLength), '-s')
hold on
plot(tjSideAvg.massAry(1:tjSideAvg.aryLength),tjSideAvg.totalDLDM(1:tjSideAvg.aryLength), '-s')
hold on
title('Change in Mass vs Total Change in Bag Length - Sides')
xlabel('Change in Mass in Bag (kg)') 
ylabel('Change in Bag Length (mm)')
legend({'Plastic3-tg','Plastic1-cvs','Plastic2-fl','Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by Sides plastic
figure(9)
plotdldm(tgSideTotal,'r','s')
plotdldm(cvsSideTotal,'k','.');
plotdldm(flSideTotal,'b','x');
title('Change in Mass vs Total Change in Bag Length - Plastic Sides')
legend({'tg Best Fit','tg Data','cvs Best Fit','cvs Data','fl Best Fit', 'fl Data'}, 'Location', 'southeast')
hold off

%&% Plot total change of length over mass by Sides paper
figure(10)
plotdldm(wfSideTotal,'r','s');
plotdldm(wf1SideTotal,'k','.');
plotdldm(tjSideTotal,'b','x')
title('Change in Mass vs Total Change in Bag Length - Paper Sides')
legend({'wf Best Fit','wf Data','wf1 Best Fit','wf1 Data','tj Best Fit', 'tj Data'}, 'Location', 'southeast')
hold off


%% Plot Stress vs Strain

%&% Plot Stress vs Strain for plastic bags held from Handles
figure(11)
plot(cvsHandAvg.strain(1:cvsHandAvg.aryLength),cvsHandAvg.stress(1:cvsHandAvg.aryLength), '-*')
hold on
plot(flHandAvg.strain(1:flHandAvg.aryLength),flHandAvg.stress(1:flHandAvg.aryLength), '-*')
hold on
plot(tgHandAvg.strain(1:tgHandAvg.aryLength),tgHandAvg.stress(1:tgHandAvg.aryLength), '-*')
hold on
title('Strain vs Stress - Plastic Handles')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg'}, 'Location', 'southeast')
hold off

%&% Plot Stress vs Strain for paper bags held from Handles
figure(12)
plot(wfHandAvg.strain(1:wfHandAvg.aryLength),wfHandAvg.stress(1:wfHandAvg.aryLength), '-s')
hold on
plot(wf1HandAvg.strain(1:wf1HandAvg.aryLength),wf1HandAvg.stress(1:wf1HandAvg.aryLength), '-s')
hold on
plot(tjHandAvg.strain(1:tjHandAvg.aryLength),tjHandAvg.stress(1:tjHandAvg.aryLength), '-s')
hold on
title('Strain vs Stress - Paper Handles')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off

%&% Plot Stress vs Strain for plastic bags held from side
figure(13)
plot(cvsSideAvg.strain(1:cvsSideAvg.aryLength),cvsSideAvg.stress(1:cvsSideAvg.aryLength), '-*')
hold on
plot(flSideAvg.strain(1:flSideAvg.aryLength),flSideAvg.stress(1:flSideAvg.aryLength), '-*')
hold on
plot(tgSideAvg.strain(1:tgSideAvg.aryLength),tgSideAvg.stress(1:tgSideAvg.aryLength), '-*')
hold on
title('Strain vs Stress - Plastic Sides')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Plastic1-cvs','Plastic2-fl','Plastic3-tg'}, 'Location', 'southeast')
hold off

%&% Plot Stress vs Strain for paper bags held from side
figure(14)
plot(wfSideAvg.strain(1:wfSideAvg.aryLength),wfSideAvg.stress(1:wfSideAvg.aryLength), '-s')
hold on
plot(wf1SideAvg.strain(1:wf1SideAvg.aryLength),wf1SideAvg.stress(1:wf1SideAvg.aryLength), '-s')
hold on
plot(tjSideAvg.strain(1:tjSideAvg.aryLength),tjSideAvg.stress(1:tjSideAvg.aryLength), '-s')
hold on
title('Strain vs Stress - Paper Sides')
xlabel('Strain') 
ylabel('Stress (N/m^2)')
legend({'Paper1-wf','Paper2-wf1','Paper3-tj'}, 'Location', 'southeast')
hold off

%% Functions

% Given 3 arrays, compute the by element average of the arrays
function a = avgAry(a,b,c)
    ary = cat(3,a,b,c);
    a = mean(ary,3);
end