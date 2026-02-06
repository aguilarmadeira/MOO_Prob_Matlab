function f = MOP6(x)
% MOP6 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP6, Van Valedhuizen's test suit.
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
f2 = (1 + 10*x(2)) * (1 - (x(1)/(1 + 10*x(2)))^2 - (x(1)/(1 + 10*x(2))) * sin(8*pi*x(1)));

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
