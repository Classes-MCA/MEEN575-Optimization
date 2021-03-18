clear; close all;

sqp(@test)

function sqp(func)

    x = [2,1];
    lambda = 0;
    Hessian = [1 0;
               0 1];

    % Evaluate the gradients of L and h
    h = get_h(x);
    grad_L = gradient_L(x,lambda);
    grad_h = gradient_h(x);
    
    % Solve the KKT system for the step variables
    A = [Hessian transpose(grad_h); 
         grad_h zeros(1,1)];
    b = [-grad_L; -h];
    
    s = linsolve(A,b);
    
    % Perform a line search in the direction given by the step vector for x
    p = s(1:2)
    funcValue = 100;
    alpha = 1;
    for j = 1:10
        if funcValue > func(x + alpha.*p)
            alpha = alpha /2;
        else
            x = x + alpha .* p;
        end
    end
    lambda = s(3)
    
    % Update the step for x and lambda
    
    % Update the hessian estimate using Equations 5.77-80
    
    % Do it all again

end

function f = test(x)

    f = x(1) + 2*x(2);

end

function h = get_h(x)

    h = 0.25 * x(1)^2 + x(2)^2 - 1;

end

function grad_h = gradient_h(x)

    grad_h = [0.5 * x(1), 2 * x(2)];

end

function grad_L = gradient_L(x,lambda)

    grad_L = [1 + 0.5 * lambda * x(1);
              2 + 2 * lambda * x(2)];

end

function f = rosenbrock(x)
    
    f = (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;

end