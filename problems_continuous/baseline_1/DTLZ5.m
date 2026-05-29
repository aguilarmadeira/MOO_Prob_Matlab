function varargout = DTLZ5(varargin)
%DTLZ5  DTLZ5 (n=12, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (BASELINE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 1           ]   (range: 1           )
%   x3   ∈ [0           , 1           ]   (range: 1           )
%   x4   ∈ [0           , 1           ]   (range: 1           )
%   x5   ∈ [0           , 1           ]   (range: 1           )
%   x6   ∈ [0           , 1           ]   (range: 1           )
%   x7   ∈ [0           , 1           ]   (range: 1           )
%   x8   ∈ [0           , 1           ]   (range: 1           )
%   x9   ∈ [0           , 1           ]   (range: 1           )
%   x10  ∈ [0           , 1           ]   (range: 1           )
%   x11  ∈ [0           , 1           ]   (range: 1           )
%   x12  ∈ [0           , 1           ]   (range: 1           )
%
% Effective contrast ratio (max range / min range): 1
%
% Pareto information:
%   Pareto front: KNOWN (degenerate)
%   PF expression: Degenerate curve on unit sphere (1D manifold in 3D obj space)
%   Ideal point: [0 0 0]
%   Nadir point: [1 1 1]
%   Pareto set: x_i = 0.5 for i = m..n; theta_i = pi/4 for i = 2..m-1
%
% USAGE:
%   F = DTLZ5(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = DTLZ5('bounds')  % Get bounds
%   info = DTLZ5()          % Get complete problem information
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
ub_work = [1;1;1;1;1;1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ5';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'baseline';
    info.kappa = 1;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'degenerate';
    info.pf_expression = 'Degenerate curve on unit sphere (1D manifold in 3D obj space)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n; theta_i = pi/4 for i = 2..m-1';
    info.ideal_point = [0;0;0];
    info.nadir_point = [1;1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1;1.1];
    info.pareto_note = 'DTLZ5 (m=3): Degenerate PF (curve on sphere). Ref: Deb et al. (2002).';
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
F = DTLZ5_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ5_orig)
% -------------------------------------------------------------------------
function f = DTLZ5_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ5.
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
% - Number of variables: n >= M (default n = 12 for M = 3)
% - Number of objectives: M >= 2 (default M = 3)
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1], x11 in [0,1], x12 in [0,1]
%
%


% Fixed parameters for DTLZ5
M = 3;  % Number of objectives (fixed)
n = length(x);

% Check minimum dimension
if n < M
    error('DTLZ5 requires n >= M, but n = %d and M = %d', n, M);
end

% Calculate k (number of variables in g function)
k = n - M + 1;

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Calculate g(x)
gx = 0;
for i = M:n
    gx = gx + x(i)^0.1;
end

% Calculate theta
theta = zeros(n, 1);
for i = 2:n
    theta(i) = (pi/2) * (1 + 2*gx*x(i)) / (2*(1 + gx));
end

% Calculate objectives
if M >= 2
    % f1
    prod_term = 1;
    for j = 2:(M-1)
        prod_term = prod_term * cos(theta(j));
    end
    f(1) = (1 + gx) * cos(0.5*pi*x(1)) * prod_term;
    
    % f2 to f(M-1)
    for i = 2:(M-1)
        prod_term = 1;
        for j = 2:(M-i)
            prod_term = prod_term * cos(theta(j));
        end
        f(i) = (1 + gx) * cos(0.5*pi*x(1)) * prod_term * sin(theta(M-i+1));
    end
    
    % fM
    f(M) = (1 + gx) * sin(0.5*pi*x(1));
end

end

