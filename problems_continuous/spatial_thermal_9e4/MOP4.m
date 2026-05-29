function varargout = MOP4(varargin)
%MOP4  MOP4 (n=3, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SPATIAL_THERMAL HETEROGENEITY):
%
%   x1   ∈ [-5          , 5           ]   (range: 10          )
%   x2   ∈ [-1500       , 1500        ]   (range: 3000        )
%   x3   ∈ [-1500       , 1500        ]   (range: 3000        )
%
% Effective contrast ratio (max range / min range): 300
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = MOP4(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = MOP4('bounds')  % Get bounds
%   info = MOP4()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 3;
mloc = 2;
lb_orig = [-5;-5;-5];
ub_orig = [5;5;5];
lb_work = [-5;-1500;-1500];
ub_work = [5;1500;1500];
scale_factors = [1;300;300];
contrast_ratio = 300;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP4';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
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
    info.pareto_note = 'MOP4: No analytical PF documented. Ref: Huband et al. (2006).';
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
    error('Input x must have 3 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP4_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP4_orig)
% -------------------------------------------------------------------------
function f = MOP4_orig(x)
% MOP4 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP4, Van Valedhuizen's test suit.
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
% - Number of variables: 3
% - Number of objectives: 2
%   Bounds: x1 in [-5,5], x2 in [-5,5], x3 in [-5,5]
%
%
%   Input: x is a 3-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = 0;
for i = 1:2
    f1 = f1 + (-10 * exp(-0.2 * sqrt(x(i)^2 + x(i+1)^2)));
end

% Função objetivo 2
f2 = 0;
for i = 1:3
    f2 = f2 + (abs(x(i))^0.8 + 5*sin(x(i)^3));
end

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

