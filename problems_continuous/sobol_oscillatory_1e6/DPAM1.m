function varargout = DPAM1(varargin)
%DPAM1  DPAM1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-44786.7    , 44786.7     ]   (range: 89573.4     )
%   x2   ∈ [-194.637    , 194.637     ]   (range: 389.273     )
%   x3   ∈ [-119712     , 119712      ]   (range: 239423      )
%   x4   ∈ [-269.562    , 269.562     ]   (range: 539.123     )
%   x5   ∈ [-26055.5    , 26055.5     ]   (range: 52110.9     )
%   x6   ∈ [-175.905    , 175.905     ]   (range: 351.811     )
%   x7   ∈ [-100980     , 100980      ]   (range: 201961      )
%   x8   ∈ [-250.83     , 250.83      ]   (range: 501.661     )
%   x9   ∈ [-63518      , 63518       ]   (range: 127036      )
%   x10  ∈ [-213.368    , 213.368     ]   (range: 426.736     )
%
% Effective contrast ratio (max range / min range): 680.5457476716454
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
lb_work = [-44786.71875;-194.63671875;-119711.71875;-269.56171875;-26055.46875;-175.90546875;-100980.46875;-250.83046875;-63517.96875;-213.36796875];
ub_work = [44786.71875;194.63671875;119711.71875;269.56171875;26055.46875;175.90546875;100980.46875;250.83046875;63517.96875;213.36796875];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625;211726.5625;711.2265625];
contrast_ratio = 680.5457476716454;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DPAM1';
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

