function f = DTLZ3_4(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ3 with M = 4 objectives.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
n = length(x);

% Fixed parameters
M = 4;  % Number of objectives (fixed for DTLZ3_4)
k = n - M + 1;  % Calculate k from dimension

% Check minimum dimension
if n < M
    error('DTLZ3_4 requires n >= M, but n = %d and M = %d', n, M);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
sum_term = 0;
for i = M:n
    sum_term = sum_term + ((x(i)-0.5)^2 - cos(20*pi*(x(i)-0.5)));
end
gx = 100 * (k + sum_term);

% Calculate objectives
% f1
prod_term = 1;
for j = 1:(M-1)
    prod_term = prod_term * cos(0.5*pi*x(j));
end
f(1) = (1 + gx) * prod_term;

% f2 to fM
for i = 2:M
    prod_term = 1;
    for j = 1:(M-i)
        prod_term = prod_term * cos(0.5*pi*x(j));
    end
    f(i) = (1 + gx) * prod_term * sin(0.5*pi*x(M-i+1));
end

end
