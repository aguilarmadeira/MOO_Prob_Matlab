function f = DTLZ1(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ1.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%
%   CORRECTED MATLAB version by J. F. A. Madeira
%   November 16, 2025
%
%   CORRECTION: Restored multimodal g(x) with cosine term to match the
%   canonical DTLZ1 definition (Deb et al. 2002) and the AMPL .mod source.
%   DTLZ1 and DTLZ3 share the same multimodal g(x); they differ only in the objective functions (DTLZ1 linear simplex, DTLZ3 spherical).
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: n >= M (default n = 7 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1]
%
% - Pareto front: Linear simplex with sum(fi) = 0.5, fi in [0, 0.5]
%


% Fixed parameters for DTLZ1
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ1 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x) - MULTIMODAL (canonical DTLZ1, matches AMPL .mod)
% NOTE: DTLZ1 and DTLZ3 share the SAME multimodal g(x) (with cosine term).
% They differ only in the objective functions: DTLZ1 uses linear products of
% x(j) with factor 0.5 (linear simplex front); DTLZ3 uses cos(0.5*pi*x(j))
% (spherical front).
sum_term = 0;
for i = M:n
    sum_term = sum_term + ((x(i)-0.5)^2 - cos(20*pi*(x(i)-0.5)));
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
