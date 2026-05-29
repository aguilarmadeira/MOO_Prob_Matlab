function varargout = DPAM1(varargin)
%DPAM1  DPAM1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-150150     , 150150      ]   (range: 300300      )
%   x2   ∈ [-75.225     , 75.225      ]   (range: 150.45      )
%   x3   ∈ [-225075     , 225075      ]   (range: 450150      )
%   x4   ∈ [-37.7625    , 37.7625     ]   (range: 75.525      )
%   x5   ∈ [-187612     , 187612      ]   (range: 375225      )
%   x6   ∈ [-112.688    , 112.688     ]   (range: 225.375     )
%   x7   ∈ [-262538     , 262538      ]   (range: 525075      )
%   x8   ∈ [-19.0312    , 19.0312     ]   (range: 38.0625     )
%   x9   ∈ [-168881     , 168881      ]   (range: 337762      )
%   x10  ∈ [-93.9562    , 93.9562     ]   (range: 187.912     )
%
% Effective contrast ratio (max range / min range): 13795.07389162562
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = DPAM1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DPAM1('bounds')  % Get bounds
%   info = DPAM1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 2;
lb_orig = [-0.3;-0.3;-0.3;-0.3;-0.3;-0.3;-0.3;-0.3;-0.3;-0.3];
ub_orig = [0.3;0.3;0.3;0.3;0.3;0.3;0.3;0.3;0.3;0.3];
lb_work = [-150150;-75.22499999999999;-225075;-37.7625;-187612.5;-112.6875;-262537.5;-19.03125;-168881.25;-93.95625];
ub_work = [150150;75.22499999999999;225075;37.7625;187612.5;112.6875;262537.5;19.03125;168881.25;93.95625];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875];
contrast_ratio = 13795.07389162562;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DPAM1';
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
    info.pareto_note = 'DPAM1: No analytical PF known. Ref: Huband et al. (2006).';
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
F = DPAM1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DPAM1_orig)
% -------------------------------------------------------------------------
function f = DPAM1_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example DPAM1, see the previous cited paper for the original reference.
%
%   In the above paper/papers the number of variables
%   was left undefined. We selected n=10 as default.
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
% - Number of variables: 10 (fixed)
% - Number of objectives: 2 (fixed)
%   Bounds: x1 in [-0.3,0.3], x2 in [-0.3,0.3], x3 in [-0.3,0.3], x4 in [-0.3,0.3], x5 in [-0.3,0.3], x6 in [-0.3,0.3], x7 in [-0.3,0.3], x8 in [-0.3,0.3], x9 in [-0.3,0.3], x10 in [-0.3,0.3]
%
%

% Check dimension
n = length(x);
if n ~= 10
    error('DPAM1 requires exactly 10 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Define rotation matrix A (sparse, mostly identity)
A = eye(10);
A(1,1) = 0.968912;
A(1,3) = 0.247404;
A(3,1) = -0.247404;
A(3,3) = 0.968912;

% Transform variables
y = A * x;

% Calculate g(x)
sum_term = 0;
for i = 2:n
    sum_term = sum_term + (y(i)^2 - 10*cos(4*pi*y(i)));
end
gx = 1 + 10*(n-1) + sum_term;

% Objective functions
f = zeros(2, 1);
f(1) = y(1);
f(2) = gx * exp(-y(1)/gx);

end

