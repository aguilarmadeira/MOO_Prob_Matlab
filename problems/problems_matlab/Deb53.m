function f = Deb53(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%
%   Example 5.1.3 (Non-uniformly Represented Pareto-optimal Front).
%
%   In the above paper the variables bounds were not set.
%   We considered 0.0 <= x[i] <= 1.0, i=1,2. The function f1 corresponds
%   to equation (16) and gx to equation (10).
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2
% - Number of objectives: 2
% - Bounds: x in [0.0, 1.0] x [0.0, 1.0]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Deb53 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
gamma = 1.0;
beta = 1.0;
alpha = 4;

% Initialize objectives
f = zeros(M, 1);

% Function f1
ff1 = 1 - exp(-4*x(1)) * sin(5*pi*x(1))^4;

% g function
if x(2) <= 0.4
    gx = 4 - 3*exp(-((x(2)-0.2)/0.02)^2);
else
    gx = 4 - 2*exp(-((x(2)-0.7)/0.2)^2);
end

% h function
if ff1 < beta*gx
    h = 1 - (ff1/(beta*gx))^alpha;
else
    h = 0;
end

% Objective functions
f(1) = ff1;
f(2) = gx * h;

end
