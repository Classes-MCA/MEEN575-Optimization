function [xopt, fopt, iter, opt] = MATLAB_Further_Steps()
    x0 = [3.0, 3.0];
    lb = [0.0, 0.0];
    ub = [10.0, 10.0];
    params = [100.0, 3.0];
    stressmax = [1.0, 5.0];

    function [f, c, ceq] = objcon(x)
        [mass, stress] = structure(x,params);
        f = mass;
        c = stress - stressmax;
        ceq = [];
    end

    options = optimoptions(@fmincon,...
                           'Display','iter-detailed',...
                           'OutputFcn',@outfun);
        
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

    function [mass, stress] = structure(x, params)
        mass = (1 - x(1))^2 + params(1) * (x(2) - x(1)^2)^2;

        stress = zeros(2,1);
        stress(1) = x(1)^2 + x(2)^2;
        stress(2) = x(1) + params(2)*x(2);

    end
end