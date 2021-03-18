clear; close all;

x0 = [1,1e6];

xstar = fminsearch(@rosenbrock,x0)

function f = rosenbrock(x)
    
    f = (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;

end