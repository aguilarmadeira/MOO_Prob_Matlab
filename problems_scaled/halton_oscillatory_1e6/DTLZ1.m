function varargout = DTLZ1(varargin)
%DTLZ1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DTLZ1
% Dimension: n = 7, objectives m = 3
% Strategy: halton_oscillatory (kappa = 1000000)
% Effective contrast: 6952.333664349553
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = DTLZ1();
%   [lb,ub] = DTLZ1('bounds');
%   F = DTLZ1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DTLZ1_orig(x_orig)

nloc = 7;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0];
ub_work = [500500;250.75;750250;125.875;625375;375.625;875125];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125];
contrast_ratio = 6952.333664349553;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ1';
    info.n = nloc; info.m = mloc;
    info.strategy = 'halton_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
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
    error('Input x must have 7 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ1_orig(x_orig);
varargout{1} = F(:);
end

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
%   CORRECTION: Fixed g(x) function - was using DTLZ3 formula instead of DTLZ1
%   DTLZ1 has LINEAR g(x), DTLZ3 has MULTIMODAL g(x) with cosine terms
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: n >= M (default n = 7 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
% - Bounds: x in [0.0, 1.0]^n
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

