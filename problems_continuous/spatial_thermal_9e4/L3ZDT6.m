function varargout = L3ZDT6(varargin)
%L3ZDT6  L3ZDT6 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SPATIAL_THERMAL HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 1           ]   (range: 1           )
%   x3   ∈ [0           , 1           ]   (range: 1           )
%   x4   ∈ [0           , 1           ]   (range: 1           )
%   x5   ∈ [0           , 1           ]   (range: 1           )
%   x6   ∈ [0           , 300         ]   (range: 300         )
%   x7   ∈ [0           , 300         ]   (range: 300         )
%   x8   ∈ [0           , 300         ]   (range: 300         )
%   x9   ∈ [0           , 300         ]   (range: 300         )
%   x10  ∈ [0           , 300         ]   (range: 300         )
%
% Effective contrast ratio (max range / min range): 300
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = L3ZDT6(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = L3ZDT6('bounds')  % Get bounds
%   info = L3ZDT6()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;300;300;300;300;300];
scale_factors = [1;1;1;1;1;300;300;300;300;300];
contrast_ratio = 300;

if nargin == 0
    info.name = mfilename;
    info.problem = 'L3ZDT6';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'L3ZDT6: Expected PF same as ZDT6 (f2=1-f1^2); landscape-modified. Ref: Deb et al. (2006).';
    info.mapping = 't=(x-lb_work)./(ub_work-lb_work); t=max(0,min(1,t)); x_orig=lb_orig+t.*(ub_orig-lb_orig)';
    varargout{1} = info;
    return
end

arg1 = varargin{1};
if isempty(arg1)
    error('Input argument is empty. Use F=f(x) or [lb,ub]=f(''bounds'').');
end
if (ischar(arg1) || (isstring(arg1) && isscalar(arg1))) && strcmpi(char(arg1),'bounds')
    varargout{1} = lb_work;
    if nargout >= 2, varargout{2} = ub_work; end
    return
end

if (ischar(arg1) || (isstring(arg1) && isscalar(arg1)))
    error('Unknown string argument ''%s''. Use ''bounds'' or call with x.', char(arg1));
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
return
end  % main wrapper function

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
%
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1]
%
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

