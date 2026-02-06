function f = Fonseca(x)
%###############################################################################
%
%   As described by C.M. Fonseca and P.J. Fleming in "Multiobjective
%   Optimization and Multiple Constraint Handling with Evolutionary
%   Algorithms—Part I: A Unified Formulation", in IEEE Transactions 
%   on Systems, Man, and Cybernetics—Part A: Systems and Humans, 
%   vol. 28, no. 1, January 1998.
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
