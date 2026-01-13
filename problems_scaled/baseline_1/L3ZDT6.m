function varargout = L3ZDT6(varargin)
%L3ZDT6  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: L3ZDT6
% Dimension: n = 10, objectives m = 2
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = L3ZDT6();
%   [lb,ub] = L3ZDT6('bounds');
%   F = L3ZDT6(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = L3ZDT6_orig(x_orig)

nloc = 10;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'L3ZDT6';
    info.n = nloc; info.m = mloc;
    info.strategy = 'baseline';
    info.kappa = 1;
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
F = L3ZDT6_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to L3ZDT6_orig)
% -------------------------------------------------------------------------
function f = L3ZDT6_orig(x)
% L3ZDT6 function
%
%   As described by K. Deb and A. Sinha and S. Kukkonen in "Multi-objective
%   test problems, linkages, and evolutionary methodologies", GECCO'06}: 
%   Proceedings of the 8th Annual Conference on Genetic and Evolutionary 
%   Computation, 1141-1148, 2006.
%
%   Example T6, with linkage L3.
%
%   In the above paper the number of variables was set to 30. 
%   We selected n=10 according to the dimension of problem ZDT6.
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
%   Output: c is a vector of constraints (empty for this problem)

% Número de variáveis
m = 10;
pi = 4*atan(1);

% Matrix M (matriz de transformação)
M = [
    0.218418, -0.620254, 0.843784, 0.914311, -0.788548, 0.428212, 0.103064, -0.47373, -0.300792, -0.185507;
    0.330423, 0.151614, 0.884043, -0.272951, -0.993822, 0.511197, -0.0997948, -0.659756, 0.575496, 0.675617;
    0.180332, -0.593814, -0.492722, 0.0646786, -0.666503, -0.945716, -0.334582, 0.611894, 0.281032, 0.508749;
    -0.0265389, -0.920133, 0.308861, -0.0437502, -0.374203, 0.207359, -0.219433, 0.914104, 0.184408, 0.520599;
    -0.88565, -0.375906, -0.708948, -0.37902, 0.576578, 0.0194674, -0.470262, 0.572576, 0.351245, -0.480477;
    0.238261, -0.1596, -0.827302, 0.669248, 0.494475, 0.691715, -0.198585, 0.0492812, 0.959669, 0.884086;
    -0.218632, -0.865161, -0.715997, 0.220772, 0.692356, 0.646453, -0.401724, 0.615443, -0.0601957, -0.748176;
    -0.207987, -0.865931, 0.613732, -0.525712, -0.995728, 0.389633, -0.064173, 0.662131, -0.707048, -0.340423;
    0.60624, 0.0951648, -0.160446, -0.394585, -0.167581, 0.0679849, 0.449799, 0.733505, -0.00918638, 0.00446808;
    0.404396, 0.449996, 0.162711, 0.294454, -0.563345, -0.114993, 0.549589, -0.775141, 0.677726, 0.610715
];

% Cálculo das variáveis y usando a transformação quadrática
y = zeros(m,1);
for i = 1:m
    y(i) = 0;
    for j = 1:m
        y(i) = y(i) + M(i,j) * x(j)^2; % Note o uso do quadrado aqui
    end
end

% Função objetivo 1
f1 = y(1)^2;

% Função g(x) - Note que aqui a função tem uma raiz quarta
soma = 0;
for i = 2:m
    soma = soma + y(i)^2;
end
gx = 1 + 9 * ((soma/(m-1))^0.25);

% Função h
h = 1 - (f1/gx)^2;

% Vetor de funções objetivo
f = [f1; gx*h];

% Não há restrições de desigualdade para este problema

end

