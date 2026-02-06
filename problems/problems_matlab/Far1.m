function f = Far1(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example Far1, see the previous cited paper for the original reference.
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
