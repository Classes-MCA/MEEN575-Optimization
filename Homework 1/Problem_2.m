clear; close all;

% Cross-sectional areas of each bar
A0 = rand(10,1);

% Constrained with options
options = optimoptions(@fmincon,...
                       'Display','iter-detailed',...
                       'MaxFunctionEvaluations',100e3,...
                       'MaxIterations',1e3,...
                       'ConstraintTolerance',1e-10,...
                       'StepTolerance',1e-10,...
                       'PlotFcn','optimplotfirstorderopt',...
                       'ScaleProblem',false,...
                       'Algorithm','interior-point');
[xstar,fstar,~,output] = fmincon(@getMass,A0,[],[],[],[],[],[],@mycon,options);

[mass,stress] = truss(xstar)

%      disp(['Mass: ',num2str(mass)])

function mass = getMass(A)
    
    scale = 1;

    [mass,~] = truss(A*scale);
    
    mass = mass / scale;

end

function [c, ceq] = mycon(A)

    % c = inequality constraints
    % ceq = equality constraints
    
    [~,stress] = truss(A);
    
    maxStress = 25e3; % psi
    
    % Initializing the constraint arrays
    c = zeros(20,1);
    ceq = [];
    
    % Stress constraints
    for i = 1:10
        c(i) = (stress(i))^2 - (maxStress)^2;    
    end
    
    % Area constraints
    for i = 11:20
        c(i) = A(i-10) - 0.1;
    end
    
    % Special conditions
    c(9) = (stress(9))^2 - (75e3)^2;
    
end