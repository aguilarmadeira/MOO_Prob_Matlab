function f = MOP2(x)
% MOP2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP2, Van Valedhuizen's test suit.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 4-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Número de variáveis
n = 4;

% Função objetivo 1
sum1 = 0;
for i = 1:n
    sum1 = sum1 + (x(i) - 1/sqrt(n))^2;
end
f1 = 1 - exp(-sum1);

% Função objetivo 2
sum2 = 0;
for i = 1:n
    sum2 = sum2 + (x(i) + 1/sqrt(n))^2;
end
f2 = 1 - exp(-sum2);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
