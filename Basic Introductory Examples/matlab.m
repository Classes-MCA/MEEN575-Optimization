clear; close all;

% rosenbrock([1.5,2.0])

x0 = [0,1]; % Initial guess

% Unconstrained
%[xstar,fstar] = fminunc(@rosenbrock,x0);

% Constrained
% The [] are for us not having any linear constraints or bounds
%[xstar,fstar] = fmincon(@rosenbrock,x0,[],[],[],[],[],[],@mycon);

% Constrained with options
options = optimoptions(@fmincon,'Display','iter-detailed')
[xstar,fstar] = fmincon(@rosenbrock,x0,[],[],[],[],[],[],@mycon,options)

function f = rosenbrock(x)
    
    f = (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;

end

function [c,ceq] = mycon(x)

    % c = inequality constraints
    % ceq = equality constraints
    
    c = zeros(2,1);
    c(1) = x(1)^2 + x(2)^2 - 1; % Put in form that the whole thing is <= 0
    c(2) = x(1) + 3*x(2) - 5;
    ceq = [];

end