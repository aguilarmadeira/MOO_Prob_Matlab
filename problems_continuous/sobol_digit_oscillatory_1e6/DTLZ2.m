function varargout = DTLZ2(varargin)
%DTLZ2  DTLZ2 (n=12, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 166037      ]   (range: 166037      )
%   x2   ∈ [0           , 913.477     ]   (range: 913.477     )
%   x3   ∈ [0           , 260406      ]   (range: 260406      )
%   x4   ∈ [0           , 507819      ]   (range: 507819      )
%   x5   ∈ [0           , 48.6474     ]   (range: 48.6474     )
%   x6   ∈ [0           , 811421      ]   (range: 811421      )
%   x7   ∈ [0           , 391.333     ]   (range: 391.333     )
%   x8   ∈ [0           , 655117      ]   (range: 655117      )
%   x9   ∈ [0           , 233270      ]   (range: 233270      )
%   x10  ∈ [0           , 969209      ]   (range: 969209      )
%   x11  ∈ [0           , 327677      ]   (range: 327677      )
%   x12  ∈ [0           , 563667      ]   (range: 563667      )
%
% Effective contrast ratio (max range / min range): 19923.15657876877
%
% Pareto information:
%   Pareto front: KNOWN (sphere)
%   PF expression: sum(f_i^2) = 1, f_i >= 0 (unit sphere, positive octant)
%   Ideal point: [0 0 0]
%   Nadir point: [1 1 1]
%   Pareto set: x_i = 0.5 for i = m..n (distance variables)
%
% USAGE:
%   F = DTLZ2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ2('bounds')  % Get bounds
%   info = DTLZ2()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 12;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [166037.4967871397;913.4766583687665;260406.0840745855;507818.9866495733;48.64736554184255;811420.9268786722;391.3327037676972;655117.2805808915;233269.9290002094;969209.0808347294;327677.101648982;563667.1644999764];
scale_factors = [166037.4967871397;913.4766583687665;260406.0840745855;507818.9866495733;48.64736554184255;811420.9268786722;391.3327037676972;655117.2805808915;233269.9290002094;969209.0808347294;327677.101648982;563667.1644999764];
contrast_ratio = 19923.15657876877;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ2';
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
    info.pf_type = 'sphere';
    info.pf_expression = 'sum(f_i^2) = 1, f_i >= 0 (unit sphere, positive octant)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n (distance variables)';
    info.ideal_point = [0;0;0];
    info.nadir_point = [1;1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1;1.1];
    info.pareto_note = 'DTLZ2 (m=3): Spherical PF. Ref: Deb et al. (2002).';
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
    error('Input x must have 12 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ2_orig)
% -------------------------------------------------------------------------
function f = DTLZ2_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ2.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. CustÃ³dio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
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
% - Number of variables: n >= M (default n = 12 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1], x11 in [0,1], x12 in [0,1]
%
%


% Fixed parameters for DTLZ2
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ2 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + (x(i) - 0.5)^2;
end

% Calculate objectives
% f1
prod_term = 1;
for j = 1:(M-1)
    prod_term = prod_term * cos(0.5*pi*x(j));
end
f(1) = (1 + gx) * prod_term;

% f2 to fM
for i = 2:M
    prod_term = 1;
    for j = 1:(M-i)
        prod_term = prod_term * cos(0.5*pi*x(j));
    end
    f(i) = (1 + gx) * prod_term * sin(0.5*pi*x(M-i+1));
end

end

