function varargout = ZDT6(varargin)
%ZDT6  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ZDT6
% Dimension: n = 10, objectives m = 2
% Strategy: progressive (kappa = 1000000)
% Effective contrast: 1000000
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = ZDT6();
%   [lb,ub] = ZDT6('bounds');
%   F = ZDT6(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ZDT6_orig(x_orig)

nloc = 10;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [1;10;100;1000;0.1;0.01;0.001;1;10;100];
scale_factors = [1;10;100;1000;0.1;0.01;0.001;1;10;100];
contrast_ratio = 1000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT6';
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
    error('Input x must have 10 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = ZDT6_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT6_orig)
% -------------------------------------------------------------------------
function f = ZDT6_orig(x)
% ZDT6 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T6.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a m-dimensional vector, where m = 10
%   Output: f is a 2-dimensional vector with the function values
%          handled by the optimization algorithm)

% Parâmetros
m = 10;
pi = 4*atan(1);

% Função objetivo 1 - Função não-uniforme
f1 = 1 - exp(-4*x(1)) * (sin(6*pi*x(1)))^6;

% Cálculo de g(x) - Usa potência de 1/4
gx = 1 + 9 * ((sum(x(2:m)))/(m-1))^0.25;

% Cálculo de h - Similar ao ZDT2: usa (f1/gx)^2
h = 1 - (f1/gx)^2;

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

