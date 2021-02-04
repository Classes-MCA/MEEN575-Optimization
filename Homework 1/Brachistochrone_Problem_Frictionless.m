usePackage GeneralSignalProcessing
clear; close all; plotStyle()

for n = [4,8,16,32,64,128]
    
    startingPoint = [0,1];
    endingPoint   = [1,0];
    y0 = flip(0:1/n:1);
    deltaX = (endingPoint(1) - startingPoint(1)) / n;
    x = startingPoint(1):deltaX:endingPoint(1);

    options = optimoptions(@fminunc,...
                           'Display','iter-detailed',...
                           'MaxFunctionEvaluations',15e3);
    [xstar,fstar,~,output] = fminunc(@brach,y0,options);
    
    
    plot(x,xstar,...
    'DisplayName',['n = ',num2str(n)],...
    'LineWidth', 2.0)
    hold on

end

title('Frictionless Brachistochrone Problem')
xlabel('Lateral Position (length units)')
ylabel('Height (length units)')
grid on

% Creating the legend
hleg = legend();
hleg.Location = 'EastOutside';
hleg.Title.String = 'Legend';
hleg.FontSize = 16;