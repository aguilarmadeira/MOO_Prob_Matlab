function varargout = WFG6(varargin)
%WFG6  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: WFG6
% Dimension: n = 8, objectives m = 3
% Strategy: progressive (kappa = 1000000)
% Effective contrast: 1000000
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = WFG6();
%   [lb,ub] = WFG6('bounds');
%   F = WFG6(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = WFG6_orig(x_orig)

nloc = 8;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [1;10;100;1000;0.1;0.01;0.001;1];
scale_factors = [1;10;100;1000;0.1;0.01;0.001;1];
contrast_ratio = 1000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG6';
    info.n = nloc; info.m = mloc;
    info.strategy = 'progressive';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
    varargout{1} = info;
    return;
end

arg1 = varargin{1};
if ischar(arg1) && strcmpi(arg1,'bounds')
    varargout{1} = lb_work;
    if nargout >= 2, varargout{2} = ub_work; end
    return;
end

x = arg1(:);
if numel(x) ~= nloc
    error('Input x must have 8 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = WFG6_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to WFG6_orig)
% -------------------------------------------------------------------------
function f = WFG6_orig(z)
% WFG6 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG6.
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

