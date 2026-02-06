function f = Deb512a(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation
%   7(3): 205-230, 1999.
%              
%   Example 5.1.2 (Convex Pareto-optimal Front).
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Deb512a requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
beta = 1;
alpha = 0.25;

% Initialize objectives
f = zeros(M, 1);

% Function f1
ff1 = 4 * x(1);

% g function
if x(2) <= 0.4
    gx = 4 - 3*exp(-((x(2)-0.2)/0.02)^2);
else
    gx = 4 - 2*exp(-((x(2)-0.7)/0.2)^2);
end

% h function
if ff1 <= beta*gx
    h = 1 - (ff1/(beta*gx))^alpha;
else
    h = 0;
end

% Objective functions
f(1) = ff1;
f(2) = gx * h;

end
