function varargout = I5(varargin)
%I5  I5 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (PROGRESSIVE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 10          ]   (range: 10          )
%   x3   ∈ [0           , 100         ]   (range: 100         )
%   x4   ∈ [0           , 1000        ]   (range: 1000        )
%   x5   ∈ [0           , 0.1         ]   (range: 0.1         )
%   x6   ∈ [0           , 0.01        ]   (range: 0.01        )
%   x7   ∈ [0           , 0.001       ]   (range: 0.001       )
%   x8   ∈ [0           , 1           ]   (range: 1           )
%
% Effective contrast ratio (max range / min range): 1000000
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = I5(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = I5('bounds')  % Get bounds
%   info = I5()          % Get complete problem information
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
ub_work = [1;10;100;1000;0.1;0.01;0.001;1];
scale_factors = [1;10;100;1000;0.1;0.01;0.001;1];
contrast_ratio = 1000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'I5';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'progressive';
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
    info.pareto_note = 'I5 (m=3): Expected spherical PF (DTLZ2-based) but depends on implementation-specific transformations. Ref: Huband et al. (2005).';
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
F = I5_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to I5_orig)
% -------------------------------------------------------------------------
function f = I5_orig(z)
%###############################################################################
%
%   As described by Huband et al. in "A Scalable Multi-objective Test Problem
%   Toolkit", in C. A. Coello Coello et al. (Eds.): EMO 2005, LNCS 3410, 
%   pp. 280–295, 2005, Springer-Verlag Berlin Heidelberg 2005.
%
%   Example I5.
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
    error('I5 requires exactly %d variables, %d provided', n, length(z));
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
w = ones(n, 1);
AA = 0.98/49.98;
BB = 0.02;
CC = 50;
t1 = zeros(n, 1);

% Calculate r_sum and t1
t1(1) = y(1);
for i = 2:n
    r_sum = sum(w(1:i-1) .* y(1:i-1)) / sum(w(1:i-1));
    t1(i) = y(i)^(BB + (CC-BB) * (AA - (1-2*r_sum) * abs(floor(0.5-r_sum) + AA)));
end

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

