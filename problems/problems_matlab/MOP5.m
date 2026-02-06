function f = MOP5(x)
% MOP5 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP5, Van Valedhuizen's test suit.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
f1 = 0.5 * (x(1)^2 + x(2)^2) + sin(x(1)^2 + x(2)^2);

% Função objetivo 2
f2 = (3*x(1) - 2*x(2) + 4)^2 / 8 + (x(1) - x(2) + 1)^2 / 27 + 15;

% Função objetivo 3
f3 = 1 / (x(1)^2 + x(2)^2 + 1) - 1.1 * exp(-x(1)^2 - x(2)^2);

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema

end
