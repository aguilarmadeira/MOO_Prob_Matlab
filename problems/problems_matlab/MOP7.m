function f = MOP7(x)
% MOP7 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP7, Van Valedhuizen's test suit.
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
%   Output: f is a 3-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = (x(1)-2)^2 / 2 + (x(2)+1)^2 / 13 + 3;

% Função objetivo 2
f2 = (x(1)+x(2)-3)^2 / 36 + (-x(1)+x(2)+2)^2 / 8 - 17;

% Função objetivo 3
f3 = (x(1)+2*x(2)-1)^2 / 175 + (-x(1)+2*x(2))^2 / 17 - 13;

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema

end
