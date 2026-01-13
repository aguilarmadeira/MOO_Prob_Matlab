function varargout = VU1(varargin)
%VU1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: VU1
% Dimension: n = 2, objectives m = 2
% Strategy: progressive (kappa = 1000000)
% Effective contrast: 10
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = VU1();
%   [lb,ub] = VU1('bounds');
%   F = VU1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = VU1_orig(x_orig)

nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [1;10];
scale_factors = [1;10];
contrast_ratio = 10;

if nargin == 0
    info.name = mfilename;
    info.problem = 'VU1';
    info.n = nloc; info.m = mloc;
    info.strategy = 'progressive';
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
F = VU1_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to VU1_orig)
% -------------------------------------------------------------------------
function f = VU1_orig(x)
% VU1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example VU1, see the previous cited paper for the original reference.
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
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = 1 / (x(1)^2 + x(2)^2 + 1);

% Função objetivo 2
f2 = x(1)^2 + 3*x(2)^2 + 1;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

