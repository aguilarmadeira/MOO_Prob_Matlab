function f = SP1(x)
% SP1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example SP1, see the previous cited paper for the original reference.
%
%   In the above paper the variables bounds were not set.
%   We considered -1<=x[i]<=5, i=1,2.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
f1 = (x(1)-1)^2 + (x(1)-x(2))^2;

% Função objetivo 2
f2 = (x(2)-3)^2 + (x(1)-x(2))^2;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
