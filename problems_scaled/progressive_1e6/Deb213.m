function varargout = Deb213(varargin)
%DEB213  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: Deb213
% Dimension: n = 2, objectives m = 2
% Strategy: progressive (kappa = 1000000)
% Effective contrast: 10
%
% API:
%   info = Deb213();
%   [lb,ub] = Deb213('bounds');
%   F = Deb213(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = Deb213_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [0.1;0];
ub_orig = [1;1];
lb_work = [0.1;0];
ub_work = [1;10];
scale_factors = [1;10];
contrast_ratio = 10;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Deb213';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = Deb213_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Deb213_orig)
% -------------------------------------------------------------------------
function f = Deb213_orig(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   J. F. A. Madeira
%   Discrete Direct Multisearch for Multiobjective Optimization, 2021.
%
%   Written by the authors in February 24, 2021.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2
% - Number of objectives: 2
% - Bounds: x1 in [0.1, 1.0], x2 in [0.0, 1.0]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Deb213 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% h function (penalty for x1 = 0)
if x(1) == 0
    h = 1e20;
else
    h = 1;
end

% g function
gx = 2 - exp(-((x(2)-0.2)/0.004)^2) - 1.9*exp(-((x(2)-0.6)/0.4)^2);

% Objective functions
ff1 = x(1) * h;
ff2 = (gx/x(1)) * h;

f(1) = ff1;
f(2) = ff2;

end

