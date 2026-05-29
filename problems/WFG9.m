function f = WFG9(z)
% WFG9 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG9.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: z is a n-dimensional vector where n = k+l (k=4, l=4)
%
%   Problem characteristics:
%   n = 8 (k=4 position-related, l=4 distance-related); M = 3 objectives.
%   Variable z_i has bound [0, 2*i] (z_i in [0, zmax_i], zmax_i = 2*i).
%   Bounds: x1 in [0,2], x2 in [0,4], x3 in [0,6], x4 in [0,8], x5 in [0,10], x6 in [0,12], x7 in [0,14], x8 in [0,16]
%
%   Output: f is a M-dimensional vector (M=3) with the function values

% Parameters
M = 3;      % number of objectives
k = 4;      % number of position-related variables
l = 4;      % number of distance-related variables
n = k + l;  % total number of variables

% Parameters S
S = zeros(M, 1);
for m = 1:M
    S(m) = 2*m;
end

% Parameters A
A = ones(M-1, 1);

% Parameters zmax
zmax = zeros(n, 1);
for i = 1:n
    zmax(i) = 2*i;
end

% Transform z into [0,1] set
y = zeros(n, 1);
for i = 1:n
    y(i) = z(i)/zmax(i);
end

% First level mapping - Similar to WFG7, but applied to first n-1 variables
w = ones(n, 1);  % default weight
AA = 0.98/49.98;
BB = 0.02;
CC = 50;
r_sum = zeros(n-1, 1);

% Calculate r_sum (weighted sum of positions of subsequent variables)
for i = 1:n-1
    sum_numerator = 0;
    sum_denominator = 0;
    for j = i+1:n
        sum_numerator = sum_numerator + w(j)*y(j);
        sum_denominator = sum_denominator + w(j);
    end
    r_sum(i) = sum_numerator / sum_denominator;
end

% Calculate t1
t1 = zeros(n, 1);
for i = 1:n
    if i <= n-1
        t1(i) = y(i)^(BB + (CC-BB)*(AA - (1-2*r_sum(i))*abs(floor(0.5-r_sum(i))+AA)));
    else
        t1(i) = y(i);
    end
end

% Second level mapping - Combines elements from WFG5 (for k) and WFG4 (for l)
AAA = 0.35;
BBB = 0.001;
CCC = 0.05;
AAAA = 30;
BBBB = 95;
CCCC = 0.35;
t2 = zeros(n, 1);

for i = 1:n
    if i <= k
        % For positional variables: deception function (like WFG5)
        t2(i) = 1 + (abs(t1(i)-AAA)-BBB) * ((floor(t1(i)-AAA+BBB)*(1-CCC+(AAA-BBB)/BBB))/(AAA-BBB) + (floor(AAA+BBB-t1(i))*(1-CCC+(1-AAA-BBB)/BBB))/(1-AAA-BBB) + 1/BBB);
    else
        % For distance variables: multimodal function (like WFG4)
        t2(i) = (1 + cos((4*AAAA+2)*pi*(0.5-abs(t1(i)-CCCC)/(2*(floor(CCCC-t1(i))+CCCC)))) + 4*BBBB*(abs(t1(i)-CCCC)/(2*(floor(CCCC-t1(i))+CCCC)))^2) / (BBBB+2);
    end
end

% Third level mapping - Based on WFG6
t3 = zeros(M, 1);

for i = 1:M
    if i <= M-1
        % For position-related variables
        k_per_group = k/(M-1);
        start_idx = floor((i-1)*k_per_group) + 1;
        end_idx = floor(i*k_per_group);
        num_vars = end_idx - start_idx + 1;
        
        sum_val = 0;
        for ii = start_idx:end_idx
            inner_sum = 0;
            for jj = 0:(k_per_group-2)
                % Index calculation with modulo for cyclic pairs
                idx1 = ii;
                tmp = mod(ii + jj - start_idx + 1, num_vars);
                if tmp == 0
                    tmp = num_vars;
                end
                idx2 = start_idx + tmp - 1;
                inner_sum = inner_sum + abs(t2(idx1) - t2(idx2));
            end
            sum_val = sum_val + (t2(ii) + inner_sum);
        end
        
        divisor = (num_vars / k_per_group) * ceil(k_per_group/2) * (1 + 2*k_per_group - 2*ceil(k_per_group/2));
        t3(i) = sum_val / divisor;
    else
        % For distance-related variables
        sum_val = 0;
        for ii = k+1:n
            inner_sum = 0;
            for jj = 0:(l-2)
                % Index calculation with modulo for cyclic pairs
                idx1 = ii;
                tmp = mod(ii + jj - (k+1) + 1, n-k);
                if tmp == 0
                    tmp = n-k;
                end
                idx2 = k + 1 + tmp - 1;
                inner_sum = inner_sum + abs(t2(idx1) - t2(idx2));
            end
            sum_val = sum_val + (t2(ii) + inner_sum);
        end
        
        divisor = ((n-k) / l) * ceil(l/2) * (1 + 2*l - 2*ceil(l/2));
        t3(i) = sum_val / divisor;
    end
end

% Define objective function variables
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t3(M), A(i))*(t3(i)-0.5)+0.5;
    else
        x(i) = t3(M);
    end
end

% Define objective function h
h = zeros(M, 1);

% Compute h[1]
h(1) = 1.0;
for i = 1:M-1
    h(1) = h(1) * sin(x(i)*pi/2);
end

% Compute h[m] for m = 2,...,M-1
for m = 2:M-1
    h(m) = 1.0;
    for i = 1:M-m
        h(m) = h(m) * sin(x(i)*pi/2);
    end
    h(m) = h(m) * cos(x(M-m+1)*pi/2);
end

% Compute h[M]
h(M) = cos(x(1)*pi/2);

% The objective functions
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m)*h(m);
end

end
