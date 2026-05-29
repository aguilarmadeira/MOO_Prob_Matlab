function varargout = ZLT1(varargin)
%ZLT1  ZLT1 (n=10, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-5.005e+08  , 5.005e+08   ]   (range: 1.001e+09   )
%   x2   ∈ [-250750     , 250750      ]   (range: 501500      )
%   x3   ∈ [-7.5025e+08 , 7.5025e+08  ]   (range: 1.5005e+09  )
%   x4   ∈ [-125875     , 125875      ]   (range: 251750      )
%   x5   ∈ [-6.25375e+08, 6.25375e+08 ]   (range: 1.25075e+09 )
%   x6   ∈ [-375625     , 375625      ]   (range: 751250      )
%   x7   ∈ [-8.75125e+08, 8.75125e+08 ]   (range: 1.75025e+09 )
%   x8   ∈ [-63437.5    , 63437.5     ]   (range: 126875      )
%   x9   ∈ [-5.62938e+08, 5.62938e+08 ]   (range: 1.12588e+09 )
%   x10  ∈ [-313188     , 313188      ]   (range: 626375      )
%
% Effective contrast ratio (max range / min range): 13795.07389162562
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = ZLT1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZLT1('bounds')  % Get bounds
%   info = ZLT1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 3;
lb_orig = [-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000;-1000];
ub_orig = [1000;1000;1000;1000;1000;1000;1000;1000;1000;1000];
lb_work = [-500500000;-250750;-750250000;-125875;-625375000;-375625;-875125000;-63437.5;-562937500;-313187.5];
ub_work = [500500000;250750;750250000;125875;625375000;375625;875125000;63437.5;562937500;313187.5];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875];
contrast_ratio = 13795.07389162562;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZLT1';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'halton_oscillatory';
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
    info.pareto_note = 'ZLT1: Tri-objective, no analytical PF. Ref: Huband et al. (2006).';
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
F = ZLT1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZLT1_orig)
% -------------------------------------------------------------------------
function f = ZLT1_orig(x)
% ZLT1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example ZLT1, see the previous cited paper for the original reference.
%
%   In the above paper the number of variables was set equal to 100. 
%   We selected n=10 as default.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a n-dimensional vector, where n = 10
%
%   Problem characteristics:
%   n = 10 variables; M = 3 objectives.
%   Bounds: x1 in [-1000,1000], x2 in [-1000,1000], x3 in [-1000,1000], x4 in [-1000,1000], x5 in [-1000,1000], x6 in [-1000,1000], x7 in [-1000,1000], x8 in [-1000,1000], x9 in [-1000,1000], x10 in [-1000,1000]
%
%   Output: f is a M-dimensional vector (M=3) with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
n = 10;  % número de variáveis
M = 3;   % número de funções objetivo

% Inicializar vetor de funções objetivo
f = zeros(M, 1);

% Cálculo das M funções objetivo
for m = 1:M
    % Termo principal: (x_m - 1)^2
    f(m) = (x(m) - 1)^2;
    
    % Somar os quadrados de todas as outras variáveis
    for i = 1:n
        if i ~= m
            f(m) = f(m) + x(i)^2;
        end
    end
end

% Não há restrições de desigualdade para este problema

end

