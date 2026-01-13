function f = DTLZ1_5(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ1 with M = 5 objectives.
%
%   CORRECTED VERSION - November 2025
%   CRITICAL FIX: Removed cosine terms from g(x)
%   DTLZ1 has LINEAR g(x), DTLZ3 has MULTIMODAL g(x) with cosine terms
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization.
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: n >= 5 (recommended n = 14, i.e., k = 10)
% - Number of objectives: M = 5 (fixed)
% - Bounds: x in [0.0, 1.0]^n
% - Pareto front: Linear simplex with sum(fi) = 0.5, fi in [0, 0.5]
%

% Get dimension
n = length(x);

% Fixed parameters
M = 5;  % Number of objectives (fixed for DTLZ1_5)
k = n - M + 1;  % Calculate k from dimension

% Check minimum dimension
if n < M
    error('DTLZ1_5 requires n >= M, but n = %d and M = %d', n, M);
end

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

% f2 to fM
for i = 2:M
    prod_term = 1;
    for j = 1:(M-i)
        prod_term = prod_term * x(j);
    end
    f(i) = 0.5 * (1 + gx) * prod_term * (1 - x(M-i+1));
end

end
