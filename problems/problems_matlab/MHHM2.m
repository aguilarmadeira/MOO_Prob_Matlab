function f = MHHM2(x)
% MHHM2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MHHM2, see the previous cited paper for the original reference.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 3-dimensional vector with the function values
%
% Problem characteristics:
% - Number of variables: 2 (fixed)
% - Number of objectives: 3 (fixed)
% - Bounds: x in [0, 1]^2

% Check dimension
n = length(x);
if n ~= 2
    error('MHHM2 requires exactly 2 variables, %d provided', n);
end

% Objective functions
f = zeros(3, 1);
f(1) = (x(1) - 0.8)^2 + (x(2) - 0.6)^2;
f(2) = (x(1) - 0.85)^2 + (x(2) - 0.7)^2;
f(3) = (x(1) - 0.9)^2 + (x(2) - 0.6)^2;

end
