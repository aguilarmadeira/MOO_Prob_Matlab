function f = SP1(x)
% SP1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example SP1, see the previous cited paper for the original reference.
%
%   In the above paper the variables bounds were not set.
%   We considered -1<=x[i]<=5, i=1,2.
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
% - Number of objectives: 2
%   Bounds: x1 in [-1,5], x2 in [-1,5]
%
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = (x(1)-1)^2 + (x(1)-x(2))^2;

% Função objetivo 2
f2 = (x(2)-3)^2 + (x(1)-x(2))^2;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
