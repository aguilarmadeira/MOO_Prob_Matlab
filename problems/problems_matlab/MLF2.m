function f = MLF2(x)
% MLF2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MLF2, see the previous cited paper for the original reference.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Cálculo da variável y
y = 2 * x;

% Função objetivo 1
f1 = -(5 - ((x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2) / 200);

% Função objetivo 2
f2 = -(5 - ((y(1)^2 + y(2) - 11)^2 + (y(1) + y(2)^2 - 7)^2) / 200);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
