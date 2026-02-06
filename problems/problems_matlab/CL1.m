function f = CL1(x)
%###############################################################################
%
%   As described by F.Y. Cheng and X.S. Li, "Generalized center method for
%   multiobjective engineering optimization", Engineering Optimization,31:5,
%   641-661, 1999.
%
%   Example 2, four bar truss.
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
if n ~= 4
    error('CL1 requires exactly 4 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
F = 10;
E = 2e5;
L = 200;
sigma = 10;

% Objective functions
f = zeros(2, 1);
f(1) = L * (2*x(1) + sqrt(2)*x(2) + sqrt(x(3)) + x(4));
f(2) = F*L/E * (2/x(1) + (2*sqrt(2))/x(2) - (2*sqrt(2))/x(3) + 2/x(4));

end
