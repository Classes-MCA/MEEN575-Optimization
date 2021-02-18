function output = trusscon(x)
    
    maxStress = 25e3;
    
    trussoutput = truss(x);
    
    stress = trussoutput.stress;

    g(1:10,1) = abs(stress) - abs(maxStress);
    g(9) = abs(stress(9)) - abs(75e3); % special condition
    
    output.constraints = g;

end