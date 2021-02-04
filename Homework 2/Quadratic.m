clear; close all;
usePackage GeneralSignalProcessing
plotStyle('StandardStyle','SonicBoom')

% Creating an intial guess
x0 = [5,10];

[xopt, fopt] = uncon(@func,x0,1e-6,'Plot2DFunction',true);


% Defining the quadratic function
function  [f,df] = func(x)

    beta = 3/2;

    f = x(1)^2 + x(2)^2 - beta*x(1)*x(2);
    
    df = [2*x(1) - beta*x(2), 2*x(2) - beta*x(1)];

end