function varargout = OKA1(varargin)
%OKA1  OKA1 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (BASELINE HETEROGENEITY):
%
%   x1   ∈ [1.55291     , 7.62201     ]   (range: 6.06909     )
%   x2   ∈ [-1.62621    , 5.79555     ]   (range: 7.42176     )
%
% Effective contrast ratio (max range / min range): 1
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = OKA1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = OKA1('bounds')  % Get bounds
%   info = OKA1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [1.552914270615124;-1.626208021406409];
ub_orig = [7.6220052301799;5.79555495773441];
lb_work = [1.552914270615124;-1.626208021406409];
ub_work = [7.6220052301799;5.79555495773441];
scale_factors = [1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'OKA1';
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
    info.pareto_note = 'OKA1: No analytical PF documented. Ref: Okabe et al. (2004).';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = OKA1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to OKA1_orig)
% -------------------------------------------------------------------------
function f = OKA1_orig(x)
% OKA1 function
%
%   As described by T. Okabe, Y. Jin, M. Olhofer, and B. Sendhoff. "On test
%   functions for evolutionary multi-objective optimization.", Parallel
%   Problem Solving from Nature, VIII, LNCS 3242, Springer, pp.792-802,
%   September 2004.
%
%   Test function OKA1.
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
% - Number of variables: 2
% - Number of objectives: 2
%   Bounds: x1 in [1.55291427062,7.62200523018], x2 in [-1.62620802141,5.79555495773]
%
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
pi = 4*atan(1);

% Variáveis y
y = zeros(2,1);
y(1) = cos(pi/12)*x(1) - sin(pi/12)*x(2);
y(2) = sin(pi/12)*x(1) + cos(pi/12)*x(2);

% Função objetivo 1
f1 = y(1);

% Função objetivo 2
f2 = sqrt(2*pi) - sqrt(abs(y(1))) + 2*abs(y(2) - 3*cos(y(1)) - 3)^(1/3);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema
% As restrições de limites são tratadas pelo algoritmo de otimização

% Note: As restrições são
% 6*sin(pi/12) <= x(1) <= 6*sin(pi/12) + 2*pi*cos(pi/12)
% -2*pi*sin(pi/12) <= x(2) <= 6*cos(pi/12)

end

