function [xopt, fopt] = uncon(func, x0, tau, varargin)
%{
An algorithm for unconstrained optimization.

Parameters
----------
func : function handle
    function handle to a function of the form: [f, df] = func(x)
    where f is the function value and df is a *column* vector containing
    the gradient of f.  x are design variables only.
x0 : *column* vector
    starting point
tau : float
    convergence tolerance.  you should terminate when
    norm(df, inf) <= tau.  (the infinity norm of the gradient)

Outputs
-------
xopt : column vector
    the optimal solution
fopt : float
    the corresponding function value
%}

% Your code goes here!  You can (and should) call other functions, but make
% sure you do not change the function signature for this file.  This is the
% file I will call to test your algorithm.  Repeat: don't change the name
% of this file, and don't change the name of this function from uncon.

% Parsing the input
p = inputParser;
p.addRequired('func')
p.addRequired('x0')
p.addRequired('tau')
p.addParameter('Plot2DFunction',false)
p.addParameter('XLims',[-5,5])
p.addParameter('YLims',[-5,5])
p.addParameter('ContourStep',10)
p.addParameter('PlotPoints',false)
p.addParameter('MakeGIF',false)
p.addParameter('FrameRate',24)

p.parse(func, x0, tau, varargin{:});

Plot2DFunction = p.Results.Plot2DFunction;
XLims = p.Results.XLims;
YLims = p.Results.YLims;
ContourStep = p.Results.ContourStep;
PlotPoints = p.Results.PlotPoints;
MakeGIF = p.Results.MakeGIF;
FrameRate = p.Results.FrameRate;

%----- CONTINUING THE FUNCTION -----%   

% Plotting the 2-dimensional function, if desired
if Plot2DFunction
    % Create a plot of the space
    dx1 = (XLims(2) - XLims(1)) / 100;
    dx2 = (YLims(2) - YLims(1)) / 100;
    x1 = XLims(1):dx1:XLims(2);
    x2 = YLims(1):dx2:YLims(2);
    plotSpace(x1,x2,func,ContourStep);
end

% Forcing x0 to be a column vector
x0 = x0(:);

% Basic line search
x = transpose(x0); % Making a row vector

% Perform the optimization
[xopt, fopt] = optimize(x,func,tau,Plot2DFunction,PlotPoints,MakeGIF,FrameRate);


end

function [xopt, fopt] = optimize(x,func,tau,Plot2DFunction,PlotPoints,MakeGIF,FrameRate)

    [~,pold,~] = getFunctionInfo(x,func); % Starting function value

    
    for i = 1:2e4
        
        [f(i),p,tol] = getFunctionInfo(x(i,:),func);
        
        printinfo(i,tol,f(i),x(i,:))
        
        visualize(Plot2DFunction,PlotPoints,x,f,i,MakeGIF,FrameRate);
        
        if tol < tau
            xopt = x(i,:);
            fopt = f(i);
            return
        end
        
        x(i+1,:) = getNewPoint(x(i,:),p,f(i),func,pold);
        
        pold = p;
        
    end
    
    
    
end

function [f,p,tol] = getFunctionInfo(x,func)

    [f,df] = func(x); % Get function and gradient values
    
    p = - df ./ norm(df); % Normalize the gradient to get the direction
    
    tol = norm(df,inf); % Get the tolerance and the infinity norm of the
                        % gradient

end

function xnew = getNewPoint(x,pnew,fold,func,pold)
    
    x = x(:); % Make column vector

    alpha = 1;
    
    gradientAmounts = 0.5:0.1:1.0; % Different amounts of the direction to try
    
    for i = 1:length(gradientAmounts)
        
        w = gradientAmounts(i); % Weighting factor
        
        % If w = 0, then the new direction is ignored,
        % if w = 1, then the old direction is ignored
        p_weighted = (1-w)*pold + w*pnew;
    
        for j = 1:50
            xnew = x + alpha*p_weighted; % Get new x value

            fnew = func(xnew); % See what the function value is there

            if fnew > fold
                alpha = alpha / 2; % If the new function value is too big,
                                   % make alpha smaller
            else
                % If the new value is less than the old value, return.
                return
            end
        end
        
    end
        

end

function printinfo(iteration,tolerance,f,x)
    
    iteration = num2str(iteration);
    tolerance = num2str(tolerance);
    f = num2str(f);
    %x = ['[',num2str(x(1)),', ',num2str(x(2)),']'];

    %info = ['Iteration: ',iteration,', Tolerance: ',tolerance,', ','f(x): ',f,', x: ',x];
    
    info = ['Iteration: ',iteration,', Tolerance: ',tolerance,', ','f(x): ',f];
    
    disp(info)

end

function plotCurrentStatus(x,f,i)

    subplot(1,2,1)
    if i > 1
        ax = gca;
        delete(ax.Children(1:2)); % Remove top scatter and line plots
    end
    scatter3(x(:,1), x(:,2), f,...
             'SizeData',100,...
             'MarkerFaceColor',[1 0 0])
    line(x(:,1), x(:,2), f)
         
    subplot(1,2,2)
    if i > 1
        ax = gca;
        delete(ax.Children(1:2)); % Remove top scatter and line plots
    end
    scatter(x(:,1), x(:,2),100,...
            'MarkerFaceColor',[1 0 0])
    line(x(:,1), x(:,2))

end

function createGraph(x)
    
    y = x;
    
    x = linspace(0,1,length(y)+2);
    
    y = [1,y,0];

    plot(x,y)
    title('Brachistochrone Problem')
    xlabel('X (m)')
    ylabel('Y (m)')

end

function visualize(Plot2DFunction,PlotPoints,x,f,i,MakeGIF,FrameRate)

    if Plot2DFunction
            
        plotCurrentStatus(x,f,i)
        drawnow()

    elseif PlotPoints

        createGraph(x(i,:))
        drawnow()
        
    end
    
    if MakeGIF
        createGIF(i,FrameRate)
    end
    
end
        
function createGIF(i,FrameRate)

    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    filename = "OptimizationGIF.gif";
    
    % Write to the GIF File 
    if i == 1
        imwrite(imind,cm,filename,'gif', 'DelayTime',1/FrameRate, 'Loopcount',inf); 
    else 
        imwrite(imind,cm,filename,'gif', 'DelayTime',1/FrameRate,'WriteMode','append'); 
    end 

end

function [h,ax1,ax2] = plotSpace(x1,x2,func,ContourStep)

    % Solving for the value at each (x,y) coordinate
    for i = 1:length(x1)
        
        for j = 1:length(x2)
            
            vec = [x1(i), x2(j)];
            [values(i,j),~] = func(vec);
            
        end
        
    end
    
    % For some reason, I need the transpose in order to orient the plots
    % correctly
    values = transpose(values);
    
    % Creating the plot
    h = figure();
    h.Position = [2 2 15 6];
    sgtitle('Function Convergence',...
            'FontWeight','Bold',...
            'FontSize',18);
    
    ax1 = subplot(1,2,1);
    [X1,X2] = meshgrid(x1,x2);
    surf(X1,X2,values,...
         'mesh','none')
    title('Surface View',...
          'FontSize',14)
    hold on
    
    ax2 = subplot(1,2,2);
    contour(X1,X2,values,...
            'LevelStep',ContourStep)
    title('Contour View',...
          'FontSize',14)
    hold on

end
