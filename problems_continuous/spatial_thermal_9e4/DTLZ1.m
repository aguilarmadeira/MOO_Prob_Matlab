function varargout = DTLZ1(varargin)
%DTLZ1  DTLZ1 (n=7, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SPATIAL_THERMAL HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 1           ]   (range: 1           )
%   x3   ∈ [0           , 1           ]   (range: 1           )
%   x4   ∈ [0           , 300         ]   (range: 300         )
%   x5   ∈ [0           , 300         ]   (range: 300         )
%   x6   ∈ [0           , 300         ]   (range: 300         )
%   x7   ∈ [0           , 300         ]   (range: 300         )
%
% Effective contrast ratio (max range / min range): 300
%
% Pareto information:
%   Pareto front: KNOWN (linear)
%   PF expression: sum(f_i) = 0.5, f_i >= 0 (simplex)
%   Ideal point: [0 0 0]
%   Nadir point: [0.5 0.5 0.5]
%   Pareto set: x_i = 0.5 for i = m..n (distance variables)
%
% USAGE:
%   F = DTLZ1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ1('bounds')  % Get bounds
%   info = DTLZ1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 7;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0];
ub_work = [1;1;1;300;300;300;300];
scale_factors = [1;1;1;300;300;300;300];
contrast_ratio = 300;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ1';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'linear';
    info.pf_expression = 'sum(f_i) = 0.5, f_i >= 0 (simplex)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n (distance variables)';
    info.ideal_point = [0;0;0];
    info.nadir_point = [0.5;0.5;0.5];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [0.6;0.6;0.6];
    info.pareto_note = 'DTLZ1 (m=3): Linear simplex PF. Ref: Deb et al. (2002).';
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
    error('Input x must have 7 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ1_orig)
% -------------------------------------------------------------------------
function f = DTLZ1_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ1.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%
%   CORRECTED MATLAB version by J. F. A. Madeira
%   November 16, 2025
%
%   CORRECTION: Restored multimodal g(x) with cosine term to match the
%   canonical DTLZ1 definition (Deb et al. 2002) and the AMPL .mod source.
%   DTLZ1 and DTLZ3 share the same multimodal g(x); they differ only in the objective functions (DTLZ1 linear simplex, DTLZ3 spherical).
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: n >= M (default n = 7 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1]
%
% - Pareto front: Linear simplex with sum(fi) = 0.5, fi in [0, 0.5]
%


% Fixed parameters for DTLZ1
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ1 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x) - MULTIMODAL (canonical DTLZ1, matches AMPL .mod)
% NOTE: DTLZ1 and DTLZ3 share the SAME multimodal g(x) (with cosine term).
% They differ only in the objective functions: DTLZ1 uses linear products of
% x(j) with factor 0.5 (linear simplex front); DTLZ3 uses cos(0.5*pi*x(j))
% (spherical front).
sum_term = 0;
for i = M:n
    sum_term = sum_term + ((x(i)-0.5)^2 - cos(20*pi*(x(i)-0.5)));
end
gx = 100 * (k + sum_term);

% Alternative vectorized implementation:
% gx = 100 * (k + sum((x(M:n) - 0.5).^2));

% Calculate objectives
% f1
prod_term = 1;
for j = 1:(M-1)
    prod_term = prod_term * x(j);
end
f(1) = 0.5 * (1 + gx) * prod_term;

% f2 to fM
for i = 2:M
    prod_term = 1;
    for j = 1:(M-i)
        prod_term = prod_term * x(j);
    end
    f(i) = 0.5 * (1 + gx) * prod_term * (1 - x(M-i+1));
end

end

