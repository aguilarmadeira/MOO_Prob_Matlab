function varargout = WFG9(varargin)
%WFG9  WFG9 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 1255.09     ]   (range: 1255.09     )
%   x2   ∈ [0           , 888.801     ]   (range: 888.801     )
%   x3   ∈ [0           , 5953.39     ]   (range: 5953.39     )
%   x4   ∈ [0           , 3196.61     ]   (range: 3196.61     )
%   x5   ∈ [0           , 6100.19     ]   (range: 6100.19     )
%   x6   ∈ [0           , 208455      ]   (range: 208455      )
%   x7   ∈ [0           , 1.06462e+07 ]   (range: 1.06462e+07 )
%   x8   ∈ [0           , 5681.67     ]   (range: 5681.67     )
%
% Effective contrast ratio (max range / min range): 3422.321744045506
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = WFG9(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = WFG9('bounds')  % Get bounds
%   info = WFG9()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 8;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0];
ub_orig = [2;4;6;8;10;12;14;16];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [1255.086999408392;888.8014338588636;5953.394185299519;3196.606876592183;6100.191862414372;208454.7157454599;10646175.65631904;5681.674814176435];
scale_factors = [627.5434997041958;222.2003584647159;992.2323642165865;399.5758595740228;610.0191862414372;17371.22631212166;760441.1183085031;355.1046758860272];
contrast_ratio = 3422.321744045506;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG9';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'WFG9: PF shape defined by WFG toolkit shape functions; no simple closed-form. Ref: Huband et al. (2006).';
    info.mapping = 't=(x-lb_work)./(ub_work-lb_work); t=max(0,min(1,t)); x_orig=lb_orig+t.*(ub_orig-lb_orig)';
    varargout{1} = info;
    return
end

arg1 = varargin{1};
if isempty(arg1)
    error('Input argument is empty. Use F=f(x) or [lb,ub]=f(''bounds'').');
end
if (ischar(arg1) || (isstring(arg1) && isscalar(arg1))) && strcmpi(char(arg1),'bounds')
    varargout{1} = lb_work;
    if nargout >= 2, varargout{2} = ub_work; end
    return
end

if (ischar(arg1) || (isstring(arg1) && isscalar(arg1)))
    error('Unknown string argument ''%s''. Use ''bounds'' or call with x.', char(arg1));
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
return
end  % main wrapper function

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

