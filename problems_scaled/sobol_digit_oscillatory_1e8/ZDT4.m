function varargout = ZDT4(varargin)
%ZDT4  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ZDT4
% Dimension: n = 10, objectives m = 2
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 45709.02651946369
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = ZDT4();
%   [lb,ub] = ZDT4('bounds');
%   F = ZDT4(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ZDT4_orig(x_orig)

nloc = 10;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [41356800.26334448;90212047.30442536;1973.615589166212;74090119.76932323;32717680.64882512;8616.846520480358;3488337.020353825;5305.156577226224;4857.906701299827;9509.697278297423];
scale_factors = [41356800.26334448;90212047.30442536;1973.615589166212;74090119.76932323;32717680.64882512;8616.846520480358;3488337.020353825;5305.156577226224;4857.906701299827;9509.697278297423];
contrast_ratio = 45709.02651946369;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT4';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_digit_oscillatory';
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
    error('Input x must have 10 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = ZDT4_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT4_orig)
% -------------------------------------------------------------------------
function f = ZDT4_orig(x)
% ZDT4 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T4.
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

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x) - Multimodal com muitos ótimos locais
gx = 1 + 10*(m-1) + sum(x(2:m).^2 - 10*cos(4*pi*x(2:m)));

% Cálculo de h - Similar ao ZDT1
h = 1 - sqrt(f1/gx);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


% Note que este problema tem limites diferentes:
% 0 <= x(1) <= 1
% -5 <= x(i) <= 5 para i=2,...,m

end

