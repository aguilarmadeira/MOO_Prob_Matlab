function f = DTLZ1n2(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ1 with M=2 and n=2.
%
%   CORRECTED VERSION - November 2025
%   CRITICAL FIX: Removed cosine terms from g(x)
%   DTLZ1 has LINEAR g(x), DTLZ3 has MULTIMODAL g(x) with cosine terms
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2 (fixed)
% - Number of objectives: 2 (fixed)
% - Bounds: x in [0.0, 1.0]^2
% - Pareto front: Linear with f1 + f2 = 0.5, fi in [0, 0.5]
%

n = length(x);
if n ~= 2
    error('DTLZ1n2 requires exactly 2 variables, %d provided', n);
end

% Fixed parameters for this problem
M = 2;  % Number of objectives (fixed for DTLZ1n2)
k = n - M + 1;  % k = 2 - 2 + 1 = 1

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x) - LINEAR VERSION (DTLZ1)
% CRITICAL: This is DIFFERENT from DTLZ3 which includes cosine terms
sum_term = 0;
for i = M:n
    sum_term = sum_term + (x(i) - 0.5)^2;
end
gx = 100 * (k + sum_term);

% Alternative vectorized implementation:
% gx = 100 * (k + sum((x(M:n) - 0.5).^2));

% Calculate objectives
% f1
prod_term = 1;
for j = 1:(M-1)
    prod_term = prod_term * x(j);
end
f(1) = 0.5 * (1 + gx) * prod_term;

% f2
f(2) = 0.5 * (1 + gx) * (1 - x(1));

end