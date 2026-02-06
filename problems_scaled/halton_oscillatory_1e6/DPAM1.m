function varargout = DPAM1(varargin)
%DPAM1  DPAM1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 500500      ]   (range: 500500      )
%   x2   ∈ [0           , 250.75      ]   (range: 250.75      )
%   x3   ∈ [0           , 750250      ]   (range: 750250      )
%   x4   ∈ [0           , 125.875     ]   (range: 125.875     )
%   x5   ∈ [0           , 625375      ]   (range: 625375      )
%   x6   ∈ [0           , 375.625     ]   (range: 375.625     )
%   x7   ∈ [0           , 875125      ]   (range: 875125      )
%   x8   ∈ [0           , 63.4375     ]   (range: 63.4375     )
%   x9   ∈ [0           , 562938      ]   (range: 562938      )
%   x10  ∈ [0           , 313.188     ]   (range: 313.188     )
%
% Effective contrast ratio (max range / min range): 13795.07389162562
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
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
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875];
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
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
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
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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

