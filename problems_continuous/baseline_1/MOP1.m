function varargout = MOP1(varargin)
%MOP1  MOP1 (n=1, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (BASELINE HETEROGENEITY):
%
%   x1   ∈ [-100000     , 100000      ]   (range: 200000      )
%
% Effective contrast ratio (max range / min range): 1
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f1 = x^2, f2 = (x-2)^2; PF parametric via x in [0,2]
%   Ideal point: [0 0]
%   Nadir point: [4 4]
%   Pareto set: x in [0, 2]
%
% USAGE:
%   F = MOP1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = MOP1('bounds')  % Get bounds
%   info = MOP1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 1;
mloc = 2;
lb_orig = -100000;
ub_orig = 100000;
lb_work = -100000;
ub_work = 100000;
scale_factors = 1;
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP1';
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
    info.pareto_front_known = true;
    info.pf_type = 'convex';
    info.pf_expression = 'f1 = x^2, f2 = (x-2)^2; PF parametric via x in [0,2]';
    info.pareto_set_known = true;
    info.ps_expression = 'x in [0, 2]';
    info.ideal_point = [0;0];
    info.nadir_point = [4;4];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [4.4;4.4];
    info.pareto_note = 'MOP1: Same structure as Sch1. Ref: Huband et al. (2006).';
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
    error('Input x must have 1 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP1_orig)
% -------------------------------------------------------------------------
function f = MOP1_orig(x)
% MOP1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP1, Van Valedhuizen's test suit.
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
% - Number of variables: 1
% - Number of objectives: 2
%   Bounds: x1 in [-100000,100000]
%
%
%   Input: x is a scalar variable
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Função objetivo 1
f1 = x^2;

% Função objetivo 2
f2 = (x-2)^2;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

