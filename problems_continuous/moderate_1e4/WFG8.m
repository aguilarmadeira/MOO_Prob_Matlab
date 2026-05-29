function varargout = WFG8(varargin)
%WFG8  WFG8 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (MODERATE HETEROGENEITY):
%
%   x1   ∈ [0           , 2           ]   (range: 2           )
%   x2   ∈ [0           , 18.5664     ]   (range: 18.5664     )
%   x3   ∈ [0           , 129.266     ]   (range: 129.266     )
%   x4   ∈ [0           , 800         ]   (range: 800         )
%   x5   ∈ [0           , 2.15443     ]   (range: 2.15443     )
%   x6   ∈ [0           , 0.556991    ]   (range: 0.556991    )
%   x7   ∈ [0           , 0.14        ]   (range: 0.14        )
%   x8   ∈ [0           , 16          ]   (range: 16          )
%
% Effective contrast ratio (max range / min range): 10000
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = WFG8(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = WFG8('bounds')  % Get bounds
%   info = WFG8()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 8;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0];
ub_orig = [2;4;6;8;10;12;14;16];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [2;18.56635533445111;129.266081401913;800;2.154434690031884;0.5569906600335335;0.14;16];
scale_factors = [1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1];
contrast_ratio = 10000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG8';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'moderate';
    info.kappa = 10000;
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
    info.pareto_note = 'WFG8: PF shape defined by WFG toolkit shape functions; no simple closed-form. Ref: Huband et al. (2006).';
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
    error('Input x must have 8 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = WFG8_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to WFG8_orig)
% -------------------------------------------------------------------------
function f = WFG8_orig(z)
% WFG8 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG8.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: z is a n-dimensional vector where n = k+l (k=4, l=4)
%
%   Problem characteristics:
%   n = 8 (k=4 position-related, l=4 distance-related); M = 3 objectives.
%   Variable z_i has bound [0, 2*i] (z_i in [0, zmax_i], zmax_i = 2*i).
%   Bounds: x1 in [0,2], x2 in [0,4], x3 in [0,6], x4 in [0,8], x5 in [0,10], x6 in [0,12], x7 in [0,14], x8 in [0,16]
%
%   Output: f is a M-dimensional vector (M=3) with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
M = 3;      % número de objetivos
k = 4;      % número de variáveis relacionadas à posição
l = 4;      % número de variáveis relacionadas à distância
n = k + l;  % número total de variáveis

pi = 4*atan(1);
pi2 = 2*atan(1);

% Parâmetros S
S = zeros(M, 1);
for m = 1:M
    S(m) = 2*m;
end

% Parâmetros A
A = ones(M-1, 1);  % neq WFG3

% Parâmetros zmax
zmax = zeros(n, 1);
for i = 1:n
    zmax(i) = 2*i;
end

% Transform z into [0,1] set
y = zeros(n, 1);
for i = 1:n
    y(i) = z(i)/zmax(i);
end

% First level mapping - Diferente do WFG7, função de inclinação dependente aplicada em l
w = ones(n, 1);  % default weight
AA = 0.98/49.98;
BB = 0.02;
CC = 50;
r_sum = zeros(n-k, 1);

% Cálculo de r_sum (soma ponderada das posições das variáveis anteriores)
for i = k+1:n
    sum_numerator = 0;
    sum_denominator = 0;
    for j = 1:i-1
        sum_numerator = sum_numerator + w(j)*y(j);
        sum_denominator = sum_denominator + w(j);
    end
    r_sum(i-k) = sum_numerator / sum_denominator;
end

% Cálculo de t1
t1 = zeros(n, 1);
for i = 1:n
    if i <= k
        t1(i) = y(i);
    else
        t1(i) = y(i)^(BB + (CC-BB)*(AA - (1-2*r_sum(i-k))*abs(floor(0.5-r_sum(i-k))+AA)));
    end
end

% Second level mapping - Similar ao WFG1/WFG2/WFG3/WFG7
t2 = zeros(n, 1);
for i = 1:n
    if i <= k
        t2(i) = t1(i);
    else
        t2(i) = abs(t1(i)-0.35)/abs(floor(0.35-t1(i))+0.35);
    end
end

% Third level mapping - Redução de dimensionalidade, como nos anteriores
t3 = zeros(M, 1);

for i = 1:M
    if i <= M-1
        numerator = 0;
        denominator = 0;
        for j = floor((i-1)*k/(M-1))+1 : floor(i*k/(M-1))
            numerator = numerator + w(j)*t2(j);
            denominator = denominator + w(j);
        end
        t3(i) = numerator / denominator;
    else
        numerator = 0;
        denominator = 0;
        for j = k+1 : n
            numerator = numerator + w(j)*t2(j);
            denominator = denominator + w(j);
        end
        t3(i) = numerator / denominator;
    end
end

% Define objective function variables - Idêntico ao WFG4-WFG7
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t3(M), A(i))*(t3(i)-0.5)+0.5;
    else
        x(i) = t3(M);
    end
end

% Define objective function function h - Idêntico ao WFG4-WFG7
h = zeros(M, 1);

% Compute h[1]
h(1) = 1.0;
for i = 1:M-1
    h(1) = h(1) * sin(x(i)*pi2);
end

% Compute h[m] for m = 2,...,M-1
for m = 2:M-1
    h(m) = 1.0;
    for i = 1:M-m
        h(m) = h(m) * sin(x(i)*pi2);
    end
    h(m) = h(m) * cos(x(M-m+1)*pi2);
end

% Compute h[M]
h(M) = cos(x(1)*pi2);

% The objective functions
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m)*h(m);
end

% Não há restrições de desigualdade para este problema

end

