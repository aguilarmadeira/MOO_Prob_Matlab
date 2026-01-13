function varargout = MOP4(varargin)
%MOP4  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: MOP4
% Dimension: n = 3, objectives m = 2
% Strategy: extreme (kappa = 100000000)
% Effective contrast: 100000000
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = MOP4();
%   [lb,ub] = MOP4('bounds');
%   F = MOP4(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = MOP4_orig(x_orig)

nloc = 3;
mloc = 2;
lb_orig = [0;0;0];
ub_orig = [1;1;1];
lb_work = [0;0;0];
ub_work = [1;100000000;100000000];
scale_factors = [1;100000000;100000000];
contrast_ratio = 100000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP4';
    info.n = nloc; info.m = mloc;
    info.strategy = 'extreme';
    info.kappa = 100000000;
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
    error('Input x must have 3 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP4_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP4_orig)
% -------------------------------------------------------------------------
function f = MOP4_orig(x)
% MOP4 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP4, Van Valedhuizen's test suit.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 3-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = 0;
for i = 1:2
    f1 = f1 + (-10 * exp(-0.2 * sqrt(x(i)^2 + x(i+1)^2)));
end

% Função objetivo 2
f2 = 0;
for i = 1:3
    f2 = f2 + (abs(x(i))^0.8 + 5*sin(x(i)^3));
end

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

