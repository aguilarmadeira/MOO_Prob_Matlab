function f = Deb513(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%
%   Example 5.1.3 (Discontinuous Pareto-optimal Front).
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
