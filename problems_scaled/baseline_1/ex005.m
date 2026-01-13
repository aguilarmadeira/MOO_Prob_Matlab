function varargout = ex005(varargin)
%EX005  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ex005
% Dimension: n = 2, objectives m = 2
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
%
% API:
%   info = ex005();
%   [lb,ub] = ex005('bounds');
%   F = ex005(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ex005_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [-1;1];
ub_orig = [2;2];
lb_work = [-1;1];
ub_work = [2;2];
scale_factors = [1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ex005';
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
F = ex005_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ex005_orig)
% -------------------------------------------------------------------------
function f = ex005_orig(x)
%###############################################################################
%
%   ex005.mod
%   Original AMPL coding by Sven Leyffer, Argonne Natl. Lab.
%
%   A simple multi-objective optimization problem (p. 281):
%   C.-L. Hwang & A. S. Md. Masud, Multiple Objective
%   Decision Making - Methods and Applications, No. 164 in 
%   Lecture Notes in Economics and Mathematical Systems,
%   Springer, 1979.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2
% - Number of objectives: 2
% - Bounds: x1 in [-1, 2], x2 in [1, 2]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('ex005 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = x(1)^2 - x(2)^2;
f(2) = x(1) / x(2);

end

