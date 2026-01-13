function varargout = DTLZ6(varargin)
%DTLZ6  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DTLZ6
% Dimension: n = 22, objectives m = 3
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 943730.6042987953
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = DTLZ6();
%   [lb,ub] = DTLZ6('bounds');
%   F = DTLZ6(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DTLZ6_orig(x_orig)

nloc = 22;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [2880.991218615326;5567.608709144421;607.6967794423597;78396818.21990398;4690.000279175038;74691518.8127165;2431.276675627858;9726.654457062748;32416576.68531237;58501495.86998246;813.3501803874217;8279.678400891562;43306037.51667823;6636.326047268572;1599.51572664661;9368.635100041327;2663.952048179768;5120.938157089763;83.07118351656496;7700.597696008003;45948854.17749239;69787117.55387615];
scale_factors = [2880.991218615326;5567.608709144421;607.6967794423597;78396818.21990398;4690.000279175038;74691518.8127165;2431.276675627858;9726.654457062748;32416576.68531237;58501495.86998246;813.3501803874217;8279.678400891562;43306037.51667823;6636.326047268572;1599.51572664661;9368.635100041327;2663.952048179768;5120.938157089763;83.07118351656496;7700.597696008003;45948854.17749239;69787117.55387615];
contrast_ratio = 943730.6042987953;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ6';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 100000000;
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
    error('Input x must have 22 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ6_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ6_orig)
% -------------------------------------------------------------------------
function f = DTLZ6_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ6.
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
% - Number of variables: n >= M (default n = 22 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
% - Bounds: x in [0.0, 1.0]^n
%


% Fixed parameters for DTLZ6
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ6 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
sum_term = 0;
for i = M:n
    sum_term = sum_term + x(i);
end
gx = 1 + (9/k) * sum_term;

% Calculate objectives
% f1 to f(M-1)
for i = 1:(M-1)
    f(i) = x(i);
end

% fM
sum_term = 0;
for i = 1:(M-1)
    sum_term = sum_term + (x(i)/(1 + gx)) * (1 + sin(3*pi*x(i)));
end
f(M) = (1 + gx) * (M - sum_term);

end

