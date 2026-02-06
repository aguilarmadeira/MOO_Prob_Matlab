function varargout = DTLZ6(varargin)
%DTLZ6  DTLZ6 (n=22, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 2880.99     ]   (range: 2880.99     )
%   x2   ∈ [0           , 5567.61     ]   (range: 5567.61     )
%   x3   ∈ [0           , 607.697     ]   (range: 607.697     )
%   x4   ∈ [0           , 7.83968e+07 ]   (range: 7.83968e+07 )
%   x5   ∈ [0           , 4690        ]   (range: 4690        )
%   x6   ∈ [0           , 7.46915e+07 ]   (range: 7.46915e+07 )
%   x7   ∈ [0           , 2431.28     ]   (range: 2431.28     )
%   x8   ∈ [0           , 9726.65     ]   (range: 9726.65     )
%   x9   ∈ [0           , 3.24166e+07 ]   (range: 3.24166e+07 )
%   x10  ∈ [0           , 5.85015e+07 ]   (range: 5.85015e+07 )
%   x11  ∈ [0           , 813.35      ]   (range: 813.35      )
%   x12  ∈ [0           , 8279.68     ]   (range: 8279.68     )
%   x13  ∈ [0           , 4.3306e+07  ]   (range: 4.3306e+07  )
%   x14  ∈ [0           , 6636.33     ]   (range: 6636.33     )
%   x15  ∈ [0           , 1599.52     ]   (range: 1599.52     )
%   x16  ∈ [0           , 9368.64     ]   (range: 9368.64     )
%   x17  ∈ [0           , 2663.95     ]   (range: 2663.95     )
%   x18  ∈ [0           , 5120.94     ]   (range: 5120.94     )
%   x19  ∈ [0           , 83.0712     ]   (range: 83.0712     )
%   x20  ∈ [0           , 7700.6      ]   (range: 7700.6      )
%   x21  ∈ [0           , 4.59489e+07 ]   (range: 4.59489e+07 )
%   x22  ∈ [0           , 6.97871e+07 ]   (range: 6.97871e+07 )
%
% Effective contrast ratio (max range / min range): 943730.6042987953
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
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
ub_work = [2880.991218615326;5567.608709144421;607.6967794423597;78396818.21990398;4690.000279175038;74691518.8127165;2431.276675627858;9726.654457062748;32416576.68531237;58501495.86998246;813.3501803874217;8279.678400891562;43306037.51667823;6636.326047268572;1599.51572664661;9368.635100041327;2663.952048179768;5120.938157089763;83.07118351656496;7700.597696008003;45948854.17749239;69787117.55387615];
scale_factors = [2880.991218615326;5567.608709144421;607.6967794423597;78396818.21990398;4690.000279175038;74691518.8127165;2431.276675627858;9726.654457062748;32416576.68531237;58501495.86998246;813.3501803874217;8279.678400891562;43306037.51667823;6636.326047268572;1599.51572664661;9368.635100041327;2663.952048179768;5120.938157089763;83.07118351656496;7700.597696008003;45948854.17749239;69787117.55387615];
contrast_ratio = 943730.6042987953;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ6';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 100000000;
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
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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

