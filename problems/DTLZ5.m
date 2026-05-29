function f = DTLZ5(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ5.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. CustÃ³dio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
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
% - Number of variables: n >= M (default n = 12 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1], x11 in [0,1], x12 in [0,1]
%
%


% Fixed parameters for DTLZ5
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ5 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + x(i)^0.1;
end

% Calculate theta
theta = zeros(n, 1);
for i = 2:n
    theta(i) = (pi/2) * (1 + 2*gx*x(i)) / (2*(1 + gx));
end

% Calculate objectives
if M >= 2
    % f1
    prod_term = 1;
    for j = 2:(M-1)
        prod_term = prod_term * cos(theta(j));
    end
    f(1) = (1 + gx) * cos(0.5*pi*x(1)) * prod_term;
    
    % f2 to f(M-1)
    for i = 2:(M-1)
        prod_term = 1;
        for j = 2:(M-i)
            prod_term = prod_term * cos(theta(j));
        end
        f(i) = (1 + gx) * cos(0.5*pi*x(1)) * prod_term * sin(theta(M-i+1));
    end
    
    % fM
    f(M) = (1 + gx) * sin(0.5*pi*x(1));
end

end
