function varargout = FES3(varargin)
%FES3  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: FES3
% Dimension: n = 10, objectives m = 4
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = FES3();
%   [lb,ub] = FES3('bounds');
%   F = FES3(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = FES3_orig(x_orig)

nloc = 10;
mloc = 4;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'FES3';
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
F = FES3_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to FES3_orig)
% -------------------------------------------------------------------------
function f = FES3_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example FES3, see the previous cited paper for the original reference.
%
%   In the above paper the number of variables was left undefined. 
%   We selected n=10 as default.
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
% - Number of variables: 10 (default)
% - Number of objectives: 4
% - Bounds: x in [0, 1]^10
%

M = 4; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 10
    error('FES3 requires exactly 10 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
sum1 = 0;
sum2 = 0;
sum3 = 0;
sum4 = 0;
for i = 1:n
    sum1 = sum1 + abs(x(i) - exp((i/n)^2)/3)^0.5;
    sum2 = sum2 + abs(x(i) - sin(i-1)^2 * cos(i-1)^2)^0.5;
    sum3 = sum3 + abs(x(i) - 0.25*cos(i-1)*cos(2*(i-1)) - 0.5)^0.5;
    sum4 = sum4 + (x(i) - 0.5*sin(1000*pi*i/n) - 0.5)^2;
end

f(1) = sum1;
f(2) = sum2;
f(3) = sum3;
f(4) = sum4;

end

