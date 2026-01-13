function varargout = MOP7(varargin)
%MOP7  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: MOP7
% Dimension: n = 2, objectives m = 3
% Strategy: sobol_oscillatory (kappa = 1000000)
% Effective contrast: 230.1041603949666
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = MOP7();
%   [lb,ub] = MOP7('bounds');
%   F = MOP7(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = MOP7_orig(x_orig)

nloc = 2;
mloc = 3;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [149289.0625;648.7890625];
scale_factors = [149289.0625;648.7890625];
contrast_ratio = 230.1041603949666;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP7';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP7_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP7_orig)
% -------------------------------------------------------------------------
function f = MOP7_orig(x)
% MOP7 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP7, Van Valedhuizen's test suit.
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
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = (x(1)-2)^2 / 2 + (x(2)+1)^2 / 13 + 3;

% Função objetivo 2
f2 = (x(1)+x(2)-3)^2 / 36 + (-x(1)+x(2)+2)^2 / 8 - 17;

% Função objetivo 3
f3 = (x(1)+2*x(2)-1)^2 / 175 + (-x(1)+2*x(2))^2 / 17 - 13;

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema

end

