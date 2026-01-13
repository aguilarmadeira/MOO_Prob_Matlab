function f = Kursawe(x)
%###############################################################################
%
%   As described by F. Kursawe in "A variant of evolution strategies for
%   vector optimization", in H. P. Schwefel and R. Männer, editors, Parallel 
%   Problem Solving from Nature, 1st Workshop, PPSN I, volume 496 of Lecture 
%   Notes in Computer Science, pages 193-197, Berlin, Germany, Oct 1991, 
%   Springer-Verlag.
%
%   In the above paper the variables bounds were not set.
%   We considered -5.0 <= x[i] <= 5.0, i=1,2,3.
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
% - Number of variables: 3
% - Number of objectives: 2
% - Bounds: x in [-5.0, 5.0] x [-5.0, 5.0] x [-5.0, 5.0]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 3
    error('Kursawe requires exactly 3 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = 0;
for i = 1:n-1
    f(1) = f(1) - 10*exp(-0.2*sqrt(x(i)^2 + x(i+1)^2));
end

f(2) = 0;
for i = 1:n
    f(2) = f(2) + abs(x(i))^0.8 + 5*sin(x(i))^3;
end

end
