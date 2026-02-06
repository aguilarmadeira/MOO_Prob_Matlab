function varargout = WFG8(varargin)
%WFG8  WFG8 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (PROGRESSIVE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 10          ]   (range: 10          )
%   x3   ∈ [0           , 100         ]   (range: 100         )
%   x4   ∈ [0           , 1000        ]   (range: 1000        )
%   x5   ∈ [0           , 0.1         ]   (range: 0.1         )
%   x6   ∈ [0           , 0.01        ]   (range: 0.01        )
%   x7   ∈ [0           , 0.001       ]   (range: 0.001       )
%   x8   ∈ [0           , 1           ]   (range: 1           )
%
% Effective contrast ratio (max range / min range): 1000000
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
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
ub_orig = [1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [1;10;100;1000;0.1;0.01;0.001;1];
scale_factors = [1;10;100;1000;0.1;0.01;0.001;1];
contrast_ratio = 1000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG8';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'progressive';
    info.kappa = 1000000;
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
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
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
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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

