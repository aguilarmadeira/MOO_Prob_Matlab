function varargout = MHHM2(varargin)
%MHHM2  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: MHHM2
% Dimension: n = 2, objectives m = 3
% Strategy: halton_oscillatory (kappa = 1000000)
% Effective contrast: 1996.011964107677
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = MHHM2();
%   [lb,ub] = MHHM2('bounds');
%   F = MHHM2(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = MHHM2_orig(x_orig)

nloc = 2;
mloc = 3;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [500500;250.75];
scale_factors = [500500;250.75];
contrast_ratio = 1996.011964107677;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MHHM2';
    info.n = nloc; info.m = mloc;
    info.strategy = 'halton_oscillatory';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MHHM2_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MHHM2_orig)
% -------------------------------------------------------------------------
function f = MHHM2_orig(x)
% MHHM2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MHHM2, see the previous cited paper for the original reference.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 3-dimensional vector with the function values
%
% Problem characteristics:
% - Number of variables: 2 (fixed)
% - Number of objectives: 3 (fixed)
% - Bounds: x in [0, 1]^2

% Check dimension
n = length(x);
if n ~= 2
    error('MHHM2 requires exactly 2 variables, %d provided', n);
end

% Objective functions
f = zeros(3, 1);
f(1) = (x(1) - 0.8)^2 + (x(2) - 0.6)^2;
f(2) = (x(1) - 0.85)^2 + (x(2) - 0.7)^2;
f(3) = (x(1) - 0.9)^2 + (x(2) - 0.6)^2;

end

