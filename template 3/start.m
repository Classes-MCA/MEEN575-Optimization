clc; clear; close all;

x0 = [3500 0.5];
lx = [1000 0];
ux = [6000 1];
ve = VEMap(x0);
disp(ve)

options = optimoptions(@fmincon,'Display','iter-detailed',...
                                'MaxFunctionEvaluations',500e3);

[xopt,fopt] = fmincon(@func, x0, [], [], [], [], lx, ux, [], options);

% options = optimoptions(@fminunc,'Display','iter-detailed',...
%                                 'MaxFunctionEvaluations',500e3);
% 
% [xopt,fopt] = fminunc(@func,x0,options)

function value = func(x0)

    value = VEMap(x0);
    
    value = -value;

end