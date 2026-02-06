function varargout = DTLZ4(varargin)
%DTLZ4  DTLZ4 (n=12, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 5193.64     ]   (range: 5193.64     )
%   x2   ∈ [0           , 619.208     ]   (range: 619.208     )
%   x3   ∈ [0           , 7.61344e+07 ]   (range: 7.61344e+07 )
%   x4   ∈ [0           , 2882.78     ]   (range: 2882.78     )
%   x5   ∈ [0           , 6.90379e+07 ]   (range: 6.90379e+07 )
%   x6   ∈ [0           , 2.32874e+07 ]   (range: 2.32874e+07 )
%   x7   ∈ [0           , 9.63606e+07 ]   (range: 9.63606e+07 )
%   x8   ∈ [0           , 4.90479e+07 ]   (range: 4.90479e+07 )
%   x9   ∈ [0           , 5766.44     ]   (range: 5766.44     )
%   x10  ∈ [0           , 9.67428e+06 ]   (range: 9.67428e+06 )
%   x11  ∈ [0           , 8.34127e+07 ]   (range: 8.34127e+07 )
%   x12  ∈ [0           , 3.69848e+07 ]   (range: 3.69848e+07 )
%
% Effective contrast ratio (max range / min range): 155619.132797148
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (sphere)
%   PF expression: sum(f_i^2) = 1, f_i >= 0 (same as DTLZ2, biased density)
%   Ideal point: [0 0 0]
%   Nadir point: [1 1 1]
%   Pareto set: x_i = 0.5 for i = m..n
%
% USAGE:
%   F = DTLZ4(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ4('bounds')  % Get bounds
%   info = DTLZ4()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 12;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [5193.63908303623;619.2082388857376;76134446.83354467;2882.78183069989;69037905.48346138;23287434.57592085;96360649.15624774;49047857.81427342;5766.443429338045;9674280.285859652;83412651.90088123;36984817.97858316];
scale_factors = [5193.63908303623;619.2082388857376;76134446.83354467;2882.78183069989;69037905.48346138;23287434.57592085;96360649.15624774;49047857.81427342;5766.443429338045;9674280.285859652;83412651.90088123;36984817.97858316];
contrast_ratio = 155619.132797148;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ4';
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
    info.pf_type = 'sphere';
    info.pf_expression = 'sum(f_i^2) = 1, f_i >= 0 (same as DTLZ2, biased density)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n';
    info.ideal_point = [0;0;0];
    info.nadir_point = [1;1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1;1.1];
    info.pareto_note = 'DTLZ4 (m=3): Same PF as DTLZ2; biased search. Ref: Deb et al. (2002).';
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
    error('Input x must have 12 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = DTLZ4_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ4_orig)
% -------------------------------------------------------------------------
function f = DTLZ4_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ4.
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
    error('DTLZ4 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Parameter
alpha = 100;

% Initialize objectives
f = zeros(M, 1);

% Transform variables
y = x.^alpha;

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + (y(i) - 0.5)^2;
end

% Calculate objectives
% f1
prod_term = 1;
for j = 1:(M-1)
    prod_term = prod_term * cos(0.5*pi*y(j));
end
f(1) = (1 + gx) * prod_term;

% f2 to fM
for i = 2:M
    prod_term = 1;
    for j = 1:(M-i)
        prod_term = prod_term * cos(0.5*pi*y(j));
    end
    f(i) = (1 + gx) * prod_term * sin(0.5*pi*y(M-i+1));
end

end

