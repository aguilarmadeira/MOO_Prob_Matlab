function f = MOP4(x)
% MOP4 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP4, Van Valedhuizen's test suit.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
f1 = 0;
for i = 1:2
    f1 = f1 + (-10 * exp(-0.2 * sqrt(x(i)^2 + x(i+1)^2)));
end

% Função objetivo 2
f2 = 0;
for i = 1:3
    f2 = f2 + (abs(x(i))^0.8 + 5*sin(x(i)^3));
end

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end
