function f = MOP5(x)
% MOP5 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP5, Van Valedhuizen's test suit.
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
% - Number of variables: 2
% - Number of objectives: 3
%   Bounds: x1 in [-30,30], x2 in [-30,30]
%
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 3-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = 0.5 * (x(1)^2 + x(2)^2) + sin(x(1)^2 + x(2)^2);

% Função objetivo 2
f2 = (3*x(1) - 2*x(2) + 4)^2 / 8 + (x(1) - x(2) + 1)^2 / 27 + 15;

% Função objetivo 3
f3 = 1 / (x(1)^2 + x(2)^2 + 1) - 1.1 * exp(-x(1)^2 - x(2)^2);

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema

end
