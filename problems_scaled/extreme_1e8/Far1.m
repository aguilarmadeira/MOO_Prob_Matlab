function varargout = Far1(varargin)
%FAR1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: Far1
% Dimension: n = 2, objectives m = 2
% Strategy: extreme (kappa = 100000000)
% Effective contrast: 100000000
%
% API:
%   info = Far1();
%   [lb,ub] = Far1('bounds');
%   F = Far1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = Far1_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [-1;-1];
ub_orig = [1;1];
lb_work = [-1;-100000000];
ub_work = [1;100000000];
scale_factors = [1;100000000];
contrast_ratio = 100000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Far1';
    info.n = nloc; info.m = mloc;
    info.strategy = 'extreme';
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
F = Far1_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Far1_orig)
% -------------------------------------------------------------------------
function f = Far1_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example Far1, see the previous cited paper for the original reference.
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
% - Number of objectives: 2
% - Bounds: x in [-1, 1] x [-1, 1]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Far1 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = -2*exp(15*(-(x(1)-0.1)^2 - x(2)^2)) ...
       - exp(20*(-(x(1)-0.6)^2 - (x(2)-0.6)^2)) ...
       + exp(20*(-(x(1)+0.6)^2 - (x(2)-0.6)^2)) ...
       + exp(20*(-(x(1)-0.6)^2 - (x(2)+0.6)^2)) ...
       + exp(20*(-(x(1)+0.6)^2 - (x(2)+0.6)^2));

f(2) = 2*exp(20*(-x(1)^2 - x(2)^2)) ...
       + exp(20*(-(x(1)-0.4)^2 - (x(2)-0.6)^2)) ...
       - exp(20*(-(x(1)+0.5)^2 - (x(2)-0.7)^2)) ...
       - exp(20*(-(x(1)-0.5)^2 - (x(2)+0.7)^2)) ...
       + exp(20*(-(x(1)+0.4)^2 - (x(2)+0.8)^2));

end

