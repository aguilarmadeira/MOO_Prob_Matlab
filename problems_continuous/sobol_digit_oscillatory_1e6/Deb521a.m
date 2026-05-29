function varargout = Deb521a(varargin)
%DEB521A  Deb521a (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 558.749     ]   (range: 558.749     )
%   x2   ∈ [0           , 372.195     ]   (range: 372.195     )
%
% Effective contrast ratio (max range / min range): 1.50122482034641
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f1 = x1, f2 = g*(1-sqrt(f1/g)), on g=1 (x2=0)
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x2 = 0
%
% USAGE:
%   F = Deb521a(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = Deb521a('bounds')  % Get bounds
%   info = Deb521a()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [558.7491075893589;372.1954899869207];
scale_factors = [558.7491075893589;372.1954899869207];
contrast_ratio = 1.50122482034641;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Deb521a';
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
    info.pareto_front_known = true;
    info.pf_type = 'convex';
    info.pf_expression = 'f1 = x1, f2 = g*(1-sqrt(f1/g)), on g=1 (x2=0)';
    info.pareto_set_known = true;
    info.ps_expression = 'x2 = 0';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'Deb521a: Convex PF. Ref: Deb (1999).';
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
F = Deb521a_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Deb521a_orig)
% -------------------------------------------------------------------------
function f = Deb521a_orig(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%
%   Example 5.2.1 (Biased Search Space).
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%
%   MATLAB version by J. F. A. Madeira
%   November 7, 2025
%
%###############################################################################
%
% Problem characteristics:
% - Number of variables: 2
% - Number of objectives: 2
%   Bounds: x1 in [0,1], x2 in [0,1]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Deb521a requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
gamma = 0.25;

% Initialize objectives
f = zeros(M, 1);

% Function f1
ff1 = x(1);

% g function
gx = 1 + x(2)^gamma;

% h function
h = 1 - (ff1/gx)^2;

% Objective functions
f(1) = ff1;
f(2) = gx * h;

end

