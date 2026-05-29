function f = SK1(x)
% SK1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example SK1, see the previous cited paper for the original reference.
%   Function f2 differs in the original and in the cited references. The herein 
%   codification follows the original reference.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered -10<=x<=10.
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
% - Number of variables: 1
% - Number of objectives: 2
%   Bounds: x1 in [-10,10]
%
%
%   Input: x is a scalar variable
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Função objetivo 1
f1 = -(-x^4 - 3*x^3 + 10*x^2 + 10*x + 10);

% Função objetivo 2
f2 = -(0.5*x^4 + 2*x^3 + 10*x^2 - 10*x + 5);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
