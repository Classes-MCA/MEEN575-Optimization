function [xopt] = optimize()

    v_data = [-2.0000, -1.7895, -1.5789, -1.3684, -1.1579, -0.9474, -0.7368, -0.5263, -0.3158, -0.1053, 0.1053, 0.3158, 0.5263, 0.7368, 0.9474, 1.1579, 1.3684, 1.5789, 1.7895, 2.0000];
    f_data = [7.7859, 5.9142, 5.3145, 5.4135, 1.9367, 2.1692, 0.9295, 1.8957, -0.4215, 0.8553, 1.7963, 3.0314, 4.4279, 4.1884, 4.0957, 6.5956, 8.2930, 13.9876, 13.5700, 17.7481];

    x0 = ones(3,1);
    
    for i = 1:length(v_data)
        
        A(i,1) = v_data(i)^2;
        A(i,2) = v_data(i);
        A(i,3) = 1;
        
    end
    
    xopt = inv(transpose(A) * A) * transpose(A) * f_data';

    function values = model(x,v)
        
        values = x(1) .* v.^2 + x(2) .* v + x(3);
        
    end

    xfinal = min(v_data):0.01:max(v_data);
    objfinal = model(xopt,xfinal);

    h = figure();
    scatter(v_data,f_data,'DisplayName','Actual Data')
    hold on
    plot(xfinal,objfinal,'DisplayName','Fit')
    legend()
    title('Fitting Data')
    xlabel('Time')
    ylabel('Voltage')

end