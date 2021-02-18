function J = getJacobian(func,x,varargin)

    p = inputParser;
    p.addRequired('func');
    p.addRequired('x');
    p.addParameter('Method','Finite-Difference')
    p.addParameter('StepSize',1e-8)
    
    p.parse(func,x,varargin{:});
    Method = p.Results.Method;
    h = p.Results.StepSize;
    
    % Setting dimensions for the Jacobian
    inputNum = length(x);
    outputNum = nargout(func);
    
    for i = 1:inputNum
            
            if strcmp(lower(Method),lower('Finite-Difference'))
                
                % Do a central-difference
                x_forward = x;
                x_backward = x;
                x_forward(i) = x_forward(i) + h/2;
                x_backward(i) = x_backward(i) - h/2;
                
                output_forward = func(x_forward);
                output_backward = func(x_backward);
                
                output_vars = fieldnames(output_forward);
                
                % Create a Jacobian for each function output
                for j = 1:length(output_vars)
                    
                    forward = eval(['output_forward.',output_vars{j}]);
                    backward = eval(['output_backward.',output_vars{j}]);
                    
                    deriv = (forward - backward)/h;
                    
                    J(j).output(i,:) = deriv;
                    
                end
                
            elseif strcmp(lower(Method),lower('Complex-Step'))
                
                % Do a central-difference
                x_step = x;
                x_step(i) = x_step(i) + 1j*h;
                
                output_step = func(x_step);
                
                output_vars = fieldnames(output_step);
                
                % Create a Jacobian for each function output
                for k = 1:length(output_vars)
                    
                    step = eval(['output_step.',output_vars{k}]);
                    
                    deriv = step/h;
                    
                    J(k).output(i,:) = deriv;
                    
                end

                
            end
        
    end

end

