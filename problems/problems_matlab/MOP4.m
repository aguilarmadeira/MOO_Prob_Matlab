function f = MOP4(x)
% MOP4 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP4, Van Valedhuizen's test suit.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 3-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = 0;
for i = 1:2
    f1 = f1 + (-10 * exp(-0.2 * sqrt(x(i)^2 + x(i+1)^2)));
end

% Função objetivo 2
f2 = 0;
for i = 1:3
    f2 = f2 + (abs(x(i))^0.8 + 5*sin(x(i)^3));
end

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
