function f = lovison3(x)
% LOVISON3 function
%
%   As described by A. Lovison in "A synthetic approach to multiobjective
%   optimization", arxiv Item: http://arxiv.org/abs/1002.0093.
%
%   Example 3.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered 0<=x[1]<=6 and -4<=x[2]<=4.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
f1 = -(-x(1)^2-x(2)^2);

% Função objetivo 2
f2 = -(-(x(1)-6)^2+(x(2)+0.3)^2);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

end
