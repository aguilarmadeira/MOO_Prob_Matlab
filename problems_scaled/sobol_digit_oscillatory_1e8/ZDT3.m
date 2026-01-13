function varargout = ZDT3(varargin)
%ZDT3  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ZDT3
% Dimension: n = 30, objectives m = 2
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 317968.4186351744
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = ZDT3();
%   [lb,ub] = ZDT3('bounds');
%   F = ZDT3(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ZDT3_orig(x_orig)

nloc = 30;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [7384.018015367712;1910.63388435596;8813.244278294094;4238.804273409765;52189990.74744542;3320902.078762356;8477.252413752487;3316.336548192228;67782311.31749824;12657709.73500984;94178070.09372877;4882.4454162573;6051.604271861484;9010458.000496369;7752.094988396489;29524781.92636903;69904438.9960928;2464.216138123277;9312.968708022598;38890182.20873015;54076681.20192858;296.1868681738022;83972553.01334235;3558.55890241423;63466497.5809245;18595013.02355465;9957.984626859185;4494.957218492251;56363715.26485982;1158.988091059878];
scale_factors = [7384.018015367712;1910.63388435596;8813.244278294094;4238.804273409765;52189990.74744542;3320902.078762356;8477.252413752487;3316.336548192228;67782311.31749824;12657709.73500984;94178070.09372877;4882.4454162573;6051.604271861484;9010458.000496369;7752.094988396489;29524781.92636903;69904438.9960928;2464.216138123277;9312.968708022598;38890182.20873015;54076681.20192858;296.1868681738022;83972553.01334235;3558.55890241423;63466497.5809245;18595013.02355465;9957.984626859185;4494.957218492251;56363715.26485982;1158.988091059878];
contrast_ratio = 317968.4186351744;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT3';
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
F = ZDT3_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT3_orig)
% -------------------------------------------------------------------------
function f = ZDT3_orig(x)
% ZDT3 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T3.
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

% Parâmetros
m = 30;
pi = 4*atan(1);

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x)
gx = 1 + 9/(m-1) * sum(x(2:m));

% Cálculo de h - Note que é diferente do ZDT1 e ZDT2: inclui termo senoidal
h = 1 - sqrt(f1/gx) - (f1/gx)*sin(10*pi*f1);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

