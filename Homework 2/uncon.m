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
    x1 = -10:0.1:10;
    x2 = -10:0.1:10;
    plotSpace(x1,x2,func);
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
    
    df(1,:) = [0,0];
    
    %f(1,:) = df(1,:) ./ norm(df(1,:));

    for i = 2:1000
    
        [f(i), df(i,:)] = func(x);
    
        df(i,:) = df(i,:) ./ norm(df(i,:));
        
        p = 0.1;
        direction = -(1-p).*df(i-1,:) - p.*df(i,:);
        xnew = linesearch(x, alpha, direction, func);

        deltaX = xnew - x;
        x = xnew;
        xhist = [xhist, x];
        
        disp(['Iteration: ',num2str(i-1),', tol = ',num2str(norm(df(i,:),inf)),', x = [',num2str(xnew(1)),', ',num2str(xnew(2)),']'])
        
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

        if norm(df(i,:),inf) < tau
            disp(['Finished after ',num2str(i-1),' iterations.'])
            break
        end

    end
    
    xopt = x;
    fopt = func(x);

end

function xnew = linesearch(x, alpha, direction, func)
    
    direction = direction(:); % Force to be a column vector

    for i = 1:1e5
        xnew = x + alpha .* direction;
        
        if func(xnew) < func(x)
            return
        elseif alpha < 1e-9
            % find steepest descent
            %[~,direction] = func(x);
            
            return
        else
            alpha = alpha / 2; % Shrink the step size
        end
        
    end

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
