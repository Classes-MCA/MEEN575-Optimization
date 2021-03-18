% Performing the optimziation
function problem3()
    x0 = [-1,-2];
    opt = [];
    path_fmincon = [];

    fprintf(2,'Performing the optimization...\n\n')
    [xopt,path] = optimize(@test,@constraint,x0,40);
    disp('Optimum found at x = ')
    disp(xopt)

    disp('Checking Constraints (should be less than zero)')
    disp(constraint(xopt))

    fprintf(2,'\nChecking against fmincon now...\n\n')
    [xopt, fopt, exitFlag, output] = fmincon(@test, x0, [], [], [], [], [], [], @constraint,...
                                        optimoptions('fmincon',...
                                                    'Display','none',...
                                                    'OutputFcn',@outfun));

    disp('Optimum found at x = ')
    disp(xopt)

    disp('Checking Constraints (should be less than zero)')
    disp(constraint(xopt))

    fprintf(2,'\nComparing Convergence Rates\n')
    
    hfig = figure();
    plot(path_fmincon(:,1),path_fmincon(:,2),'*-','DisplayName','fmincon','LineWidth',3)
    hold on
    plot(path(:,1),path(:,2),'o-','DisplayName','Penalty Method','LineWidth',3)
    hleg = legend();
    hleg.FontSize = 16;
    hleg.Title.String = ["Optimization";"Method"];
    hfig.Children(2).XAxis.FontSize = 14;
    hfig.Children(2).XLabel.String = "X_1";
    hfig.Children(2).YAxis.FontSize = 14;
    hfig.Children(2).YLabel.String = "X_2";
    hfig.Children(2).Title.String = 'Convergence Comparison';
    hfig.Children(2).Title.FontSize = 18;
    hfig.Position = [2 2 8 5];
    
    %--- USER INPUTS FUNCTIONS AND CONSTRAINTS ---%
    
    function f = test(x)

            f = (1 - x(1))^2 + 100*(x(2) - x(1)^2)^2;

    end

    function [c,ceq] = constraint(x)

        c(1) = x(1) + x(2) - 4;
        c(2) = 2*x(1) - 6*x(2) + 10;
        
%         c(1) = x(1)^2 - sqrt(x(2));
%         c(2) = sin(x(1)) - cos(x(2));

        % Equality constraints not supported, but empty output is supplied
        % for fmincon.
        ceq = [];

    end

    %--- PENALTY METHOD OPTIMIZATION ---%

    function [xopt,path] = optimize(func,constraint,x0,maxIterations)

        mu = 1;
        path = x0;

        for i = 1:maxIterations

            path(i+1,:) = fminunc(@obj,path(i,:),optimoptions('fminunc','Display','none'));
            mu = mu + 1;

        end

        xopt = path(end,:);
        
        function f = obj(x)

            con = 0;
            constraintValues = constraint(x);

            for j = 1:length(constraintValues)

                con = con + constraintValues(j)^2;

            end

            f = func(x) + mu/2 * con;

        end

    end

    function stop = outfun(x,optimValues,state)
            opt = [opt;optimValues.firstorderopt];
            path_fmincon = [path_fmincon;x];
            stop = false;
    end

end