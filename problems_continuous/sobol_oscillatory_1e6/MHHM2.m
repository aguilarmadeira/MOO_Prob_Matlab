function varargout = MHHM2(varargin)
%MHHM2  MHHM2 (n=2, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 149289      ]   (range: 149289      )
%   x2   ∈ [0           , 648.789     ]   (range: 648.789     )
%
% Effective contrast ratio (max range / min range): 230.1041603949666
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = MHHM2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = MHHM2('bounds')  % Get bounds
%   info = MHHM2()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 3;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [149289.0625;648.7890625];
scale_factors = [149289.0625;648.7890625];
contrast_ratio = 230.1041603949666;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MHHM2';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_oscillatory';
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
    info.pareto_note = 'MHHM2: Tri-objective, no analytical PF. Ref: Huband et al. (2006).';
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
F = MHHM2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MHHM2_orig)
% -------------------------------------------------------------------------
function f = MHHM2_orig(x)
% MHHM2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MHHM2, see the previous cited paper for the original reference.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 3-dimensional vector with the function values
%
% Problem characteristics:
% - Number of variables: 2 (fixed)
% - Number of objectives: 3 (fixed)
%   Bounds: x1 in [0,1], x2 in [0,1]
%

% Check dimension
n = length(x);
if n ~= 2
    error('MHHM2 requires exactly 2 variables, %d provided', n);
end

% Objective functions
f = zeros(3, 1);
f(1) = (x(1) - 0.8)^2 + (x(2) - 0.6)^2;
f(2) = (x(1) - 0.85)^2 + (x(2) - 0.7)^2;
f(3) = (x(1) - 0.9)^2 + (x(2) - 0.6)^2;

end

