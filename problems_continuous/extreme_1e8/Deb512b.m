function varargout = Deb512b(varargin)
%DEB512B  Deb512b (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (EXTREME HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 1e+08       ]   (range: 1e+08       )
%
% Effective contrast ratio (max range / min range): 100000000
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f2 = 1 - sqrt(f1), on g=1 (x2=0)
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x2 = 0
%
% USAGE:
%   F = Deb512b(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = Deb512b('bounds')  % Get bounds
%   info = Deb512b()          % Get complete problem information
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
ub_work = [1;100000000];
scale_factors = [1;100000000];
contrast_ratio = 100000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Deb512b';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'extreme';
    info.kappa = 100000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'convex';
    info.pf_expression = 'f2 = 1 - sqrt(f1), on g=1 (x2=0)';
    info.pareto_set_known = true;
    info.ps_expression = 'x2 = 0';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'Deb512b: Convex PF (same shape as ZDT1). Ref: Deb (1999).';
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
F = Deb512b_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Deb512b_orig)
% -------------------------------------------------------------------------
function f = Deb512b_orig(x)
%###############################################################################
%
%   As described by K. Deb in "Multi-objective Genetic Algorithms: Problem
%   Difficulties and Construction of Test Problems", Evolutionary Computation 
%   7(3): 205-230, 1999.
%           
%   Example 5.1.2 (Non-convex Pareto-optimal Front).
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
    error('Deb512b requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
beta = 1;
alpha = 4;

% Initialize objectives
f = zeros(M, 1);

% Function f1
ff1 = 4 * x(1);

% g function
if x(2) <= 0.4
    gx = 4 - 3*exp(-((x(2)-0.2)/0.02)^2);
else
    gx = 4 - 2*exp(-((x(2)-0.7)/0.2)^2);
end

% h function
if ff1 <= beta*gx
    h = 1 - (ff1/(beta*gx))^alpha;
else
    h = 0;
end

% Objective functions
f(1) = ff1;
f(2) = gx * h;

end

