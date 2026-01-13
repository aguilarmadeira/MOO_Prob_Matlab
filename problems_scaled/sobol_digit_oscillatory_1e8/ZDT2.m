function varargout = ZDT2(varargin)
%ZDT2  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ZDT2
% Dimension: n = 30, objectives m = 2
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 206518.8014966316
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = ZDT2();
%   [lb,ub] = ZDT2('bounds');
%   F = ZDT2(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ZDT2_orig(x_orig)

nloc = 30;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [27601367.49272547;9321.022935761372;23633789.27196854;5791.815180555837;4066.770168499942;7505.400106761626;7345193.402431069;7304.721918710567;32413504.98345759;9797.352793805241;1569.69546430929;50030130.75755797;4420.770406959662;8479.396818499303;468.4784113587523;63990002.63094039;29606426.2845859;89062980.78018402;1918.830962940358;5981.874528477065;3964.578427512269;8018.324672940336;12371404.11924268;7172.544962717476;3734.187104586939;96749600.04085548;14577585.93886304;5525.682474531302;47763582.82593866;8222.101621822603];
scale_factors = [27601367.49272547;9321.022935761372;23633789.27196854;5791.815180555837;4066.770168499942;7505.400106761626;7345193.402431069;7304.721918710567;32413504.98345759;9797.352793805241;1569.69546430929;50030130.75755797;4420.770406959662;8479.396818499303;468.4784113587523;63990002.63094039;29606426.2845859;89062980.78018402;1918.830962940358;5981.874528477065;3964.578427512269;8018.324672940336;12371404.11924268;7172.544962717476;3734.187104586939;96749600.04085548;14577585.93886304;5525.682474531302;47763582.82593866;8222.101621822603];
contrast_ratio = 206518.8014966316;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT2';
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
    error('Input x must have 30 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = ZDT2_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT2_orig)
% -------------------------------------------------------------------------
function f = ZDT2_orig(x)
% ZDT2 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T2.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a m-dimensional vector, where m = 30
%   Output: f is a 2-dimensional vector with the function values
%          handled by the optimization algorithm)

% Número de variáveis
m = 30;

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x)
gx = 1 + 9/(m-1) * sum(x(2:m));

% Cálculo de h - Note a diferença em relação ao ZDT1: aqui usa (f1/gx)^2
h = 1 - (f1/gx)^2;

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

