function f = MOP3(x)
% MOP3 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP3, Van Valedhuizen's test suit.
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
A1 = 0.5*sin(1) - 2*cos(1) + sin(2) - 1.5*cos(2);
A2 = 1.5*sin(1) - cos(1) + 2*sin(2) - 0.5*cos(2);

% Variáveis adicionais
B1 = 0.5*sin(x(1)) - 2*cos(x(1)) + sin(x(2)) - 1.5*cos(x(2));
B2 = 1.5*sin(x(1)) - cos(x(1)) + 2*sin(x(2)) - 0.5*cos(x(2));

% Função objetivo 1
f1 = -(-1 - (A1-B1)^2 - (A2-B2)^2);

% Função objetivo 2
f2 = -(-(x(1)+3)^2 - (x(2)+1)^2);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
