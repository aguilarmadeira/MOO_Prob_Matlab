function f = DTLZ3n2(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ3 with M=2 and n=2.
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
if n ~= 2
    error('DTLZ3n2 requires exactly 2 variables, %d provided', n);
end

% Fixed parameters for this problem
M = 2;  % Number of objectives (fixed for DTLZ3n2)
k = n - M + 1;  % k = 2 - 2 + 1 = 1

x = x(:);
f = zeros(M, 1);

% Calculate g(x)
sum_term = 0;
for i = M:n
    sum_term = sum_term + ((x(i)-0.5)^2 - cos(20*pi*(x(i)-0.5)));
end
gx = 100 * (k + sum_term);

% Calculate objectives
f(1) = (1 + gx) * cos(0.5*pi*x(1));
f(2) = (1 + gx) * sin(0.5*pi*x(1));

end