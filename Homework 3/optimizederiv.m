function [xopt, fopt, exitflag, output] = optimizederiv()

    % -------- starting point and bounds ----------
    x0 = ones(10,1);
    ub = [];
    lb = 0.1*ones(10,1);
    % ---------------------------------------------

    % ------ linear constraints ----------------
    % We won't be doing this for the truss example. Leave these as empty
    % arrays
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    % ------------------------------------------

    % ---- Objective and Constraints -------------
    function [f, g, h, df, dg, dh] = objcon(x)

        % set objective/constraints here
        % f: objective
        % g: inequality constraints
        % h: equality constraints
        % d*: derivatives of * (see fmincon docs for index ordering)
        
        % Interpretation
        % f: the mass from the truss() function
        truss_output = truss(x);
        f = truss_output.mass;
        
        % g: inequality constraints, see first homework. Should be almost
        % exactly the same, if not exactly.
        trusscon_output = trusscon(x);
        g = trusscon_output.constraints;
        
        % h: equality constraints, see first homework. There are none for
        % this homework
        h = [];
        
        % df: simple derivative
        J = getJacobian(@truss,x,...
                        'Method','Complex-Step');
                    
        df = J(1).output;           
        
        % dg: Jacobian of g. Finite difference the truss function again,
        % and then get the J_g at each point in the Jacobian.
        % Create a function outside of optimizederiv called
        % 'getJacobian()'.
        % Within that function, say f(x, g(x)). If you generalize this
        % well, then you can use the same function to get any Jacobian for
        % any function. Know the number of outputs of g(x). Part 1 of the
        % homework is to create this super generalized Jacobian function
        % for any function. This will work for finite differencing and
        % complex step, but not the others.
        J = getJacobian(@trusscon,x,...
                        'Method','Complex-Step');
        dg = J(1).output;
        
        % dh: Jacobian of h, which is nothing for this particular case.
        dh = [];

    end
    % -------------------------------------------

    % ----------- options ----------------------------
    options = optimoptions('fmincon', ...
        'Algorithm', 'active-set', ...  % choose one of: 'interior-point', 'sqp', 'active-set', 'trust-region-reflective'
        'HonorBounds', true, ...  % forces optimizer to always satisfy bounds at each iteration
        'Display', 'iter-detailed', ...  % display more information
        'MaxIterations', 1000, ...  % maximum number of iterations
        'MaxFunctionEvaluations', 10000, ...  % maximum number of function calls
        'OptimalityTolerance', 1e-6, ...  % convergence tolerance on first order optimality
        'ConstraintTolerance', 1e-6, ...  % convergence tolerance on constraints
        'FiniteDifferenceType', 'forward', ...  % if finite differencing, can also use central
        'SpecifyObjectiveGradient', true, ...  % supply gradients of objective
        'SpecifyConstraintGradient', true, ...  % supply gradients of constraints
        'CheckGradients', false, ...  % true if you want to check your supplied gradients against finite differencing
        'Diagnostics', 'on');  % display diagnotic information
    % -------------------------------------------


    % -- NOTE: no need to change anything below) --
    % see: https://www.mathworks.com/help/optim/ug/objective-and-nonlinear-constraints-in-the-same-function.html
    

    % ------- shared variables -----------
    xlast = [];  % last design variables
    flast = [];  % last objective
    glast = [];  % last nonlinear inequality constraint
    hlast = [];  % last nonlinear equality constraint
    dflast = [];  % last derivatives
    dglast = [];
    dhlast = [];
    % --------------------------------------


    % ------ separate obj/con  --------
    function [f, df] = obj(x)

        % check if computation is necessary
        if ~isequal(x, xlast)
            [flast, glast, hlast, dflast, dglast, dhlast] = objcon(x);
            xlast = x;
        end

        f = flast;
        df = dflast;
    end

    function [g, h, dg, dh] = con(x)

        % check if computation is necessary
        if ~isequal(x, xlast)
            [flast, glast, hlast, dflast, dglast, dhlast] = objcon(x);
            xlast = x;
        end

        % set constraints
        g = glast;
        h = hlast;
        dg = dglast;
        dh = dhlast;
    end
    % ------------------------------------------------

    % call fmincon
    [xopt, fopt, exitflag, output] = fmincon(@obj, x0, A, b, Aeq, beq, lb, ub, @con, options);

end
