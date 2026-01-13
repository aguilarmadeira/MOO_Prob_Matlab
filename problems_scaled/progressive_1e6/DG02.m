function varargout = DG02(varargin)
%DG02  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DG02
% Dimension: n = 1, objectives m = 2
% Strategy: progressive (kappa = 1000000)
% Effective contrast: 1
%
% API:
%   info = DG02();
%   [lb,ub] = DG02('bounds');
%   F = DG02(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DG02_orig(x_orig)

nloc = 1;
mloc = 2;
lb_orig = -9;
ub_orig = 9;
lb_work = -9;
ub_work = 9;
scale_factors = 1;
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DG02';
    info.n = nloc; info.m = mloc;
    info.strategy = 'progressive';
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
    error('Input x must have 1 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DG02_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DG02_orig)
% -------------------------------------------------------------------------
function f = DG02_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example DG02, see the previous cited paper for the original reference.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 1 (fixed)
% - Number of objectives: 2 (fixed)
% - Bounds: x in [-9, 9]
%

% Check dimension
n = length(x);
if n ~= 1
    error('DG02 requires exactly 1 variable, %d provided', n);
end

% Ensure x is a scalar
x = x(1);

% Objective functions
f = zeros(2, 1);
f(1) = x^2;
f(2) = 9 - sqrt(81 - x^2);

end

