function varargout = Jin3(varargin)
%JIN3  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: Jin3
% Dimension: n = 2, objectives m = 2
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
%
% API:
%   info = Jin3();
%   [lb,ub] = Jin3('bounds');
%   F = Jin3(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = Jin3_orig(x_orig)

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
    info.problem = 'Jin3';
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
F = Jin3_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Jin3_orig)
% -------------------------------------------------------------------------
function f = Jin3_orig(x)
%###############################################################################
%
%   As described by Y. Jin, M. Olhofer and B. Sendhoff. "Dynamic weighted
%   aggregation for evolutionary multi-objective optimization: Why does it
%   work and how?", in Proceedings of Genetic and Evolutionary Computation 
%   Conference, pp.1042-1049, San Francisco, USA, 2001.
%
%   Test function 3, F3.
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
    error('Jin3 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% g(x) function
gx = 1 + (9 * sum(x(2:n))) / (n-1);

% Objective functions
f(1) = x(1);
f(2) = gx * (1 - (x(1)/gx)^2);

end

