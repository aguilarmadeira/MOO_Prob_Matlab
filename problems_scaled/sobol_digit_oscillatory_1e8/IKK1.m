function varargout = IKK1(varargin)
%IKK1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: IKK1
% Dimension: n = 2, objectives m = 3
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 2.227604751455278
%
% API:
%   info = IKK1();
%   [lb,ub] = IKK1('bounds');
%   F = IKK1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = IKK1_orig(x_orig)

nloc = 2;
mloc = 3;
lb_orig = [-50;-50];
ub_orig = [50;50];
lb_work = [-3279563638.497239;-1472237674.27984];
ub_work = [3279563638.497239;1472237674.27984];
scale_factors = [65591272.76994479;29444753.48559679];
contrast_ratio = 2.227604751455278;

if nargin == 0
    info.name = mfilename;
    info.problem = 'IKK1';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 100000000;
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
F = IKK1_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to IKK1_orig)
% -------------------------------------------------------------------------
function f = IKK1_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example IKK1, see the previous cited paper for the original reference.
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
% - Number of variables: 2
% - Number of objectives: 3
% - Bounds: x in [-50.0, 50.0] x [-50.0, 50.0]
%

M = 3; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('IKK1 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = x(1)^2;
f(2) = (x(1)-20)^2;
f(3) = x(2)^2;

end

