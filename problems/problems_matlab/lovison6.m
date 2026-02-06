function f = lovison6(x)
% LOVISON6 function
%
%   As described by A. Lovison in "A synthetic approach to multiobjective
%   optimization", arxiv Item: http://arxiv.org/abs/1002.0093.
%
%   Example 6.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered -1<=x[i]<=4, i=1,2,3.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
n = 3;   % número de variáveis
m = 4;   % número de funções usadas nos objetivos
pi = 4*atan(1);

% Matriz C (pontos distintos não colineares)
C = [
    0.218418, -0.620254, 0.843784, 0.914311;
    -0.788548, 0.428212, 0.103064, -0.47373;
    -0.300792, -0.185507, 0.330423, 0.151614
];

% Matriz alpha (diagonal definida negativa)
alpha = [
    0.942022, 0.363525, 0.00308876;
    0.755598, 0.450103, 0.170122;
    0.787748, 0.837808, 0.590166;
    0.203093, 0.253639, 0.532339
];

% Vetor beta
beta = [-0.666503; -0.945716; -0.334582; 0.611894];

% Vetor gamma
gamma = [0.281032; 0.508749; -0.0265389; -0.920133];

% Cálculo das funções f(j)
f_aux = zeros(m,1);
for j = 1:m
    f_aux(j) = 0;
    for i = 1:n
        f_aux(j) = f_aux(j) + (-alpha(j,i)*(x(i)-C(i,j))^2);
    end
end

% Função objetivo 1
f1 = -(f_aux(1) + beta(1)*exp(f_aux(4)/gamma(1)));

% Função objetivo 2
f2 = -(f_aux(2) + beta(2)*sin(pi*(x(1)+x(2))/gamma(2)));

% Função objetivo 3
f3 = -(f_aux(3) + beta(3)*cos(pi*(x(1)-x(2))/gamma(3)));

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

end
