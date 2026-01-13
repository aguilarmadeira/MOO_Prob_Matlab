function varargout = Deb512a(varargin)
%DEB512A  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: Deb512a
% Dimension: n = 2, objectives m = 2
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
%
% API:
%   info = Deb512a();
%   [lb,ub] = Deb512a('bounds');
%   F = Deb512a(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = Deb512a_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [1;1];
scale_factors = [1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Deb512a';
    info.n = nloc; info.m = mloc;
    info.strategy = 'baseline';
    info.kappa = 1;
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
F = Deb512a_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Deb512a_orig)
% -------------------------------------------------------------------------
function f = Deb512a_orig(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation
%   7(3): 205-230, 1999.
%              
%   Example 5.1.2 (Convex Pareto-optimal Front).
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
% - Bounds: x in [0.0, 1.0] x [0.0, 1.0]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Deb512a requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
beta = 1;
alpha = 0.25;

% Initialize objectives
f = zeros(M, 1);

% Function f1
ff1 = 4 * x(1);

% g function
if x(2) <= 0.4
    gx = 4 - 3*exp(-((x(2)-0.2)/0.02)^2);
else
    gx = 4 - 2*exp(-((x(2)-0.7)/0.2)^2);
end

% h function
if ff1 <= beta*gx
    h = 1 - (ff1/(beta*gx))^alpha;
else
    h = 0;
end

% Objective functions
f(1) = ff1;
f(2) = gx * h;

end

