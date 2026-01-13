function varargout = DG01(varargin)
%DG01  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DG01
% Dimension: n = 1, objectives m = 2
% Strategy: spatial_thermal (kappa = 90000)
% Effective contrast: 1
%
% API:
%   info = DG01();
%   [lb,ub] = DG01('bounds');
%   F = DG01(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DG01_orig(x_orig)

nloc = 1;
mloc = 2;
lb_orig = -10;
ub_orig = 13;
lb_work = -3000;
ub_work = 3900;
scale_factors = 300;
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DG01';
    info.n = nloc; info.m = mloc;
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
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
    error('Input x must have 1 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DG01_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DG01_orig)
% -------------------------------------------------------------------------
function f = DG01_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example DG01, See the previous cited paper for the original reference.
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
% - Number of variables: 1 (fixed)
% - Number of objectives: 2 (fixed)
% - Bounds: x in [-10, 13]
%

% Check dimension
n = length(x);
if n ~= 1
    error('DG01 requires exactly 1 variable, %d provided', n);
end

% Ensure x is a scalar
x = x(1);

% Objective functions
f = zeros(2, 1);
f(1) = sin(x);
f(2) = sin(x + 0.7);

end

