function J = getJacobian(func,x,varargin)

    p = inputParser;
    p.addRequired('func');
    p.addRequired('x');
    p.addParameter('Method','Finite-Difference')
    p.addParameter('StepSize',1e-6)
    
    p.parse(func,x,varargin{:});
    Method = p.Results.Method;
    h = p.Results.StepSize;
    
    % Setting dimensions for the Jacobian
    inputNum = length(x);
    outputNum = nargout(func);
    outputNum = 1; % Just for the mass
    J = zeros(inputNum,outputNum);
    
    for i = 1:inputNum
            
            if strcmp(lower(Method),lower('Finite-Difference'))
                
                % Do a central-difference
                x_forward = x;
                x_backward = x;
                x_forward(i) = x_forward(i) + h/2;
                x_backward(i) = x_backward(i) - h/2;
                
                [mass_forward,stress_forward] = func(x_forward);
                [mass_backward,stress_backward] = func(x_backward);
                
                J(i,1) = (mass_forward - mass_backward)/h;
                %J(i,2) = (stress_forward - stress_backward)/h;
                
            end
        
    end

end

