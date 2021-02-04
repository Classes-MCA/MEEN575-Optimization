clear; close all;

fun = @(x) (1-x(1)).^2 + 100.*(x(2) - x(1).^2).^2;

x0 = [0,0];

[x,fval] = fminunc(fun,x0)