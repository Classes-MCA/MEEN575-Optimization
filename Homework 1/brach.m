function f = brach(y)

    n = length(y);

    startingPoint = [0,1];
    endingPoint   = [1,0];
    
    y(1) = startingPoint(2);
    y(end) = endingPoint(2);
    
    deltaX = (endingPoint(1) - startingPoint(1)) / n;
    x = startingPoint(1):deltaX:endingPoint(1);
    h = startingPoint(2) - endingPoint(2);
    mu = 0.00;
    f = 0;
    
    for i = 1:n-1
        
        deltaY = y(i+1) - y(i);
        
        f = f + sqrt(deltaX^2 + deltaY^2) /...
            (sqrt(h - y(i+1) - mu*x(i+1)) + sqrt(h - y(i) - mu*x(i)));
        
    end

end