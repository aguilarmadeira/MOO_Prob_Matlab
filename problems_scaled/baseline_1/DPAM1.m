function varargout = DPAM1(varargin)
%DPAM1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DPAM1
% Dimension: n = 10, objectives m = 2
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = DPAM1();
%   [lb,ub] = DPAM1('bounds');
%   F = DPAM1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DPAM1_orig(x_orig)

nloc = 10;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DPAM1';
    info.n = nloc; info.m = mloc;
    info.strategy = 'baseline';
    info.kappa = 1;
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
    error('Input x must have 10 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DPAM1_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DPAM1_orig)
% -------------------------------------------------------------------------
function f = DPAM1_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example DPAM1, see the previous cited paper for the original reference.
%
%   In the above paper/papers the number of variables
%   was left undefined. We selected n=10 as default.
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
% - Number of variables: 10 (fixed)
% - Number of objectives: 2 (fixed)
% - Bounds: x in [-0.3, 0.3]^10
%

% Check dimension
n = length(x);
if n ~= 10
    error('DPAM1 requires exactly 10 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Define rotation matrix A (sparse, mostly identity)
A = eye(10);
A(1,1) = 0.968912;
A(1,3) = 0.247404;
A(3,1) = -0.247404;
A(3,3) = 0.968912;

% Transform variables
y = A * x;

% Calculate g(x)
sum_term = 0;
for i = 2:n
    sum_term = sum_term + (y(i)^2 - 10*cos(4*pi*y(i)));
end
gx = 1 + 10*(n-1) + sum_term;

% Objective functions
f = zeros(2, 1);
f(1) = y(1);
f(2) = gx * exp(-y(1)/gx);

end

