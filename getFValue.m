function f =  getFValue(x,fguess)

    f = fguess;
    maxIter = 100;
    tolerance = 1e-6;
    
    for i = 1:maxIter

        residual = sin(x + f) - f;
       
        if abs(residual) > abs(tolerance)
            
            f = f + residual;
            disp(['Iteration ',num2str(i),': f = ',num2str(f),' Residual = ',num2str(residual)])
            
        else
            
            return
            
        end
        
    end

end