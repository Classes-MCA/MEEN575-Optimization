clear; close all;
usePackage GeneralSignalProcessing
plotStyle('StandardStyle','SonicBoom')

% Creating an intial guess
x0 = [5,10];

[xopt, fopt] = uncon(@quad,x0,1e-6,'Plot2DFunction',true);

pause(3)

[xopt, fopt] = uncon(@rosenbrock,x0,1e-6,'Plot2DFunction',true);


% Defining the quadratic function
function  [f,df] = quad(x)

    beta = 3/2;

    f = x(1)^2 + x(2)^2 - beta*x(1)*x(2);
    
    df = [2*x(1) - beta*x(2), 2*x(2) - beta*x(1)];
    df = df(:);

end

% Defining the quadratic function
function  [f,df] = rosenbrock(x)

    f = (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;
    
    df = [2*(1 - x(1)) + 200*(x(2) - x(1))*2*x(1), 200*(x(2) - x(1)^2)];
    df = df(:);

end