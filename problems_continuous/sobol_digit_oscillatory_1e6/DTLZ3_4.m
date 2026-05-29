function varargout = DTLZ3_4(varargin)
%DTLZ3_4  DTLZ3_4 (n=12, m=4) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 121248      ]   (range: 121248      )
%   x2   ∈ [0           , 795.219     ]   (range: 795.219     )
%   x3   ∈ [0           , 498356      ]   (range: 498356      )
%   x4   ∈ [0           , 664.963     ]   (range: 664.963     )
%   x5   ∈ [0           , 141813      ]   (range: 141813      )
%   x6   ∈ [0           , 942501      ]   (range: 942501      )
%   x7   ∈ [0           , 273044      ]   (range: 273044      )
%   x8   ∈ [0           , 566366      ]   (range: 566366      )
%   x9   ∈ [0           , 59496.7     ]   (range: 59496.7     )
%   x10  ∈ [0           , 858222      ]   (range: 858222      )
%   x11  ∈ [0           , 435599      ]   (range: 435599      )
%   x12  ∈ [0           , 726958      ]   (range: 726958      )
%
% Effective contrast ratio (max range / min range): 1417.37423332089
%
% Pareto information:
%   Pareto front: KNOWN (sphere)
%   PF expression: sum(f_i^2) = 1, f_i >= 0 (4D unit sphere)
%   Ideal point: [0 0 0 0]
%   Nadir point: [1 1 1 1]
%   Pareto set: x_i = 0.5 for i = m..n
%
% USAGE:
%   F = DTLZ3_4(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ3_4('bounds')  % Get bounds
%   info = DTLZ3_4()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 12;
mloc = 4;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [121247.8448830628;795.2194520264248;498356.4017787502;664.9625997873073;141813.3109020637;942500.8550606006;273044.1260091501;566365.6962853922;59496.65290848105;858221.5735889539;435599.404236933;726958.3810375032];
scale_factors = [121247.8448830628;795.2194520264248;498356.4017787502;664.9625997873073;141813.3109020637;942500.8550606006;273044.1260091501;566365.6962853922;59496.65290848105;858221.5735889539;435599.404236933;726958.3810375032];
contrast_ratio = 1417.37423332089;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ3_4';
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
    info.pf_type = 'sphere';
    info.pf_expression = 'sum(f_i^2) = 1, f_i >= 0 (4D unit sphere)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n';
    info.ideal_point = [0;0;0;0];
    info.nadir_point = [1;1;1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1;1.1;1.1];
    info.pareto_note = 'DTLZ3_4 (m=4): Spherical PF, multimodal. Ref: Deb et al. (2002).';
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
    error('Input x must have 12 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ3_4_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ3_4_orig)
% -------------------------------------------------------------------------
function f = DTLZ3_4_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ3 with M = 4 objectives.
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
% - Number of variables: n >= 4 (recommended n = 13, i.e., k = 10)
% - Number of objectives: M = 4 (fixed)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1], x11 in [0,1], x12 in [0,1]
%
%

% Get dimension
n = length(x);

% Fixed parameters
M = 4;  % Number of objectives (fixed for DTLZ3_4)
k = n - M + 1;  % Calculate k from dimension

% Check minimum dimension
if n < M
    error('DTLZ3_4 requires n >= M, but n = %d and M = %d', n, M);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
sum_term = 0;
for i = M:n
    sum_term = sum_term + ((x(i)-0.5)^2 - cos(20*pi*(x(i)-0.5)));
end
gx = 100 * (k + sum_term);

% Calculate objectives
% f1
prod_term = 1;
for j = 1:(M-1)
    prod_term = prod_term * cos(0.5*pi*x(j));
end
f(1) = (1 + gx) * prod_term;

% f2 to fM
for i = 2:M
    prod_term = 1;
    for j = 1:(M-i)
        prod_term = prod_term * cos(0.5*pi*x(j));
    end
    f(i) = (1 + gx) * prod_term * sin(0.5*pi*x(M-i+1));
end

end

