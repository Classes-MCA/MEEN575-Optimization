function dfdx = finiteDiff(x,deltaX)

    f1 = equation(x);
    f2 = equation(x + deltaX);
    
    dfdx = (f2 - f1) / deltaX;

    function f = equation(x)
        
        f = exp(x) / sqrt(sin(x)^3 + cos(x)^3);
        
    end

end