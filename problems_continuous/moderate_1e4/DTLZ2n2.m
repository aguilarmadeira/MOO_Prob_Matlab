function varargout = DTLZ2n2(varargin)
%DTLZ2N2  DTLZ2n2 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (MODERATE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 4.64159     ]   (range: 4.64159     )
%
% Effective contrast ratio (max range / min range): 4.641588833612778
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f1^2 + f2^2 = 1, f_i >= 0 (quarter circle)
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x_i = 0.5 for i = m..n
%
% USAGE:
%   F = DTLZ2n2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ2n2('bounds')  % Get bounds
%   info = DTLZ2n2()          % Get complete problem information
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
ub_work = [1;4.641588833612778];
scale_factors = [1;4.641588833612778];
contrast_ratio = 4.641588833612778;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ2n2';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'moderate';
    info.kappa = 10000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'convex';
    info.pf_expression = 'f1^2 + f2^2 = 1, f_i >= 0 (quarter circle)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'DTLZ2n2 (m=2): Quarter-circle PF. Ref: Deb et al. (2002).';
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
F = DTLZ2n2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ2n2_orig)
% -------------------------------------------------------------------------
function f = DTLZ2n2_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ2 with M=2 and n=2.
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
% - Number of variables: 2 (fixed)
% - Number of objectives: 2 (fixed)
%   Bounds: x1 in [0,1], x2 in [0,1]
%
%

n = length(x);
if n ~= 2
    error('DTLZ2n2 requires exactly 2 variables, %d provided', n);
end

% Fixed parameters for this problem
M = 2;  % Number of objectives (fixed for DTLZ2n2)
k = n - M + 1;  % k = 2 - 2 + 1 = 1

x = x(:);
f = zeros(M, 1);

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + (x(i) - 0.5)^2;
end

% Calculate objectives
f(1) = (1 + gx) * cos(0.5*pi*x(1));
f(2) = (1 + gx) * sin(0.5*pi*x(1));

end
