function varargout = I1(varargin)
%I1  I1 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 149289      ]   (range: 149289      )
%   x2   ∈ [0           , 648.789     ]   (range: 648.789     )
%   x3   ∈ [0           , 399039      ]   (range: 399039      )
%   x4   ∈ [0           , 898.539     ]   (range: 898.539     )
%   x5   ∈ [0           , 86851.6     ]   (range: 86851.6     )
%   x6   ∈ [0           , 586.352     ]   (range: 586.352     )
%   x7   ∈ [0           , 336602      ]   (range: 336602      )
%   x8   ∈ [0           , 836.102     ]   (range: 836.102     )
%
% Effective contrast ratio (max range / min range): 680.5457476716454
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = I1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = I1('bounds')  % Get bounds
%   info = I1()          % Get complete problem information
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
ub_work = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625];
contrast_ratio = 680.5457476716454;

if nargin == 0
    info.name = mfilename;
    info.problem = 'I1';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_oscillatory';
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
    info.pareto_note = 'I1 (m=3): Expected spherical PF (DTLZ2-based) but depends on implementation-specific transformations. Ref: Huband et al. (2005).';
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
F = I1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to I1_orig)
% -------------------------------------------------------------------------
function f = I1_orig(z)
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

