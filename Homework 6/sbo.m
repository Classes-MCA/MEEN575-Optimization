function sbo()

    % Add jar files to java classpath
    javaaddpath({strcat(pwd,'/me575hw6.jar'), strcat(pwd,'/colt.jar')});
    wavedrag = @WaveDragAS.compute;  % rename function call for convenience

    % Lower bound
    lb = [0.05, 0.15, 0.65, 1.75, 3.00, 4.25];

    % Upper bound
    ub = [0.25, 0.40, 0.85, 2.25, 3.25, 4.75];
    
    % Construct LHS Sample (use lhsdesign)
    M = 20;  % number of samples
    N = 6;  % number of design variables
    x = lb + (ub - lb) .* lhsdesign(M,N);

    % in a loop, create the actual x using the equation above, 
    % and evaluate wavedrag(x) at each x, and save the result a vector called f.
    for i = 1:height(x)
        f(i,1) = wavedrag(x(i,:));
    end
    
    % Create PHI (in a loop)
    PHI = zeros(M, 28);
    for i = 1:height(x)
        PHI(i,:) = expandQuad(x(i,:));
    end
    
    % Compute w from a least squares solution of Phi w = f 
	w = lsqlin(PHI,f); 
    
    % starting design
    x0 = [0.100,  0.198,  0.7,  1.800,  3.200,  4.550];

    options = optimoptions('fmincon','Display','none');
    
    for i = 1:20
        
        % perform optimization using surrogate
        % optimization or surrogate model
        J = @(x) expandQuad(x)*w;   
        [xopt, fopt] = fmincon(J, x0, [], [], [], [], lb, ub,[], options);

        % compute the error in our surrogate prediction and decide whether or not to break
        error = (wavedrag(xopt) - fopt)/wavedrag(xopt);
        disp(strcat("Iteration ",num2str(i),". Error = ",num2str(error)))
        if error < 0.05
            break
        end

        % if not, add another row to sample data (add a row to PHI and a row to F)
        % be sure to use the actual function value at xopt 
        % and not not the f from fmincon which is based on the surrogate
        PHI(end+1,:) = expandQuad(xopt);
        f(end+1) = wavedrag(xopt);

        % re-estimate the surrogate parameters (w)
        w = lsqlin(PHI,f);

    end

    % Comparing to the theoretically-correct answer
    % theoretical error
    d = 10; l = 100;
    CD_min = (pi*d/l)^2;
    fprintf('Theoretical Error = %3.3g%%\n', (wavedrag(xopt) - CD_min)/CD_min*100);
    
    % --------------- Plot geometry ------------------------
    % SBO solution
    x = l*[0.0, 0.005, 0.01, 0.025, 0.1, 0.2, 0.35, 0.5, 0.65, 0.8, 0.9, 0.975, 0.99, 0.995, 1.0];
    r = [0 xopt 5 fliplr(xopt) 0];  % this must come from your SBO solution

    % theoretical optimal solution - Sears Haack
    xSH = .01:.01:1;
    rSH = d/2*sqrt(sqrt(1-xSH.^2)-xSH.^2.*log((1+sqrt(1-xSH.^2))./xSH));

    xSH = l/2*[-fliplr(xSH) xSH] + l/2;
    rSH = [fliplr(rSH) rSH];

    figure; hold on;
    h1 = plot(x,r,'b');
    plot(x,-r,'b');  
    h2 = plot(xSH,rSH,'r--');
    plot(xSH,-rSH,'r--');
    axis equal;
    legend([h1, h2], {'SBO','Sears-Haack'});
    % ----------------------------------------------------------
    
end