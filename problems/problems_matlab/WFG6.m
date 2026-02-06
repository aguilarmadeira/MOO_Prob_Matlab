function f = WFG6(z)
% WFG6 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG6.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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

% First level mapping
t1 = zeros(n, 1);
for i = 1:n
    if i <= k
        t1(i) = y(i);
    else
        t1(i) = abs(y(i)-0.35)/abs(floor(0.35-y(i))+0.35);
    end
end

% Second level mapping
t2 = zeros(M, 1);

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
                inner_sum = inner_sum + abs(t1(idx1) - t1(idx2));
            end
            sum_val = sum_val + (t1(ii) + inner_sum);
        end
        
        divisor = (num_vars / k_per_group) * ceil(k_per_group/2) * (1 + 2*k_per_group - 2*ceil(k_per_group/2));
        t2(i) = sum_val / divisor;
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
                inner_sum = inner_sum + abs(t1(idx1) - t1(idx2));
            end
            sum_val = sum_val + (t1(ii) + inner_sum);
        end
        
        divisor = ((n-k) / l) * ceil(l/2) * (1 + 2*l - 2*ceil(l/2));
        t2(i) = sum_val / divisor;
    end
end

% Define objective function variables
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t2(M), A(i))*(t2(i)-0.5)+0.5;
    else
        x(i) = t2(M);
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
