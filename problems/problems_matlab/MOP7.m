function f = MOP7(x)
% MOP7 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP7, Van Valedhuizen's test suit.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
f1 = (x(1)-2)^2 / 2 + (x(2)+1)^2 / 13 + 3;

% Função objetivo 2
f2 = (x(1)+x(2)-3)^2 / 36 + (-x(1)+x(2)+2)^2 / 8 - 17;

% Função objetivo 3
f3 = (x(1)+2*x(2)-1)^2 / 175 + (-x(1)+2*x(2))^2 / 17 - 13;

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema

end
