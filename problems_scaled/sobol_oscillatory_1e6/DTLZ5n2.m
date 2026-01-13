function varargout = DTLZ5n2(varargin)
%DTLZ5N2  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DTLZ5n2
% Dimension: n = 2, objectives m = 2
% Strategy: sobol_oscillatory (kappa = 1000000)
% Effective contrast: 230.1041603949666
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = DTLZ5n2();
%   [lb,ub] = DTLZ5n2('bounds');
%   F = DTLZ5n2(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DTLZ5n2_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [149289.0625;648.7890625];
scale_factors = [149289.0625;648.7890625];
contrast_ratio = 230.1041603949666;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ5n2';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_oscillatory';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ5n2_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ5n2_orig)
% -------------------------------------------------------------------------
function f = DTLZ5n2_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ5 with M=2 and n=2.
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
% - Bounds: x in [0.0, 1.0]^2
%

n = length(x);
if n ~= 2
    error('DTLZ5n2 requires exactly 2 variables, %d provided', n);
end

% Fixed parameters for this problem
M = 2;  % Number of objectives (fixed for DTLZ5n2)
k = n - M + 1;  % k = 2 - 2 + 1 = 1

x = x(:);
f = zeros(M, 1);

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + x(i)^0.1;
end

% Calculate theta
theta2 = (pi/2) * (1 + 2*gx*x(2)) / (2*(1 + gx));

% Calculate objectives
f(1) = (1 + gx) * cos(0.5*pi*x(1));
f(2) = (1 + gx) * sin(0.5*pi*x(1));

end

