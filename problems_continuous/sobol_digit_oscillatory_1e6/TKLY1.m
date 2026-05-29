function varargout = TKLY1(varargin)
%TKLY1  TKLY1 (n=4, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [76056.7     , 760567      ]   (range: 684510      )
%   x2   ∈ [0           , 11130.6     ]   (range: 11130.6     )
%   x3   ∈ [0           , 503223      ]   (range: 503223      )
%   x4   ∈ [0           , 252928      ]   (range: 252928      )
%
% Effective contrast ratio (max range / min range): 68.33094593871758
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = TKLY1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = TKLY1('bounds')  % Get bounds
%   info = TKLY1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 4;
mloc = 2;
lb_orig = [0.1;0;0;0];
ub_orig = [1;1;1;1];
lb_work = [76056.72030518443;0;0;0];
ub_work = [760567.2030518444;11130.64062853684;503223.2377600991;252928.110946947];
scale_factors = [760567.2030518443;11130.64062853684;503223.2377600991;252928.110946947];
contrast_ratio = 68.33094593871758;

if nargin == 0
    info.name = mfilename;
    info.problem = 'TKLY1';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_digit_oscillatory';
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
    info.pareto_note = 'TKLY1: No closed-form PF documented with certainty. Ref: Huband et al. (2006).';
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
F = TKLY1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to TKLY1_orig)
% -------------------------------------------------------------------------
function f = TKLY1_orig(x)
% TKLY1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example TKLY1, see the previous cited paper for the original reference.
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
%   Bounds: x1 in [0.1,1], x2 in [0,1], x3 in [0,1], x4 in [0,1]
%
%
%   Input: x is a 4-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = x(1);

% Função objetivo 2
prod_term = 1.0;
for i = 2:4
    prod_term = prod_term * (2.0 - exp(-((x(i)-0.1)/0.004)^2) - 0.8*exp(-((x(i)-0.9)/0.4)^2));
end
f2 = prod_term / x(1);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

end

