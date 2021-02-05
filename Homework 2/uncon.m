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

p.parse(func, x0, tau, varargin{:});

Plot2DFunction = p.Results.Plot2DFunction;
XLims = p.Results.XLims;
YLims = p.Results.YLims;

%----- CONTINUING THE FUNCTION -----%   

% Plotting the 2-dimensional function, if desired
if Plot2DFunction
    % Create a plot of the space
    x1 = XLims(1):0.1:XLims(2);
    x2 = YLims(1):0.1:YLims(2);
    plotSpace(x1,x2,func);
end

% Forcing x0 to be a column vector
x0 = x0(:);

% Basic line search
x = transpose(x0); % Making a row vector

% Perform the optimization
[xopt, fopt] = optimize(x,func,tau,Plot2DFunction);


end

function [xopt, fopt] = optimize(x,func,tau,Plot2DFunction)

    f(1) = func(x); % Starting function value

    for i = 2:100
        
        [f(i),p] = getFunctionInfo(x(i-1,:),func);
        
        x(i,:) = getNewPoint(x(i-1,:),p);
        
        if Plot2DFunction
            
            plotCurrentStatus(x,f)
            
        end
        
    end
    
    xopt = 0;
    fopt = 0;

end

function [f,p] = getFunctionInfo(x,func)

    [f,df] = func(x);
    
    p = - df ./ norm(df);

end

function xnew = getNewPoint(x,p)
    
    x = x(:); % Make column vector

    alpha = 0.1;

    xnew = x + alpha*p;

end

function plotCurrentStatus(x,f)

    subplot(1,2,1)
    scatter3(x(:,1), x(:,2), f,...
             'r.')
         
    subplot(1,2,2)
    scatter(x(:,1), x(:,2),...
            'r.')

end

function [h,ax1,ax2] = plotSpace(x1,x2,func)

    % Solving for the value at each (x,y) coordinate
    for i = 1:length(x1)
        
        for j = 1:length(x2)
            
            vec = [x1(i), x2(j)];
            [values(i,j),~] = func(vec);
            
        end
        
    end
    
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
    title('Surface View')
    hold on
    
    ax2 = subplot(1,2,2);
    contour(X1,X2,values)
    title('Contour View')
    hold on

end
