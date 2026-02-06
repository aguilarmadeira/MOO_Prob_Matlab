function f = OKA2(x)
% OKA2 function
%
%   As described by T. Okabe, Y. Jin, M. Olhofer, and B. Sendhoff. "On test
%   functions for evolutionary multi-objective optimization.", Parallel
%   Problem Solving from Nature, VIII, LNCS 3242, Springer, pp.792-802,
%   September 2004.
%
%   Test function OKA2.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
pi = 4*atan(1);

% Função objetivo 1
f1 = x(1);

% Função objetivo 2
f2 = 1 - (x(1) + pi)^2 / (4 * pi^2) + abs(x(2) - 5*cos(x(1)))^(1/3) + abs(x(3) - 5*sin(x(1)))^(1/3);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

% Note: As restrições são
% -pi <= x(1) <= pi
% -5 <= x(2) <= 5
% -5 <= x(3) <= 5

end
