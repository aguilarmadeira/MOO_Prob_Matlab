function varargout = WFG9(varargin)
%WFG9  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: WFG9
% Dimension: n = 8, objectives m = 3
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = WFG9();
%   [lb,ub] = WFG9('bounds');
%   F = WFG9(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = WFG9_orig(x_orig)

nloc = 8;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG9';
    info.n = nloc; info.m = mloc;
    info.strategy = 'baseline';
    info.kappa = 1;
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
F = WFG9_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to WFG9_orig)
% -------------------------------------------------------------------------
function f = WFG9_orig(z)
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

