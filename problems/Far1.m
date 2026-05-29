function f = Far1(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example Far1, see the previous cited paper for the original reference.
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
%   Bounds: x1 in [-1,1], x2 in [-1,1]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Far1 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = -2*exp(15*(-(x(1)-0.1)^2 - x(2)^2)) ...
       - exp(20*(-(x(1)-0.6)^2 - (x(2)-0.6)^2)) ...
       + exp(20*(-(x(1)+0.6)^2 - (x(2)-0.6)^2)) ...
       + exp(20*(-(x(1)-0.6)^2 - (x(2)+0.6)^2)) ...
       + exp(20*(-(x(1)+0.6)^2 - (x(2)+0.6)^2));

f(2) = 2*exp(20*(-x(1)^2 - x(2)^2)) ...
       + exp(20*(-(x(1)-0.4)^2 - (x(2)-0.6)^2)) ...
       - exp(20*(-(x(1)+0.5)^2 - (x(2)-0.7)^2)) ...
       - exp(20*(-(x(1)-0.5)^2 - (x(2)+0.7)^2)) ...
       + exp(20*(-(x(1)+0.4)^2 - (x(2)+0.8)^2));

end
