function f = ex005(x)
%###############################################################################
%
%   ex005.mod
%   Original AMPL coding by Sven Leyffer, Argonne Natl. Lab.
%
%   A simple multi-objective optimization problem (p. 281):
%   C.-L. Hwang & A. S. Md. Masud, Multiple Objective
%   Decision Making - Methods and Applications, No. 164 in 
%   Lecture Notes in Economics and Mathematical Systems,
%   Springer, 1979.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2
% - Number of objectives: 2
%   Bounds: x1 in [-1,2], x2 in [1,2]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('ex005 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = x(1)^2 - x(2)^2;
f(2) = x(1) / x(2);

end
