function varargout = lovison6(varargin)
%LOVISON6  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: lovison6
% Dimension: n = 3, objectives m = 3
% Strategy: extreme (kappa = 100000000)
% Effective contrast: 100000000
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = lovison6();
%   [lb,ub] = lovison6('bounds');
%   F = lovison6(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = lovison6_orig(x_orig)

nloc = 3;
mloc = 3;
lb_orig = [0;0;0];
ub_orig = [1;1;1];
lb_work = [0;0;0];
ub_work = [1;100000000;100000000];
scale_factors = [1;100000000;100000000];
contrast_ratio = 100000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'lovison6';
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
F = lovison6_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to lovison6_orig)
% -------------------------------------------------------------------------
function f = lovison6_orig(x)
% LOVISON6 function
%
%   As described by A. Lovison in "A synthetic approach to multiobjective
%   optimization", arxiv Item: http://arxiv.org/abs/1002.0093.
%
%   Example 6.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered -1<=x[i]<=4, i=1,2,3.
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
%   Output: f is a 3-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Parâmetros do problema
n = 3;   % número de variáveis
m = 4;   % número de funções usadas nos objetivos
pi = 4*atan(1);

% Matriz C (pontos distintos não colineares)
C = [
    0.218418, -0.620254, 0.843784, 0.914311;
    -0.788548, 0.428212, 0.103064, -0.47373;
    -0.300792, -0.185507, 0.330423, 0.151614
];

% Matriz alpha (diagonal definida negativa)
alpha = [
    0.942022, 0.363525, 0.00308876;
    0.755598, 0.450103, 0.170122;
    0.787748, 0.837808, 0.590166;
    0.203093, 0.253639, 0.532339
];

% Vetor beta
beta = [-0.666503; -0.945716; -0.334582; 0.611894];

% Vetor gamma
gamma = [0.281032; 0.508749; -0.0265389; -0.920133];

% Cálculo das funções f(j)
f_aux = zeros(m,1);
for j = 1:m
    f_aux(j) = 0;
    for i = 1:n
        f_aux(j) = f_aux(j) + (-alpha(j,i)*(x(i)-C(i,j))^2);
    end
end

% Função objetivo 1
f1 = -(f_aux(1) + beta(1)*exp(f_aux(4)/gamma(1)));

% Função objetivo 2
f2 = -(f_aux(2) + beta(2)*sin(pi*(x(1)+x(2))/gamma(2)));

% Função objetivo 3
f3 = -(f_aux(3) + beta(3)*cos(pi*(x(1)-x(2))/gamma(3)));

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

end

