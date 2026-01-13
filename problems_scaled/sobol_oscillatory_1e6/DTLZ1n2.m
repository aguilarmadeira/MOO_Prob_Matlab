function varargout = DTLZ1n2(varargin)
%DTLZ1N2  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DTLZ1n2
% Dimension: n = 2, objectives m = 2
% Strategy: sobol_oscillatory (kappa = 1000000)
% Effective contrast: 230.1041603949666
%
% API:
%   info = DTLZ1n2();
%   [lb,ub] = DTLZ1n2('bounds');
%   F = DTLZ1n2(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DTLZ1n2_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;0.5];
lb_work = [0;0];
ub_work = [149289.0625;324.39453125];
scale_factors = [149289.0625;648.7890625];
contrast_ratio = 230.1041603949666;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ1n2';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ1n2_orig(x_orig);
varargout{1} = F(:);
end

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
%   CRITICAL FIX: Removed cosine terms from g(x)
%   DTLZ1 has LINEAR g(x), DTLZ3 has MULTIMODAL g(x) with cosine terms
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
% - Bounds: x in [0.0, 1.0]^2
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

% f2
f(2) = 0.5 * (1 + gx) * (1 - x(1));

end
