function varargout = WFG2(varargin)
%WFG2  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: WFG2
% Dimension: n = 8, objectives m = 3
% Strategy: sobol_oscillatory (kappa = 1000000)
% Effective contrast: 680.5457476716454
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = WFG2();
%   [lb,ub] = WFG2('bounds');
%   F = WFG2(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = WFG2_orig(x_orig)

nloc = 8;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625];
contrast_ratio = 680.5457476716454;

if nargin == 0
    info.name = mfilename;
    info.problem = 'WFG2';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_oscillatory';
    info.kappa = 1000000;
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
    error('Input x must have 8 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = WFG2_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to WFG2_orig)
% -------------------------------------------------------------------------
function f = WFG2_orig(z)
% WFG2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example WFG2.
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

% First level mapping
t1 = zeros(n, 1);
for i = 1:n
    if i <= k
        t1(i) = y(i);
    else
        t1(i) = abs(y(i)-0.35)/abs(floor(0.35-y(i))+0.35);
    end
end

% Second level mapping
AA = 2;
t2 = zeros(k+l/2, 1);
for i = 1:k+l/2
    if i <= k
        t2(i) = t1(i);
    else
        % Este nível de mapeamento é diferente do WFG1
        sum_val = 0;
        start_idx = k + 2*(i-k) - 1;
        end_idx = k + 2*(i-k);
        num_items = end_idx - start_idx + 1;
        
        for ii = start_idx:end_idx
            inner_sum = 0;
            for jj = 0:AA-2
                % Esta parte envolve cálculo de módulo para criar pares cíclicos
                idx1 = ii;
                tmp = (ii + jj - start_idx + 1) % num_items;
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

% Third level mapping
w = ones(n, 1);  % Note a diferença para WFG1, onde w(i) = 2*i
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
        for j = k+1 : k+l/2  % Diferente do WFG1: aqui vai até k+l/2
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

% Define objective function function h - diferente do WFG1 no último caso
alpha = 1;
beta = 1;
AAAA = 5;
h = zeros(M, 1);

% Compute h[1]
h(1) = 1.0;
for i = 1:M-1
    h(1) = h(1) * (1-cos(x(i)*pi2));
end

% Compute h[m] for m = 2,...,M-1
for m = 2:M-1
    h(m) = 1.0;
    for i = 1:M-m
        h(m) = h(m) * (1-cos(x(i)*pi2));
    end
    h(m) = h(m) * (1-sin(x(M-m+1)*pi2));
end

% Compute h[M] - diferente do WFG1
h(M) = 1 - (x(1))^alpha * cos(AAAA*(x(1))^beta*pi)^2;

% The objective functions
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m)*h(m);
end

% Não há restrições de desigualdade para este problema

end

