function f = CAM2(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   J. F. A. Madeira
%   Discrete Direct Multisearch for Multiobjective Optimization, 2021.
%
%   Written by the authors in February 24, 2021.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2
% - Number of objectives: 2
%   Bounds: x1 in [0.1,1], x2 in [0,1]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('CAM2 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% g function
gx = 2 - exp(-((x(2)-0.2)/0.004)^2) - 0.8*exp(-((x(2)-0.6)/0.4)^2) - 1.2*exp(-((x(2)-0.9)/0.002)^2);

% Objective functions
f(1) = x(1);
f(2) = gx/x(1);

end
