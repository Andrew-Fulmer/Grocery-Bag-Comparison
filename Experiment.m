classdef Experiment
    properties
        % Object Variables
        store                   % Name of store bag is from
        bagType                 % Bag Type (0 = paper, 1 = plastic)
        gripType                % Grip Type (0 = handle, 1 = side)
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
        function obj = Experiment(massAry,lengthAry, name, grip)
            %obj.store = name;
            obj.massAry = massAry;
            obj.lengthAry = lengthAry;
            obj.origLength = lengthAry(1);
            
            % Set aryLength
            obj.aryLength = calculateAryLength(obj);
            
            % Set massAry again 
            %obj.massAry = calculateMassAry(obj);
            
            % Set force values: force = 9.8 * mass
            obj.force = zeros(1,obj.aryLength);
            for i=1:obj.aryLength%length(obj.force)
                obj.force(i) = 9.8*massAry(i);
            end
            
            % Set stress values: stress = (Force)/(cross sectional area)
            obj.stress = zeros(1,obj.aryLength);
            for i=1:length(obj.stress)
                obj.stress(i) = obj.force(i)/obj.csArea;
            end
            
            %% Update massAry
            %obj.massAry = calculateMassAry(obj);

            % Set dldm
            obj.dldm = calcDwDm(obj);
            
            % Set totalDLDM
            obj.totalDLDM = calcTotalDLDM(obj);
            
            % Set strain
            obj.strain = calcStrain(obj);
            
            % Set values that are constant for each type of bag (width and thickness)
            switch name
                case 'Target'
                    obj.store = 'Target';
                    obj.thickness = 0.025;
                    obj.width = 285.75;
                case 'CVS'
                    obj.store = 'CVS';
                    obj.thickness = 0.0125;
                    obj.width = 266.7;
                case 'FoodLion'
                    obj.store = 'FoodLion';
                    obj.thickness = 0.015;
                    obj.width = 260.35;
                case 'WholeFoods'
                    obj.store = 'WholeFoods';
                    obj.thickness = 0.17;
                    obj.width = 301.625;
                    %obj.dldm = calcDwDm(obj);
                case 'TraderJoes'
                    obj.store = 'TraderJoes';
                    obj.thickness = 0.12;
                    obj.width = 304.8;
            end
            
            % Set gripType (0 = handle, 1 = side)
            switch grip
                case 'handle'
                    obj.gripType = 0;
                case 'side'
                    obj.gripType = 1;
            end
        end
        
        % Given an experiment, return the length of it's length array
        function aryLength = calculateAryLength(obj)
            count = 0;
            for i=1:length(obj.lengthAry)
                if (obj.lengthAry(i) == 0) 
                    %aryLength = i-1;
                    %return
                else
                    count = count + 1;
                end
            end
            aryLength = count;
            %aryLength = length(obj.lengthAry);
        end
        
        % Given an experiment, return the massArray
        function massAry = calculateMassAry(obj)
            count = 1;
            massAry = zeros(1:length(obj.aryLength));
            for i=1:length(obj.massAry)
                if (obj.lengthAry(i)~=0)
                    count = count + 1;
                    massAry(count) = obj.massAry(i);
                end
            end
            %massAry = obj.massAry(1:obj.aryLength);
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