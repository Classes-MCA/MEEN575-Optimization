clear; close all;

fun = @(x) (1-x(1)).^2 + 100.*(x(2) - x(1).^2).^2;

x0 = [-pi,1400];

[x,fval] = fminunc(fun,x0)