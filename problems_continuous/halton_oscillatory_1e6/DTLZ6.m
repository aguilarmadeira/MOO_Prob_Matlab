function varargout = DTLZ6(varargin)
%DTLZ6  DTLZ6 (n=22, m=3) test problem (heterogeneous WORK-space wrapper).
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
%   x11  ∈ [0           , 812688      ]   (range: 812688      )
%   x12  ∈ [0           , 188.312     ]   (range: 188.312     )
%   x13  ∈ [0           , 687812      ]   (range: 687812      )
%   x14  ∈ [0           , 438.062     ]   (range: 438.062     )
%   x15  ∈ [0           , 937562      ]   (range: 937562      )
%   x16  ∈ [0           , 32.2188     ]   (range: 32.2188     )
%   x17  ∈ [0           , 531719      ]   (range: 531719      )
%   x18  ∈ [0           , 281.969     ]   (range: 281.969     )
%   x19  ∈ [0           , 781469      ]   (range: 781469      )
%   x20  ∈ [0           , 157.094     ]   (range: 157.094     )
%   x21  ∈ [0           , 656594      ]   (range: 656594      )
%   x22  ∈ [0           , 406.844     ]   (range: 406.844     )
%
% Effective contrast ratio (max range / min range): 29099.90300678953
%
% Pareto information:
%   Pareto front: KNOWN (degenerate)
%   PF expression: Same geometry as DTLZ5 PF (degenerate curve)
%   Ideal point: [0 0 0]
%   Nadir point: [1 1 1]
%   Pareto set: x_i = 0 for i = m..n; same angular structure as DTLZ5
%
% USAGE:
%   F = DTLZ6(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ6('bounds')  % Get bounds
%   info = DTLZ6()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 22;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875;812687.5;188.3125;687812.5;438.0625;937562.5;32.21875;531718.75;281.96875;781468.75;157.09375;656593.75;406.84375];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875;812687.5;188.3125;687812.5;438.0625;937562.5;32.21875;531718.75;281.96875;781468.75;157.09375;656593.75;406.84375];
contrast_ratio = 29099.90300678953;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ6';
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
    info.pareto_front_known = true;
    info.pf_type = 'degenerate';
    info.pf_expression = 'Same geometry as DTLZ5 PF (degenerate curve)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0 for i = m..n; same angular structure as DTLZ5';
    info.ideal_point = [0;0;0];
    info.nadir_point = [1;1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1;1.1];
    info.pareto_note = 'DTLZ6 (m=3): Same PF geometry as DTLZ5; biased distance. Ref: Deb et al. (2002).';
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
    error('Input x must have 22 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ6_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ6_orig)
% -------------------------------------------------------------------------
function f = DTLZ6_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ6.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. CustÃ³dio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
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
% - Number of variables: n >= M (default n = 22 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1], x11 in [0,1], x12 in [0,1], x13 in [0,1], x14 in [0,1], x15 in [0,1], x16 in [0,1], x17 in [0,1], x18 in [0,1], x19 in [0,1], x20 in [0,1], x21 in [0,1], x22 in [0,1]
%
%


% Fixed parameters for DTLZ6
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ6 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
sum_term = 0;
for i = M:n
    sum_term = sum_term + x(i);
end
gx = 1 + (9/k) * sum_term;

% Calculate objectives
% f1 to f(M-1)
for i = 1:(M-1)
    f(i) = x(i);
end

% fM
sum_term = 0;
for i = 1:(M-1)
    sum_term = sum_term + (x(i)/(1 + gx)) * (1 + sin(3*pi*x(i)));
end
f(M) = (1 + gx) * (M - sum_term);

end

