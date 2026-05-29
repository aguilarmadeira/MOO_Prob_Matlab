function f = CL1(x)
%###############################################################################
%
%   As described by F.Y. Cheng and X.S. Li, "Generalized center method for
%   multiobjective engineering optimization", Engineering Optimization,31:5,
%   641-661, 1999.
%
%   Example 2, four bar truss.
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
% - Number of variables: 4 (fixed)
% - Number of objectives: 2 (fixed)
%   Bounds: x1 in [1,3], x2 in [1.41421356237,3], x3 in [1.41421356237,3], x4 in [1,3]
%
%

% Check dimension
n = length(x);
if n ~= 4
    error('CL1 requires exactly 4 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
F = 10;
E = 2e5;
L = 200;
sigma = 10;

% Objective functions
f = zeros(2, 1);
f(1) = L * (2*x(1) + sqrt(2)*x(2) + sqrt(x(3)) + x(4));
f(2) = F*L/E * (2/x(1) + (2*sqrt(2))/x(2) - (2*sqrt(2))/x(3) + 2/x(4));

end
