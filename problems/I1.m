function f = I1(z)
%###############################################################################
%
%   As described by Huband et al. in "A Scalable Multi-objective Test Problem
%   Toolkit", in C. A. Coello Coello et al. (Eds.): EMO 2005, LNCS 3410, 
%   pp. 280–295, 2005, Springer-Verlag Berlin Heidelberg 2005.
%
%   Example I1.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 8 (k=4, l=4)
% - Number of objectives: 3
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1]
%
%


% Parameters
M = 3; % Number of objectives (fixed)
k = 4;
l = 4;
n = k + l;

% Check dimension
if length(z) ~= n
    error('I1 requires exactly %d variables, %d provided', n, length(z));
end

% Ensure z is a column vector
z = z(:);

% Constants
pi2 = pi/2;
S = ones(M, 1);
A = ones(M-1, 1);

% Transform z into [0,1] set
zmax = ones(n, 1);
y = z ./ zmax;

% First level mapping
t1 = y;

% Second level mapping
t2 = zeros(n, 1);
for i = 1:n
    if i <= k
        t2(i) = t1(i);
    else
        t2(i) = abs(t1(i) - 0.35) / abs(floor(0.35 - t1(i)) + 0.35);
    end
end

% Third level mapping
w = ones(n, 1);
t3 = zeros(M, 1);
for i = 1:M
    if i <= M-1
        j_start = (i-1)*k/(M-1) + 1;
        j_end = i*k/(M-1);
        indices = round(j_start):round(j_end);
        t3(i) = sum(w(indices) .* t2(indices)) / sum(w(indices));
    else
        indices = (k+1):n;
        t3(i) = sum(w(indices) .* t2(indices)) / sum(w(indices));
    end
end

% Define objective function variables
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t3(M), A(i)) * (t3(i) - 0.5) + 0.5;
    else
        x(i) = t3(M);
    end
end

% Define shape function h
h = zeros(M, 1);
for m = 1:M
    if m == 1
        h(m) = 1;
        for i = 1:M-1
            h(m) = h(m) * sin(x(i) * pi2);
        end
    elseif m <= M-1
        h(m) = 1;
        for i = 1:M-m
            h(m) = h(m) * sin(x(i) * pi2);
        end
        h(m) = h(m) * cos(x(M-m+1) * pi2);
    else
        h(m) = cos(x(1) * pi2);
    end
end

% Calculate objectives
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m) * h(m);
end

end
