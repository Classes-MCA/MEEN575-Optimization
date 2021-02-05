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

%----- CONTINUING THE FUNCTION -----%   

% Plotting the 2-dimensional function, if desired
if Plot2DFunction
    % Create a plot of the space
    xpos = -10:0.1:10;
    ypos = -10:0.1:10;
    plotSpace(xpos,ypos,func);
end

% Forcing x0 to be a column vector
x0 = x0(:);

% Basic line search
x = x0;

% Perform the optimization
[xopt, fopt] = optimize(x,func,tau,Plot2DFunction);


end

function [xopt, fopt] = optimize(x,func,tau,Plot2DFunction)

    alpha = 1;
    xhist = x;
    [f(1), df(1,:)] = func(x);

    for i = 2:1000
    
        [f(i), df(i,:)] = func(x);
    
        p = 0.9;
        direction = -(1-p).*df(i-1,:) - p.*df(i,:);
        xnew = linesearch(x, alpha, direction, func);

        disp(['Iteration: ',num2str(i-1),', x = [',num2str(xnew(1)),', ',num2str(xnew(2)),']'])

        deltaX = xnew - x;
        x = xnew;
        xhist = [xhist, x];
        
        if Plot2DFunction
            
            subplot(1,2,1)
            scatter3(xhist(1,:), xhist(2,:), f(:),...
                    'MarkerEdgeColor','flat',...
                    'MarkerFaceColor','red',...
                    'CData',[1,0,0],...
                    'SizeData',10)
            line(xhist(1,:), xhist(2,:), f(:))
                 
            subplot(1,2,2)
            scatter(xhist(1,:), xhist(2,:),...
                    'MarkerEdgeColor','flat',...
                    'MarkerFaceColor','red',...
                    'CData',[1,0,0],...
                    'SizeData',10)
            line(xhist(1,:), xhist(2,:), f(:))
            drawnow()
            
        end

        if rms(deltaX) < tau
            disp(['Finished after ',num2str(i-1),' iterations.'])
            break
        end

    end
    
    xopt = x;
    fopt = func(x);

end

function xnew = linesearch(x, alpha, direction, func)
    
    direction = direction(:); % Force to be a column vector

    for i = 1:100
        xnew = x + alpha .* direction;
        
        if func(xnew) < func(x)
            return
        elseif alpha < 0.01
            return
        else
            alpha = alpha / 2; % Shrink the step size
        end
        
    end

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
    hold on
    
    ax2 = subplot(1,2,2);
    contour(X,Y,values,...
            'LevelStep',10.0)
    title('Contour View')
    hold on

end
