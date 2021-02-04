clear; close all;

x(1,:) = [3,-5];
alpha = 0.1;
maxIter = 1000;

for i = 1:maxIter
    
    value(i) = objective(x(i,:));
    
    direction = -gradient(x(i,:));
    
    x(i+1,:) = x(i,:) + alpha .* direction;
    
    % If we don't decrease, try a smaller alpha
    if x(i+1,:) > x(i,:)
        x(i+1,:) = x(i,:) + alpha/2 .* direction;
        disp('Back-tracking')
    end
    
    disp(['Iteration: ',num2str(i),' x = ',num2str(x(i,:))])
    
    deltaX = x(i+1,:) - x(i,:);
    
    if norm(deltaX) < 10^-2
        disp(['Finished after ',num2str(i),' iterations.'])
        break
    end
    
end

value(end+1) = objective(x);

xpoints = -5:0.1:5;
ypoints = -5:0.1:5;

[X,Y] = meshgrid(xpoints,ypoints);

Z = X.^2 + Y.^2 - (3/2) .* X .* Y;

h1 = figure();
subplot(1,2,1)
contour(X,Y,Z,'LevelStep',1.0)
title('Contour View','FontSize',16)
hold on
plot(x(:,1),x(:,2),'r*')
xlabel('x_1')
ylabel('x_2')

subplot(1,2,2)
surf(X,Y,Z,'mesh','none')
title('Surface View','FontSize',16)
hold on
scatter3(x(:,1),x(:,2),value,'r*')
xlabel('x_1')
ylabel('x_2')
zlabel('f(x_1,x_2)')

sgtitle('Minimization Attempt','FontSize',25,'FontWeight','Bold')

h1.Units = 'Inches';
h1.Position = [1.4306 4.5694 14.9028 5.8333];

function f = objective(x)

    f = x(1).^2 +x(2).^2 - (3/2).*x(1).*x(2);

end

function g = gradient(x)

    g = [2*x(1) - (3/2)*x(2), 2*x(2) - (3/2)*x(1)];

end