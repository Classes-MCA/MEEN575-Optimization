function [xopt, fopt, iter, opt] = Problem_2_Improved()

    x0 = (0.1 + 1e-9) .* ones(10,1);
    lb = 0.1 .* ones(10,1); % put area here
    ub = [];
    stressmax = 25e3 .* ones(10,1);
    stressmax(9) = 75e3;

    function [f, c, ceq] = objcon(x)
        [mass, stress] = truss(x);
        f = mass;
        c = stress.^2 - stressmax.^2; % scale
        
        c = c./1000; % scaling
        
        ceq = [];
    end

    options = optimoptions(@fmincon,...
                           'Display','iter-detailed',...
                           'OutputFcn',@outfun,...
                           'ScaleProblem',false,...
                           'MaxFunctionEvaluations',5e3,...
                           'PlotFcn','optimplotfirstorderopt');
        
    iter = [];
    opt = [];
                       
    function stop = outfun(x,optimValues,state)
        iter = [iter;optimValues.iteration];
        opt = [opt;optimValues.firstorderopt];
        stop = false; % you can set your own stopping criteria
    end

    %----------------------------------------------
    % Things below this line don't need to be changed

    xlast = [];
    flast = [];
    clast = [];
    ceqlast = [];

    [xopt, fopt] = fmincon(@objective,x0,[],[],[],[],lb,ub,@con,options);

    function f = objective(x)
        
        if ~isequal(x,xlast)
            
            [flast, clast, ceqlast] = objcon(x);
            
            xlast = x;
            
        end
        
        f = flast;
        
    end

    function [c, ceq] = con(x)

        if ~isequal(x,xlast)
            
            [flast, clast, ceqlast] = objcon(x);
            
            xlast = x;
            
        end
        
        c = clast;
        ceq = ceqlast;
        
    end

%     function [mass, stress] = structure(x, params)
%         mass = (1 - x(1))^2 + params(1) * (x(2) - x(1)^2)^2;
% 
%         stress = zeros(2,1);
%         stress(1) = x(1)^2 + x(2)^2;
%         stress(2) = x(1) + params(2)*x(2);
% 
%     end
end