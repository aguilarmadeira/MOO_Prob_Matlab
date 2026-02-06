function f = I4(z)
%###############################################################################
%
%   As described by Huband et al. in "A Scalable Multi-objective Test Problem
%   Toolkit", in C. A. Coello Coello et al. (Eds.): EMO 2005, LNCS 3410, 
%   pp. 280–295, 2005, Springer-Verlag Berlin Heidelberg 2005.
%
%   Example I4.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
M = 3; % Number of objectives (fixed)
k = 4;
l = 4;
n = k + l;

% Check dimension
if length(z) ~= n
    error('I4 requires exactly %d variables, %d provided', n, length(z));
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
t3 = zeros(M, 1);
for i = 1:M
    if i <= M-1
        % Complex calculation for position-related transformation
        j_start = round((i-1)*k/(M-1) + 1);
        j_end = round(i*k/(M-1));
        
        sum_val = 0;
        count = 0;
        for ii = j_start:j_end
            inner_sum = t2(ii);
            for jj = 0:(k/(M-1)-2)
                idx = j_start + mod(ii + jj - j_start + 1, j_end - j_start + 1);
                inner_sum = inner_sum + abs(t2(ii) - t2(idx));
            end
            sum_val = sum_val + inner_sum;
            count = count + 1;
        end
        
        denominator = count / (k/(M-1)) * ceil(k/(M-1)/2) * (1 + 2*k/(M-1) - 2*ceil(k/(M-1)/2));
        if denominator == 0
            t3(i) = sum_val;
        else
            t3(i) = sum_val / denominator;
        end
    else
        % For the last objective
        sum_val = 0;
        count = 0;
        for ii = (k+1):n
            inner_sum = t2(ii);
            for jj = 0:(l-2)
                idx = k + 1 + mod(ii + jj - (k+1) + 1, n - k);
                inner_sum = inner_sum + abs(t2(ii) - t2(idx));
            end
            sum_val = sum_val + inner_sum;
            count = count + 1;
        end
        
        denominator = (count/l) * ceil(l/2) * (1 + 2*l - 2*ceil(l/2));
        if denominator == 0
            t3(i) = sum_val;
        else
            t3(i) = sum_val / denominator;
        end
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
