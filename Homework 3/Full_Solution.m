clear; close all;

% Initial guess
% Random
% x0 = ones(10,1).*rand(10,1) + 0.1;

x0 = ones(10,1);

%% Part 1: Get the Derivatives

% Finite-Differencing
J = getJacobian(@truss,x0,...
                'Method','Finite-Difference');
df.Finite_Difference = J(1).output;
time.Objective_Finite_Difference = J(3).output;

J = getJacobian(@trusscon,x0,...
                'Method','Finite-Difference');
dg.Finite_Difference = J(1).output;
time.Constraint_Finite_Difference = J(3).output;

% Complex-Step
J = getJacobian(@truss,x0,...
                'Method','Complex-Step');
df.Complex_Step = J(1).output;
time.Objective_Complex_Step = J(3).output;

J = getJacobian(@trusscon,x0,...
                'Method','Complex-Step');
dg.Complex_Step = J(1).output;
time.Constraint_Complex_Step = J(3).output;

% Algorithmic Differentiation
J = getJacobian(@truss,x0,...
                'Method','AD');
df.AD = J(1).output;
time.Objective_AD = J(3).output;

J = getJacobian(@trusscon,x0,...
                'Method','AD');
dg.AD = J(1).output;
time.Constraint_AD = J(3).output

%% Comparing the various methods
% Let's do an average percent error relative to each actual derivative

% Comparing the objectives
objectiveComparison.Finite_Difference_rel_Complex_Step = ...
    compareDerivatives(df.Complex_Step,df.Finite_Difference);
objectiveComparison.AD_rel_Complex_Step = ...
    compareDerivatives(df.Complex_Step,df.AD);

% Comparing the constraints
constraintComparison.Finite_Difference_rel_Complex_Step = ...
    compareDerivatives(dg.Complex_Step,dg.Finite_Difference);
constraintComparison.AD_rel_Complex_Step = ...
    compareDerivatives(dg.Complex_Step,dg.AD);

% Creating a table
comparison = table();
comparison.Type_of_Difference(1) = "RMS";
comparison.Type_of_Difference(2) = "RMS Percent";

% Objective: Finite Difference
comparison.Objective_Finite_Difference(1) = objectiveComparison.Finite_Difference_rel_Complex_Step.rmsDiff;
comparison.Objective_Finite_Difference(2) = objectiveComparison.Finite_Difference_rel_Complex_Step.rmsPercentDiff;

% Objective: Algorithmic Differentiation
comparison.Objective_AD(1) = objectiveComparison.AD_rel_Complex_Step.rmsDiff;
comparison.Objective_AD(2) = objectiveComparison.AD_rel_Complex_Step.rmsPercentDiff;

% Constraint: Finite Difference
comparison.Constraint_Finite_Difference(1) = constraintComparison.Finite_Difference_rel_Complex_Step.rmsDiff;
comparison.Constraint_Finite_Difference(2) = constraintComparison.Finite_Difference_rel_Complex_Step.rmsPercentDiff;

% Constraint: Algorithmic Differentiation
comparison.Constraint_AD(1) = constraintComparison.AD_rel_Complex_Step.rmsDiff;
comparison.Constraint_AD(2) = constraintComparison.AD_rel_Complex_Step.rmsPercentDiff;

comparison = rows2vars(comparison,'VariableNamesSource',1)

%% Running the optimizer with Complex Step derivatives

[xopt, fopt, exitflag, output] = optimizederiv();

figure()
semilogy(output.funcCallCount,output.opt)

% Edit the figure
h = gcf();
ax = gca();

% Overall properties
ax.YScale = 'log';
ax.XLabel.FontSize = 18;
ax.YLabel.FontSize = 18;
ax.Title.FontSize = 20;
ax.Title.String = "First-Order Optimality";
ax.XLabel.String = "Function Calls";
ax.YLabel.String = "First-Order Optimality";
ax.Box = 'on';

% Tick Size
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;

% The actual plot
ax.Children.MarkerSize = 10;
ax.Children.Marker = 'o';
ax.Children.MarkerFaceColor = 'blue';

% The figure
h.Color = [1 1 1];


%% Functions

function output = compareDerivatives(base,test)

    % base = the exact derivatives
    % test = the derivatives to be measured relative to the base

    for i = 1:length(base(:,1)) % Column height
        
        for j = 1:length(base(1,:)) % Row length
            
            differences(i,j) = (test(i,j) - base(i,j));
            percentDiff(i,j) = differences(i,j)/test(i,j).*100;
            
        end
        
    end
    
    
    rmsDiff = rms(reshape(differences,[length(differences(:)),1]));
    rmsPercentDiff = rms(reshape(percentDiff,[length(percentDiff(:)),1]));
    
    output.Differences = differences;
    output.rmsDiff = rmsDiff;
    output.percentDiff = percentDiff;
    output.rmsPercentDiff = rmsPercentDiff;

end