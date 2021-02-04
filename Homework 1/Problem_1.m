usePackage GeneralSignalProcessing
clear; close all; plotStyle()

%% Part A: Simple Optimization

n = 12;

startingPoint = [0,1];
endingPoint   = [1,0];
y0 = flip(0:1/n:1);
deltaX = (endingPoint(1) - startingPoint(1)) / n;
x = startingPoint(1):deltaX:endingPoint(1);


options = optimoptions(@fminunc,...
                           'Display','iter-detailed',...
                           'MaxFunctionEvaluations',100e3,...
                           'MaxIterations',1e3,...
                           'StepTolerance',1e-9);
[xstar,fstar,~,output] = fminunc(@brach,y0,options);


figure(1)
plot(x,xstar,...
    'LineWidth', 2.0)
title('Brachistochrone Problem Solution for \mu_k = 0.30')
xlabel('Lateral Position (m)')
ylabel('Height (m)')
hold on

%% Part B: Total Travel Time

T = getTime(xstar,x,deltaX,startingPoint,endingPoint);

disp(['Total Time: ', num2str(T)])

%% Part C: Increased Computational Cost

designVariables = [4,8,16,32,64,128];
iterations = zeros(length(designVariables),1);
functionCalls = zeros(length(designVariables),1);

for i = 1:length(designVariables)
    
    n = designVariables(i);
    startingPoint = [0,1];
    endingPoint   = [1,0];
    y0 = flip(0:1/n:1);
    deltaX = (endingPoint(1) - startingPoint(1)) / n;
    x = startingPoint(1):deltaX:endingPoint(1);

    
    [xstar,fstar,~,output] = fminunc(@brach,y0,options);
    
    T(i) = getTime(xstar,x,deltaX,startingPoint,endingPoint);
    
    iterations(i) = output.iterations;
    functionCalls(i) = output.funcCount;
    
    figure(2)
    plot(x,xstar,...
    'DisplayName',['n = ',num2str(n)],...
    'LineWidth', 4.0,...
    'LineStyle','-')
    title('Brachistochrone Problem Solution for \mu_k = 0.30')
    xlabel('Lateral Position (length units)')
    ylabel('Height (length units)')
    grid on
    hold on

    % Creating the legend
    hleg = legend();
    hleg.Location = 'EastOutside';
    hleg.Title.String = 'Legend';
    hleg.FontSize = 16;
    
end

figure(3)
semilogx(designVariables,iterations,...
         'LineWidth',2,...
         'Marker','o')
title('Iterations')
xlabel('Design Variables')
ylabel('Iterations')
grid on


figure(4)
semilogx(designVariables,functionCalls,...
         'LineWidth',2,...
         'Marker','o')
title('Function Calls')
xlabel('Design Variables')
ylabel('Function Calls')
grid on

figure(5)
semilogx(designVariables,T,...
         'LineWidth',2,...
         'Marker','o')
title('Travel Time')
xlabel('Design Variables')
ylabel('Travel Time')
grid on

function T = getTime(xstar,x,deltaX,startingPoint,endingPoint)

    T = 0;
    g = 9.81;

    y = xstar;

    for i = 1:length(y) - 1

        deltaY = y(i+1) - y(i);

        h = startingPoint(2) - endingPoint(2);
        mu = 0.30;

        T = T + sqrt(2/g) * sqrt(deltaX^2 + deltaY^2) /...
            (sqrt(h - y(i+1) - mu*x(i+1)) + sqrt(h - y(i) - mu*x(i)));

    end

end