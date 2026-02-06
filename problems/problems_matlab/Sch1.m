function f = Sch1(x)
% SCH1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example Sch1, see the previous cited paper for the original reference.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
if x <= 1
    f1 = -x;
elseif x <= 3
    f1 = -2 + x;
elseif x <= 4
    f1 = 4 - x;
else
    f1 = -4 + x;
end

% Função objetivo 2
f2 = (x-5)^2;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
