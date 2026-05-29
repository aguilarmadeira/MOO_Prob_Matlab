function varargout = SK2(varargin)
%SK2  SK2 (n=4, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-5.005e+06  , 5.005e+06   ]   (range: 1.001e+07   )
%   x2   ∈ [-2507.5     , 2507.5      ]   (range: 5015        )
%   x3   ∈ [-7.5025e+06 , 7.5025e+06  ]   (range: 1.5005e+07  )
%   x4   ∈ [-1258.75    , 1258.75     ]   (range: 2517.5      )
%
% Effective contrast ratio (max range / min range): 5960.278053624627
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = SK2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = SK2('bounds')  % Get bounds
%   info = SK2()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 4;
mloc = 2;
lb_orig = [-10;-10;-10;-10];
ub_orig = [10;10;10;10];
lb_work = [-5005000;-2507.5;-7502500;-1258.75];
ub_work = [5005000;2507.5;7502500;1258.75];
scale_factors = [500500;250.75;750250;125.875];
contrast_ratio = 5960.278053624627;

if nargin == 0
    info.name = mfilename;
    info.problem = 'SK2';
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
    info.pareto_note = 'SK2: No analytical PF. Ref: Huband et al. (2006).';
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
    error('Input x must have 4 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = SK2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to SK2_orig)
% -------------------------------------------------------------------------
function f = SK2_orig(x)
% SK2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example SK2, see the previous cited paper for the original reference.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered -10<=x[i]<=10, i=1,2,3,4.
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
% - Number of variables: 4
% - Number of objectives: 2
%   Bounds: x1 in [-10,10], x2 in [-10,10], x3 in [-10,10], x4 in [-10,10]
%
%
%   Input: x is a 4-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Função objetivo 1
f1 = -(-(x(1)-2)^2 - (x(2)+3)^2 - (x(3)-5)^2 - (x(4)-4)^2 + 5);

% Função objetivo 2
sum_sin = 0;
sum_square = 0;
for i = 1:4
    sum_sin = sum_sin + sin(x(i));
    sum_square = sum_square + x(i)^2;
end
f2 = -(sum_sin / (1 + sum_square/100));

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

