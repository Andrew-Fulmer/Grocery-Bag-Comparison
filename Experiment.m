classdef Experiment
    properties
        % Object Variables
        store                   % Name of store bag is from
        bagType                 % Bag Type (0 = paper, 1 = plastic)
        gripType                % Grip Type (0 = handle, 1 = no handle)
        thickness               % Thickness of bag (mm)
        breakingMass            % mass where bag breaks (kg) (0 if bag doesn't break)
        width                   % Width of bag (mm)
        origLength              % Height of bag (mm)
        massAry = []            % Array of the masss applied to the bag (kg)
        lengthAry = []          % Array of the lengths of the bag at each mass (mm)
        aryLength               % Length of the nonzero values in lengthAry
        dldm = []               % Change of length per change of mass
        totalDLDM = []          % Total change of length up until that point per change of mass
        force = []              % Force array at each mass (N)
        stress = []             % Stress values (N/(mm^2))
        strain = []             % Strain values
        
        % Object Constants
        csArea = 1.2398375      % Cross sectional area of the container inside bags is constant 1.2398375 m
        humidity = .87          % Humidity is constant 87%
    end
    
    methods
        % Initialize Experiment
        function obj = Experiment(massAry,lengthAry)
            obj.massAry = massAry;
            obj.lengthAry = lengthAry;
            obj.origLength = lengthAry(1);
            
            % Set force values: force = 9.8 * mass
            obj.force = zeros(1,length(lengthAry));
            for i=1:length(obj.force)
                obj.force(i) = 9.8*massAry(i);
            end
            
            % Set stress values: stress = (Force)/(cross sectional area)
            obj.stress = zeros(1,length(lengthAry));
            for i=1:length(obj.stress)
                obj.stress(i) = obj.force(i)/obj.csArea;
            end
        end
        
        
        % Given an experiment, return the length of it's length array
        function aryLength = calculateAryLength(obj)
            for i=1:length(obj.lengthAry)
                if (obj.lengthAry(i) == 0) 
                    aryLength = i-1;
                    return
                end
            end
            aryLength = length(obj.lengthAry);
        end
        
        
        % Calculate change of length over change of mass for each mass
        function dldm = calcDwDm(obj)
            dldm = zeros(1,obj.aryLength);
            dldm(1) = 0;
            for i=1:obj.aryLength-1
                dldm(i+1) = obj.lengthAry(i+1)-obj.lengthAry(i);
            end
        end
        
        
        % Calculate total change in length over time for each mass
        function totalDLDM = calcTotalDLDM(obj)
            totalDLDM = obj.dldm;
            for i=1:obj.aryLength-1
                totalDLDM(i+1) = totalDLDM(i) + totalDLDM(i+1);
            end
        end
        
        
        % Calculate strain: strain = (dldt)/(initial length)
        function strain = calcStrain(obj)
            strain = zeros(1,obj.aryLength);
            for i=1:obj.aryLength
                strain(i) = obj.totalDLDM(i)/obj.origLength;
            end
        end
    end
end