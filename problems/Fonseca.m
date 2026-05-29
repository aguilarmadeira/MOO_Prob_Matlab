function f = Fonseca(x)
%###############################################################################
%
%   As described by C.M. Fonseca and P.J. Fleming in "Multiobjective
%   Optimization and Multiple Constraint Handling with Evolutionary
%   Algorithms—Part I: A Unified Formulation", in IEEE Transactions 
%   on Systems, Man, and Cybernetics—Part A: Systems and Humans, 
%   vol. 28, no. 1, January 1998.
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
%   Bounds: x1 in [-4,4], x2 in [-4,4]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Fonseca requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = 1 - exp(-(x(1)-1)^2 - (x(2)+1)^2);
f(2) = 1 - exp(-(x(1)+1)^2 - (x(2)-1)^2);

end
