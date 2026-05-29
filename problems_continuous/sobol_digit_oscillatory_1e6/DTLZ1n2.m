function varargout = DTLZ1n2(varargin)
%DTLZ1N2  DTLZ1n2 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 776.707     ]   (range: 776.707     )
%   x2   ∈ [0           , 373.322     ]   (range: 373.322     )
%
% Effective contrast ratio (max range / min range): 2.080531576825164
%
% Pareto information:
%   Pareto front: KNOWN (linear)
%   PF expression: f1 + f2 = 0.5, f_i >= 0
%   Ideal point: [0 0]
%   Nadir point: [0.5 0.5]
%   Pareto set: x_i = 0.5 for i = m..n
%
% USAGE:
%   F = DTLZ1n2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ1n2('bounds')  % Get bounds
%   info = DTLZ1n2()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [776.7073061387894;373.3215658875143];
scale_factors = [776.7073061387894;373.3215658875143];
contrast_ratio = 2.080531576825164;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ1n2';
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
    info.pareto_front_known = true;
    info.pf_type = 'linear';
    info.pf_expression = 'f1 + f2 = 0.5, f_i >= 0';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n';
    info.ideal_point = [0;0];
    info.nadir_point = [0.5;0.5];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [0.6;0.6];
    info.pareto_note = 'DTLZ1n2 (m=2): Linear PF. Ref: Deb et al. (2002).';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ1n2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ1n2_orig)
% -------------------------------------------------------------------------
function f = DTLZ1n2_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ1 with M=2 and n=2.
%
%   CORRECTED VERSION - November 2025
%   CORRECTION: Restored multimodal g(x) with cosine term to match the
%   canonical DTLZ1 definition (Deb et al. 2002) and the AMPL .mod source.
%   DTLZ1 and DTLZ3 share the same multimodal g(x); they differ only in the objective functions (DTLZ1 linear simplex, DTLZ3 spherical).
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2 (fixed)
% - Number of objectives: 2 (fixed)
%   Bounds: x1 in [0,1], x2 in [0,1]
%
% - Pareto front: Linear with f1 + f2 = 0.5, fi in [0, 0.5]
%

n = length(x);
if n ~= 2
    error('DTLZ1n2 requires exactly 2 variables, %d provided', n);
end

% Fixed parameters for this problem
M = 2;  % Number of objectives (fixed for DTLZ1n2)
k = n - M + 1;  % k = 2 - 2 + 1 = 1

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

% f2
f(2) = 0.5 * (1 + gx) * (1 - x(1));

end
