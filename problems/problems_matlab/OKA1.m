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
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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
