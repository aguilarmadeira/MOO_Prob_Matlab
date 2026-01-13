function varargout = CL1(varargin)
%CL1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: CL1
% Dimension: n = 4, objectives m = 2
% Strategy: sobol_oscillatory (kappa = 1000000)
% Effective contrast: 615.0520801974833
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = CL1();
%   [lb,ub] = CL1('bounds');
%   F = CL1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = CL1_orig(x_orig)

nloc = 4;
mloc = 2;
lb_orig = [0;0;0;0];
ub_orig = [1;1;1;1];
lb_work = [0;0;0;0];
ub_work = [149289.0625;648.7890625;399039.0625;898.5390625];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625];
contrast_ratio = 615.0520801974833;

if nargin == 0
    info.name = mfilename;
    info.problem = 'CL1';
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
    error('Input x must have 4 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = CL1_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to CL1_orig)
% -------------------------------------------------------------------------
function f = CL1_orig(x)
%###############################################################################
%
%   As described by F.Y. Cheng and X.S. Li, "Generalized center method for
%   multiobjective engineering optimization", Engineering Optimization,31:5,
%   641-661, 1999.
%
%   Example 2, four bar truss.
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
% - Number of variables: 4 (fixed)
% - Number of objectives: 2 (fixed)
% - Bounds: x1 in [F/sigma, 3*F/sigma] = [1, 3]
%           x2,x3 in [sqrt(2)*F/sigma, 3*F/sigma] = [sqrt(2), 3]
%           x4 in [F/sigma, 3*F/sigma] = [1, 3]
%

% Check dimension
n = length(x);
if n ~= 4
    error('CL1 requires exactly 4 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
F = 10;
E = 2e5;
L = 200;
sigma = 10;

% Objective functions
f = zeros(2, 1);
f(1) = L * (2*x(1) + sqrt(2)*x(2) + sqrt(x(3)) + x(4));
f(2) = F*L/E * (2/x(1) + (2*sqrt(2))/x(2) - (2*sqrt(2))/x(3) + 2/x(4));

end

