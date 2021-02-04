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

p.parse(func, x0, tau, varargin{:});

Plot2DFunction = p.Results.Plot2DFunction;

if Plot2DFunction
    % Create a plot of the space
    x = -10:0.1:10;
    y = -10:0.1:10;
    plotSpace(x,y,func);
end

% Forcing x0 to be a column vector
x0 = x0(:);




% Setting dummy results
xopt = 0;
fopt = 0;

end

function [h,ax1,ax2] = plotSpace(x,y,func)

    % Solving for the value at each (x,y) coordinate
    for i = 1:length(x)
        
        for j = 1:length(y)
            
            vec = [x(i), y(j)];
            [values(i,j),~] = func(vec);
            
        end
        
    end
    
    % Creating the plot
    h = figure();
    h.Position = [2 2 15 6];
    sgtitle('Quadratic Function Convergence',...
            'FontWeight','Bold',...
            'FontSize',18);
    
    ax1 = subplot(1,2,1);
    [X,Y] = meshgrid(x,y);
    surf(X,Y,values,...
         'mesh','none')
    title('Surface View')
    
    ax2 = subplot(1,2,2);
    contour(X,Y,values,...
            'LevelStep',10.0)
    title('Contour View')

end
