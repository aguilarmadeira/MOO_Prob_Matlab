function f = DTLZ4n2(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ4 with M=2 and n=2.
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
% - Number of variables: 2 (fixed)
% - Number of objectives: 2 (fixed)
% - Bounds: x in [0.0, 1.0]^2
%

n = length(x);
if n ~= 2
    error('DTLZ4n2 requires exactly 2 variables, %d provided', n);
end

% Fixed parameters for this problem
M = 2;  % Number of objectives (fixed for DTLZ4n2)
k = n - M + 1;  % k = 2 - 2 + 1 = 1
alpha = 100;

x = x(:);
f = zeros(M, 1);

% Transform variables
y = x.^alpha;

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + (y(i) - 0.5)^2;
end

% Calculate objectives
f(1) = (1 + gx) * cos(0.5*pi*y(1));
f(2) = (1 + gx) * sin(0.5*pi*y(1));

end
