function varargout = WFG6(varargin)
%WFG6  WFG6 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (BASELINE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 1           ]   (range: 1           )
%   x3   ∈ [0           , 1           ]   (range: 1           )
%   x4   ∈ [0           , 1           ]   (range: 1           )
%   x5   ∈ [0           , 1           ]   (range: 1           )
%   x6   ∈ [0           , 1           ]   (range: 1           )
%   x7   ∈ [0           , 1           ]   (range: 1           )
%   x8   ∈ [0           , 1           ]   (range: 1           )
%
% Effective contrast ratio (max range / min range): 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = WFG6(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = WFG6('bounds')  % Get bounds
%   info = WFG6()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
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
    info.problem = 'WFG6';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'baseline';
    info.kappa = 1;
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
    info.pareto_note = 'WFG6: PF shape defined by WFG toolkit shape functions; no simple closed-form. Ref: Huband et al. (2006).';
    info.mapping = 't=(x-lb_work)./(ub_work-lb_work); t=max(0,min(1,t)); x_orig=lb_orig+t.*(ub_orig-lb_orig)';
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
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
F = WFG6_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

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

