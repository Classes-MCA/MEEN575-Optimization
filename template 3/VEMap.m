function ve = VEMap(x)
%VEMAP Evaluate the engine model given engine speed and pressure ratio.
%   VEMAP(X) evaluates the engine model at the given engine speed X(1) and
%   the given pressure ratio X(2), and returns the volumetric efficiency.  
%
%   Syntax
%      ve = VEMap(x)
%
%   See also VEOptimization

% Copyright (c) 2012, The MathWorks, Inc.
% All rights reserved.

% Ideally data should not be loaded inside the objective function, as this
% code gets called several times by the optimization solver.  It is loaded
% in the objective function in this example purely to simplify the problem.  
% The following documentation page describes best practices for passing in 
% data to objective functions: 
% http://www.mathworks.com/help/releases/R2012b/optim/ug/passing-extra-parameters.html
load VEdata;

Xeval = linspace(1000,6000,300)';
Yeval = linspace(0,1,300)';

% Make them into a grid for use in surf
[xx,yy] = meshgrid(Xeval,Yeval);

% Construct the map from data points
zz = griddata(RPM,Pratio,VE,xx,yy,'cubic');

% Interpolate to get the columetric efficiency
ve = interp2(xx,yy,zz,x(1),x(2));

% Return a large objective function value if point is outside data range
if isnan(ve)
    ve = -1e10;
end