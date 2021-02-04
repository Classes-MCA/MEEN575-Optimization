usePackage GeneralSignalProcessing
clear; close all; plotStyle()


n = 30;
startingPoint = [0,1];
endingPoint   = [1,0];
y0 = flip(0:1/n:1);
deltaX = (endingPoint(1) - startingPoint(1)) / n;
x = startingPoint(1):deltaX:endingPoint(1);

options = optimoptions(@fminunc,'Display','iter-detailed');
[xstar,fstar] = fminunc(@brach,y0,options);

plot(x,xstar)
title('Optimized Path')


