function f = WFG5(z)
% WFG5 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG5.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
% Problem characteristics:
% - Number of variables: 8
% - Number of objectives: 3
%   Bounds: x1 in [0,2], x2 in [0,4], x3 in [0,6], x4 in [0,8], x5 in [0,10], x6 in [0,12], x7 in [0,14], x8 in [0,16]
%
%
%   Input: z is a n-dimensional vector where n = k+l (k=4, l=4)
%   Output: f is a M-dimensional vector (M=3) with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
M = 3;      % número de objetivos
k = 4;      % número de variáveis relacionadas à posição
l = 4;      % número de variáveis relacionadas à distância
n = k + l;  % número total de variáveis

pi = 4*atan(1);
pi2 = 2*atan(1);

% Parâmetros S
S = zeros(M, 1);
for m = 1:M
    S(m) = 2*m;
end

% Parâmetros A
A = ones(M-1, 1);  % neq WFG3

% Parâmetros zmax
zmax = zeros(n, 1);
for i = 1:n
    zmax(i) = 2*i;
end

% Transform z into [0,1] set
y = zeros(n, 1);
for i = 1:n
    y(i) = z(i)/zmax(i);
end

% First level mapping - Diferente de WFG4, função de decepção
AA = 0.35;
BB = 0.001;
CC = 0.05;
t1 = zeros(n, 1);
for i = 1:n
    t1(i) = 1 + (abs(y(i)-AA)-BB) * ((floor(y(i)-AA+BB)*(1-CC+(AA-BB)/BB))/(AA-BB) + (floor(AA+BB-y(i))*(1-CC+(1-AA-BB)/BB))/(1-AA-BB) + 1/BB);
end

% Second level mapping - Idêntico ao WFG4
w = ones(n, 1);
t2 = zeros(M, 1);

for i = 1:M
    if i <= M-1
        numerator = 0;
        denominator = 0;
        for j = floor((i-1)*k/(M-1))+1 : floor(i*k/(M-1))
            numerator = numerator + w(j)*t1(j);
            denominator = denominator + w(j);
        end
        t2(i) = numerator / denominator;
    else
        numerator = 0;
        denominator = 0;
        for j = k+1 : n
            numerator = numerator + w(j)*t1(j);
            denominator = denominator + w(j);
        end
        t2(i) = numerator / denominator;
    end
end

% Define objective function variables - Idêntico ao WFG4
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t2(M), A(i))*(t2(i)-0.5)+0.5;
    else
        x(i) = t2(M);
    end
end

% Define objective function function h - Idêntico ao WFG4
h = zeros(M, 1);

% Compute h[1]
h(1) = 1.0;
for i = 1:M-1
    h(1) = h(1) * sin(x(i)*pi2);
end

% Compute h[m] for m = 2,...,M-1
for m = 2:M-1
    h(m) = 1.0;
    for i = 1:M-m
        h(m) = h(m) * sin(x(i)*pi2);
    end
    h(m) = h(m) * cos(x(M-m+1)*pi2);
end

% Compute h[M]
h(M) = cos(x(1)*pi2);

% The objective functions - Idêntico ao WFG4
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m)*h(m);
end

% Não há restrições de desigualdade para este problema

end
