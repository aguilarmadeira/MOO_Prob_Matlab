function f = DG01(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example DG01, See the previous cited paper for the original reference.
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
% - Number of variables: 1 (fixed)
% - Number of objectives: 2 (fixed)
%   Bounds: x1 in [-10,13]
%
%

% Check dimension
n = length(x);
if n ~= 1
    error('DG01 requires exactly 1 variable, %d provided', n);
end

% Ensure x is a scalar
x = x(1);

% Objective functions
f = zeros(2, 1);
f(1) = sin(x);
f(2) = sin(x + 0.7);

end
