function f = MLF2(x)
% MLF2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MLF2, see the previous cited paper for the original reference.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
y = 2 * x;

% Função objetivo 1
f1 = -(5 - ((x(1)^2 + x(2) - 11)^2 + (x(1) + x(2)^2 - 7)^2) / 200);

% Função objetivo 2
f2 = -(5 - ((y(1)^2 + y(2) - 11)^2 + (y(1) + y(2)^2 - 7)^2) / 200);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
