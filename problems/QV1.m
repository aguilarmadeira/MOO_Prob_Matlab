function f = QV1(x)
% QV1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example QV1, see the previous cited paper for the original reference.
%
%   In the original reference the number of variables was n=16. 
%   We selected n=10 as default.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
% Problem characteristics:
% - Number of variables: 10
% - Number of objectives: 2
%   Bounds: x1 in [-5.12,5.12], x2 in [-5.12,5.12], x3 in [-5.12,5.12], x4 in [-5.12,5.12], x5 in [-5.12,5.12], x6 in [-5.12,5.12], x7 in [-5.12,5.12], x8 in [-5.12,5.12], x9 in [-5.12,5.12], x10 in [-5.12,5.12]
%
%
%   Input: x is a 10-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
pi = 4*atan(1);
n = 10;

% Função objetivo 1
sum1 = 0;
for i = 1:n
    sum1 = sum1 + (x(i)^2 - 10*cos(2*pi*x(i)) + 10);
end
f1 = (sum1/n)^0.25;

% Função objetivo 2
sum2 = 0;
for i = 1:n
    sum2 = sum2 + ((x(i)-1.5)^2 - 10*cos(2*pi*(x(i)-1.5)) + 10);
end
f2 = (sum2/n)^0.25;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
