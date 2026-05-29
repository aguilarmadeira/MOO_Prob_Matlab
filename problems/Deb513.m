function f = Deb513(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%
%   Example 5.1.3 (Discontinuous Pareto-optimal Front).
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
%   Bounds: x1 in [0,1], x2 in [0,1]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Deb513 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
beta = 1;
alpha = 2;
q = 4;

% Initialize objectives
f = zeros(M, 1);

% Function f1
ff1 = x(1);

% g function
gx = 1 + 10*x(2);

% h function
h = 1 - (ff1/gx)^alpha - (ff1/gx)*sin(2*pi*q*ff1);

% Objective functions
f(1) = ff1;
f(2) = gx * h;

end
