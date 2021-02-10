clear; close all;
usePackage GeneralSignalProcessing
plotStyle('StandardStyle','SonicBoom')

options = optimoptions(@fminunc,'Display','iter-detailed',...
                                'MaxFunctionEvaluations',500e3);

%% Quadratic Function
% Creating an intial guess
x0 = [0,0];

[xopt, fopt] = uncon(@quad,x0,1e-6,...
               'Plot2DFunction',true,...
               'XLims',[-10,10],...
               'YLims',[-10,10],...
               'MakeGif',false,...
               'FrameRate',2.5)
           
sgtitle('Convergence of |\nablaf|_{\infty} for Quadratic Function',...
        'FontWeight','Bold',...
        'FontSize',20)
           
[xopt_pro, fopt_pro] = fminunc(@quad,x0,options)

%% Rosenbrock Function
x0 = [1.5,2];

[xopt, fopt] = uncon(@rosenbrock,x0,1e-6,...
                     'Plot2DFunction',true,...
                     'XLims',[-1.5,1.5],...
                     'YLims',[-1,2.5],...
                     'ContourStep',10,...
                     'MakeGif',false,...
                     'FrameRate',2.5);
                 
sgtitle('Convergence of |\nablaf|_{\infty} for Rosenbrock Function',...
        'FontWeight','Bold',...
        'FontSize',20)
                 
[xopt_pro, fopt_pro] = fminunc(@rosenbrock,x0,options)

%% Brachistochrone Problem
interiorPoints = 58;
x = linspace(0,1,interiorPoints + 2);
y0 = cos(6*pi.*x(2:end-1)).^2 .* 0.5;
%y0 = linspace(0.9,0.1,interiorPoints);
% y0 = ones(interiorPoints,1) - 0.5;

%figure()
[yopt, fopt] = uncon(@brachistochrone,y0,1e-6,...
                     'PlotPoints',true,...
                     'MakeGIF',true,...
                     'FrameRate',24);

sgtitle('Convergence of |\nablaf|_{\infty} for Brachistochrone Function',...
        'FontWeight','Bold',...
        'FontSize',20)
                 
[yopt_pro, fopt_pro] = fminunc(@brachistochrone,y0,options)
                 
yopt = [1, yopt, 0];
yopt_pro = [1, yopt_pro, 0];

%%
figure()
plot(x,yopt,'LineWidth',8,'Color',[0 1 0]); hold on
plot(x,yopt_pro,'LineWidth',4,'LineStyle','--','Color',[1 0 0])
title('Brachistochrone Problem','FontSize',20)
xlabel('X (m)','FontSize',18)
ylabel('Y (m)','FontSize',18)
set(gcf,'Position',[2,2,10,6])
hleg = legend('Uncon','Fminunc','Location','NorthEast');
hleg.FontSize = 14;
hleg.Title.String = 'Optimizer';

%% Functions
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
    
    df = [-2*(1 - x(1)) - 400*x(1)*(x(2) - x(1)^2); 200*(x(2) - x(1)^2)];
    df = df(:);

end