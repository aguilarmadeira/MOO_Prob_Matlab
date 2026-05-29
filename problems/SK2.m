function f = SK2(x)
% SK2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example SK2, see the previous cited paper for the original reference.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered -10<=x[i]<=10, i=1,2,3,4.
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
% - Number of variables: 4
% - Number of objectives: 2
%   Bounds: x1 in [-10,10], x2 in [-10,10], x3 in [-10,10], x4 in [-10,10]
%
%
%   Input: x is a 4-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Função objetivo 1
f1 = -(-(x(1)-2)^2 - (x(2)+3)^2 - (x(3)-5)^2 - (x(4)-4)^2 + 5);

% Função objetivo 2
sum_sin = 0;
sum_square = 0;
for i = 1:4
    sum_sin = sum_sin + sin(x(i));
    sum_square = sum_square + x(i)^2;
end
f2 = -(sum_sin / (1 + sum_square/100));

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
