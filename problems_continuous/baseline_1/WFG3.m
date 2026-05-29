function varargout = WFG3(varargin)
%WFG3  WFG3 (n=8, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (BASELINE HETEROGENEITY):
%
%   x1   ∈ [0           , 2           ]   (range: 2           )
%   x2   ∈ [0           , 4           ]   (range: 4           )
%   x3   ∈ [0           , 6           ]   (range: 6           )
%   x4   ∈ [0           , 8           ]   (range: 8           )
%   x5   ∈ [0           , 10          ]   (range: 10          )
%   x6   ∈ [0           , 12          ]   (range: 12          )
%   x7   ∈ [0           , 14          ]   (range: 14          )
%   x8   ∈ [0           , 16          ]   (range: 16          )
%
% Effective contrast ratio (max range / min range): 1
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = WFG3(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = WFG3('bounds')  % Get bounds
%   info = WFG3()          % Get complete problem information
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
ub_work = [2;4;6;8;10;12;14;16];
scale_factors = [1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG3';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'baseline';
    info.kappa = 1;
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
    info.pareto_note = 'WFG3: PF shape defined by WFG toolkit shape functions; no simple closed-form. Ref: Huband et al. (2006).';
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
F = WFG3_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to WFG3_orig)
% -------------------------------------------------------------------------
function f = WFG3_orig(z)
% WFG3 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG3.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
% Problem characteristics:
% - Number of variables: 8
% - Number of objectives: 3
%   Bounds: x1 in [0,2], x2 in [0,4], x3 in [0,6], x4 in [0,8], x5 in [0,10], x6 in [0,12], x7 in [0,14], x8 in [0,16]
%
%
%   Input: z is a n-dimensional vector where n = k+l (k=4, l=4)
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

% Parâmetros A - Diferente do WFG1 e WFG2
A = zeros(M-1, 1);
for i = 1:M-1
    if i <= 1
        A(i) = 1;
    else
        A(i) = 0;
    end
end

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

% First level mapping
t1 = zeros(n, 1);
for i = 1:n
    if i <= k
        t1(i) = y(i);
    else
        t1(i) = abs(y(i)-0.35)/abs(floor(0.35-y(i))+0.35);
    end
end

% Second level mapping - Igual ao WFG2
AA = 2;
t2 = zeros(k+l/2, 1);
for i = 1:k+l/2
    if i <= k
        t2(i) = t1(i);
    else
        sum_val = 0;
        start_idx = k + 2*(i-k) - 1;
        end_idx = k + 2*(i-k);
        num_items = end_idx - start_idx + 1;
        
        for ii = start_idx:end_idx
            inner_sum = 0;
            for jj = 0:AA-2
                % Esta parte envolve cálculo de módulo para criar pares cíclicos
                idx1 = ii;
                tmp = mod(ii + jj - start_idx + 1, num_items);
                if tmp == 0
                    tmp = num_items;
                end
                idx2 = start_idx + tmp - 1;
                inner_sum = inner_sum + abs(t1(idx1) - t1(idx2));
            end
            sum_val = sum_val + (t1(ii) + inner_sum);
        end
        
        divisor = (num_items / AA) * ceil(AA/2) * (1 + 2*AA - 2*ceil(AA/2));
        t2(i) = sum_val / divisor;
    end
end

% Third level mapping - Igual ao WFG2
w = ones(n, 1);
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
        for j = k+1 : k+l/2
            numerator = numerator + w(j)*t2(j);
            denominator = denominator + w(j);
        end
        t3(i) = numerator / denominator;
    end
end

% Define objective function variables
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t3(M), A(i))*(t3(i)-0.5)+0.5;
    else
        x(i) = t3(M);
    end
end

% Define objective function function h - Diferente do WFG1 e WFG2
h = zeros(M, 1);

% Compute h[1]
h(1) = 1.0;
for i = 1:M-1
    h(1) = h(1) * x(i);
end

% Compute h[m] for m = 2,...,M-1
for m = 2:M-1
    h(m) = 1.0;
    for i = 1:M-m
        h(m) = h(m) * x(i);
    end
    h(m) = h(m) * (1-x(M-m+1));
end

% Compute h[M]
h(M) = 1 - x(1);

% The objective functions
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m)*h(m);
end

% Não há restrições de desigualdade para este problema

end

