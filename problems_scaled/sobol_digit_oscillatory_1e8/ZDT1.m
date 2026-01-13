function varargout = ZDT1(varargin)
%ZDT1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ZDT1
% Dimension: n = 30, objectives m = 2
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 156845.3611898751
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = ZDT1();
%   [lb,ub] = ZDT1('bounds');
%   F = ZDT1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ZDT1_orig(x_orig)

nloc = 30;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [4862.320862806715;6096.982306913446;2467.053208230645;87220243.43133861;34565571.40179612;7192.117721419489;10625864.29628848;98158628.1792502;4038.6500877578;52829480.24433135;14087447.9685118;76733142.81165613;29954277.7125896;67506273.66750716;625.8306107020949;9359.763556825603;45143165.82783911;5778.253720106782;1908.784995528009;81540109.26064056;34191812.801984;7184.017405657425;814.9464833149584;9558.477816240384;4088.260218662865;5342.265216546562;1717.366267444656;7952.698201702327;27343485.01441038;6470.064551362571];
scale_factors = [4862.320862806715;6096.982306913446;2467.053208230645;87220243.43133861;34565571.40179612;7192.117721419489;10625864.29628848;98158628.1792502;4038.6500877578;52829480.24433135;14087447.9685118;76733142.81165613;29954277.7125896;67506273.66750716;625.8306107020949;9359.763556825603;45143165.82783911;5778.253720106782;1908.784995528009;81540109.26064056;34191812.801984;7184.017405657425;814.9464833149584;9558.477816240384;4088.260218662865;5342.265216546562;1717.366267444656;7952.698201702327;27343485.01441038;6470.064551362571];
contrast_ratio = 156845.3611898751;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT1';
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
F = ZDT1_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT1_orig)
% -------------------------------------------------------------------------
function f = ZDT1_orig(x)
% ZDT1 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T1.
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

% Cálculo de h
h = 1 - sqrt(f1/gx);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

