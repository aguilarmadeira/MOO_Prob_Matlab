function varargout = CAM2(varargin)
%CAM2  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: CAM2
% Dimension: n = 2, objectives m = 2
% Strategy: sobol_oscillatory (kappa = 1000000)
% Effective contrast: 230.1041603949666
%
% API:
%   info = CAM2();
%   [lb,ub] = CAM2('bounds');
%   F = CAM2(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = CAM2_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [0.1;0];
ub_orig = [1;1];
lb_work = [14928.90625;0];
ub_work = [149289.0625;648.7890625];
scale_factors = [149289.0625;648.7890625];
contrast_ratio = 230.1041603949666;

if nargin == 0
    info.name = mfilename;
    info.problem = 'CAM2';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_oscillatory';
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
F = CAM2_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to CAM2_orig)
% -------------------------------------------------------------------------
function f = CAM2_orig(x)
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
    error('CAM2 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% g function
gx = 2 - exp(-((x(2)-0.2)/0.004)^2) - 0.8*exp(-((x(2)-0.6)/0.4)^2) - 1.2*exp(-((x(2)-0.9)/0.002)^2);

% Objective functions
f(1) = x(1);
f(2) = gx/x(1);

end

