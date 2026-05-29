function varargout = ZDT4(varargin)
%ZDT4  ZDT4 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (PROGRESSIVE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [-50         , 50          ]   (range: 100         )
%   x3   ∈ [-500        , 500         ]   (range: 1000        )
%   x4   ∈ [-5000       , 5000        ]   (range: 10000       )
%   x5   ∈ [-0.5        , 0.5         ]   (range: 1           )
%   x6   ∈ [-0.05       , 0.05        ]   (range: 0.1         )
%   x7   ∈ [-0.005      , 0.005       ]   (range: 0.01        )
%   x8   ∈ [-5          , 5           ]   (range: 10          )
%   x9   ∈ [-50         , 50          ]   (range: 100         )
%   x10  ∈ [-500        , 500         ]   (range: 1000        )
%
% Effective contrast ratio (max range / min range): 1000000
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f2 = 1 - sqrt(f1), f1 in [0,1]
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x1 in [0,1], x_i = 0 for i = 2..n
%
% USAGE:
%   F = ZDT4(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZDT4('bounds')  % Get bounds
%   info = ZDT4()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 2;
lb_orig = [0;-5;-5;-5;-5;-5;-5;-5;-5;-5];
ub_orig = [1;5;5;5;5;5;5;5;5;5];
lb_work = [0;-50;-500;-5000;-0.5;-0.05;-0.005;-5;-50;-500];
ub_work = [1;50;500;5000;0.5;0.05;0.005;5;50;500];
scale_factors = [1;10;100;1000;0.1;0.01;0.001;1;10;100];
contrast_ratio = 1000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT4';
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
    info.pareto_front_known = true;
    info.pf_type = 'convex';
    info.pf_expression = 'f2 = 1 - sqrt(f1), f1 in [0,1]';
    info.pareto_set_known = true;
    info.ps_expression = 'x1 in [0,1], x_i = 0 for i = 2..n';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'ZDT4: Same PF as ZDT1; multimodal landscape (21^9 local fronts). Ref: Zitzler et al. (2000).';
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
F = ZDT4_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT4_orig)
% -------------------------------------------------------------------------
function f = ZDT4_orig(x)
% ZDT4 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T4.
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
%
%   Problem characteristics:
%   m = 10 variables; 2 objectives.
%   Variable x1 in [0,1]; variables x2..x10 in [-5,5].
%   Bounds: x1 in [0,1], x2 in [-5,5], x3 in [-5,5], x4 in [-5,5], x5 in [-5,5], x6 in [-5,5], x7 in [-5,5], x8 in [-5,5], x9 in [-5,5], x10 in [-5,5]
%
%   Output: f is a 2-dimensional vector with the function values
%          handled by the optimization algorithm)

% Parâmetros
m = 10;
pi = 4*atan(1);

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x) - Multimodal com muitos ótimos locais
gx = 1 + 10*(m-1) + sum(x(2:m).^2 - 10*cos(4*pi*x(2:m)));

% Cálculo de h - Similar ao ZDT1
h = 1 - sqrt(f1/gx);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


% Note que este problema tem limites diferentes:
% 0 <= x(1) <= 1
% -5 <= x(i) <= 5 para i=2,...,m

end

