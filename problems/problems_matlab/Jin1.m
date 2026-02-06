function f = Jin1(x)
%###############################################################################
%
%   As described by Y. Jin, M. Olhofer and B. Sendhoff. "Dynamic weighted
%   aggregation for evolutionary multi-objective optimization: Why does it
%   work and how?", in Proceedings of Genetic and Evolutionary Computation 
%   Conference, pp.1042-1049, San Francisco, USA, 2001.
%
%   Test function 1, F1.
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
    error('Jin1 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = sum(x.^2)/n;
f(2) = sum((x-2).^2)/n;

end
