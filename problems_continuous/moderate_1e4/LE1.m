function varargout = LE1(varargin)
%LE1  LE1 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (MODERATE HETEROGENEITY):
%
%   x1   ∈ [-5          , 10          ]   (range: 15          )
%   x2   ∈ [-23.2079    , 46.4159     ]   (range: 69.6238     )
%
% Effective contrast ratio (max range / min range): 4.641588833612778
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = LE1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = LE1('bounds')  % Get bounds
%   info = LE1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [-5;-5];
ub_orig = [10;10];
lb_work = [-5;-23.2079441680639];
ub_work = [10;46.41588833612779];
scale_factors = [1;4.641588833612778];
contrast_ratio = 4.641588833612778;

if nargin == 0
    info.name = mfilename;
    info.problem = 'LE1';
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
    info.pareto_note = 'LE1: No analytical PF documented. Ref: Huband et al. (2006).';
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
F = LE1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to LE1_orig)
% -------------------------------------------------------------------------
function f = LE1_orig(x)
% LE1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example LE1, see the previous cited paper for the original reference.
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
%   Bounds: x1 in [-5,10], x2 in [-5,10]
%
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem)

% Função objetivo 1
f1 = (x(1)^2 + x(2)^2)^0.125;

% Função objetivo 2
f2 = ((x(1)-0.5)^2 + (x(2)-0.5)^2)^0.25;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

