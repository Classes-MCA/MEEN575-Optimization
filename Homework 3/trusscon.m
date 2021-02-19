function output = trusscon(x)
    
    maxStress = 25e3;
    
    trussoutput = truss(x);
    
    stress = trussoutput.stress;

    g(1:10,1) = stress.^2 - maxStress.^2;
    g(9) = stress(9)^2 - 75e3^2; % special condition
    
    output.constraints = g/1000;

end