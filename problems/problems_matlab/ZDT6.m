function f = ZDT6(x)
% ZDT6 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T6.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
m = 10;
pi = 4*atan(1);

% Função objetivo 1 - Função não-uniforme
f1 = 1 - exp(-4*x(1)) * (sin(6*pi*x(1)))^6;

% Cálculo de g(x) - Usa potência de 1/4
gx = 1 + 9 * ((sum(x(2:m)))/(m-1))^0.25;

% Cálculo de h - Similar ao ZDT2: usa (f1/gx)^2
h = 1 - (f1/gx)^2;

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end
