function f = FES3(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example FES3, see the previous cited paper for the original reference.
%
%   In the above paper the number of variables was left undefined. 
%   We selected n=10 as default.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
M = 4; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 10
    error('FES3 requires exactly 10 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
sum1 = 0;
sum2 = 0;
sum3 = 0;
sum4 = 0;
for i = 1:n
    sum1 = sum1 + abs(x(i) - exp((i/n)^2)/3)^0.5;
    sum2 = sum2 + abs(x(i) - sin(i-1)^2 * cos(i-1)^2)^0.5;
    sum3 = sum3 + abs(x(i) - 0.25*cos(i-1)*cos(2*(i-1)) - 0.5)^0.5;
    sum4 = sum4 + (x(i) - 0.5*sin(1000*pi*i/n) - 0.5)^2;
end

f(1) = sum1;
f(2) = sum2;
f(3) = sum3;
f(4) = sum4;

end
