function f = OKA1(x)
% OKA1 function
%
%   As described by T. Okabe, Y. Jin, M. Olhofer, and B. Sendhoff. "On test
%   functions for evolutionary multi-objective optimization.", Parallel
%   Problem Solving from Nature, VIII, LNCS 3242, Springer, pp.792-802,
%   September 2004.
%
%   Test function OKA1.
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

% Parâmetros
pi = 4*atan(1);

% Variáveis y
y = zeros(2,1);
y(1) = cos(pi/12)*x(1) - sin(pi/12)*x(2);
y(2) = sin(pi/12)*x(1) + cos(pi/12)*x(2);

% Função objetivo 1
f1 = y(1);

% Função objetivo 2
f2 = sqrt(2*pi) - sqrt(abs(y(1))) + 2*abs(y(2) - 3*cos(y(1)) - 3)^(1/3);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

% Note: As restrições são
% 6*sin(pi/12) <= x(1) <= 6*sin(pi/12) + 2*pi*cos(pi/12)
% -2*pi*sin(pi/12) <= x(2) <= 6*cos(pi/12)

end
