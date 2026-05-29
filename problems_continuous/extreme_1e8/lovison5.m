function varargout = lovison5(varargin)
%LOVISON5  lovison5 (n=3, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (EXTREME HETEROGENEITY):
%
%   x1   ∈ [-1          , 4           ]   (range: 5           )
%   x2   ∈ [-1e+08      , 4e+08       ]   (range: 5e+08       )
%   x3   ∈ [-1e+08      , 4e+08       ]   (range: 5e+08       )
%
% Effective contrast ratio (max range / min range): 100000000
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = lovison5(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = lovison5('bounds')  % Get bounds
%   info = lovison5()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 3;
mloc = 3;
lb_orig = [-1;-1;-1];
ub_orig = [4;4;4];
lb_work = [-1;-100000000;-100000000];
ub_work = [4;400000000;400000000];
scale_factors = [1;100000000;100000000];
contrast_ratio = 100000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'lovison5';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'extreme';
    info.kappa = 100000000;
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
    info.pareto_note = 'lovison5: Tri-objective, no analytical PF. Ref: Lovison (2010).';
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
    error('Input x must have 3 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = lovison5_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to lovison5_orig)
% -------------------------------------------------------------------------
function f = lovison5_orig(x)
% LOVISON5 function
%
%   As described by A. Lovison in "A synthetic approach to multiobjective
%   optimization", arxiv Item: http://arxiv.org/abs/1002.0093.
%
%   Example 5.
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
%
%   Bounds: x1 in [-1,4], x2 in [-1,4], x3 in [-1,4]
%
n = 3;   % número de variáveis
m = 3;   % número de funções usadas nos objetivos
pi = 4*atan(1);

% Matriz C (pontos distintos não colineares)
C = [
    0.218418, -0.620254, 0.843784;
    0.914311, -0.788548, 0.428212;
    0.103064, -0.47373, -0.300792
];

% Matriz alpha (diagonal definida negativa)
alpha = [
    0.407247, 0.665212, 0.575807;
    0.942022, 0.363525, 0.00308876;
    0.755598, 0.450103, 0.170122
];

% Vetor beta
beta = [0.575496; 0.675617; 0.180332];

% Vetor gamma
gamma = [-0.593814; -0.492722; 0.0646786];

% Cálculo das funções f(j)
f_aux = zeros(m,1);
for j = 1:m
    f_aux(j) = 0;
    for i = 1:n
        f_aux(j) = f_aux(j) + (-alpha(j,i)*(x(i)-C(i,j))^2);
    end
end

% Função objetivo 1
f1 = -(f_aux(1));

% Função objetivo 2
f2 = -(f_aux(2) + beta(2)*sin(pi*(x(1)+x(2))/gamma(2)));

% Função objetivo 3
f3 = -(f_aux(3) + beta(3)*cos(pi*(x(1)-x(2))/gamma(3)));

% Vetor de funções objetivo
f = [f1; f2; f3];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

end

