function varargout = DTLZ1_5(varargin)
%DTLZ1_5  DTLZ1_5 (n=7, m=5) test problem (heterogeneous WORK-space wrapper).
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
%
% Effective contrast ratio (max range / min range): 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (simplex)
%   PF expression: sum(f_i) = 0.5, f_i >= 0 (5D simplex)
%   Ideal point: [0 0 0 0 0]
%   Nadir point: [0.5 0.5 0.5 0.5 0.5]
%   Pareto set: x_i = 0.5 for i = m..n
%
% USAGE:
%   F = DTLZ1_5(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ1_5('bounds')  % Get bounds
%   info = DTLZ1_5()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 7;
mloc = 5;
lb_orig = [0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ1_5';
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
    info.pareto_front_known = true;
    info.pf_type = 'simplex';
    info.pf_expression = 'sum(f_i) = 0.5, f_i >= 0 (5D simplex)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n';
    info.ideal_point = [0;0;0;0;0];
    info.nadir_point = [0.5;0.5;0.5;0.5;0.5];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [0.6;0.6;0.6;0.6;0.6];
    info.pareto_note = 'DTLZ1_5 (m=5): Linear simplex PF. Ref: Deb et al. (2002).';
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
    error('Input x must have 7 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ1_5_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ1_5_orig)
% -------------------------------------------------------------------------
function f = DTLZ1_5_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ1 with M = 5 objectives.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
n = length(x);

% Fixed parameters
M = 5;  % Number of objectives (fixed for DTLZ1_5)
k = n - M + 1;  % Calculate k from dimension

% Check minimum dimension
if n < M
    error('DTLZ1_5 requires n >= M, but n = %d and M = %d', n, M);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x) - LINEAR VERSION (DTLZ1)
% CRITICAL: This is DIFFERENT from DTLZ3 which includes cosine terms
sum_term = 0;
for i = M:n
    sum_term = sum_term + (x(i) - 0.5)^2;
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

