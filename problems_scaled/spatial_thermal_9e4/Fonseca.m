function varargout = Fonseca(varargin)
%FONSECA  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: Fonseca
% Dimension: n = 2, objectives m = 2
% Strategy: spatial_thermal (kappa = 90000)
% Effective contrast: 300
%
% API:
%   info = Fonseca();
%   [lb,ub] = Fonseca('bounds');
%   F = Fonseca(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = Fonseca_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [-4;-4];
ub_orig = [4;4];
lb_work = [-4;-1200];
ub_work = [4;1200];
scale_factors = [1;300];
contrast_ratio = 300;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Fonseca';
    info.n = nloc; info.m = mloc;
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
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
F = Fonseca_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Fonseca_orig)
% -------------------------------------------------------------------------
function f = Fonseca_orig(x)
%###############################################################################
%
%   As described by C.M. Fonseca and P.J. Fleming in "Multiobjective
%   Optimization and Multiple Constraint Handling with Evolutionary
%   Algorithms—Part I: A Unified Formulation", in IEEE Transactions 
%   on Systems, Man, and Cybernetics—Part A: Systems and Humans, 
%   vol. 28, no. 1, January 1998.
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
% - Bounds: x in [-4.0, 4.0] x [-4.0, 4.0]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Fonseca requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = 1 - exp(-(x(1)-1)^2 - (x(2)+1)^2);
f(2) = 1 - exp(-(x(1)+1)^2 - (x(2)-1)^2);

end

