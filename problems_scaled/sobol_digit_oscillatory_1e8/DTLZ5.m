function varargout = DTLZ5(varargin)
%DTLZ5  DTLZ5 (n=12, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 9554.22     ]   (range: 9554.22     )
%   x2   ∈ [0           , 1.89376e+07 ]   (range: 1.89376e+07 )
%   x3   ∈ [0           , 5755.99     ]   (range: 5755.99     )
%   x4   ∈ [0           , 3.42656e+07 ]   (range: 3.42656e+07 )
%   x5   ∈ [0           , 8.5861e+07  ]   (range: 8.5861e+07  )
%   x6   ∈ [0           , 1.21903e+07 ]   (range: 1.21903e+07 )
%   x7   ∈ [0           , 7346.07     ]   (range: 7346.07     )
%   x8   ∈ [0           , 4.72447e+07 ]   (range: 4.72447e+07 )
%   x9   ∈ [0           , 8.93463e+07 ]   (range: 8.93463e+07 )
%   x10  ∈ [0           , 1.26475e+07 ]   (range: 1.26475e+07 )
%   x11  ∈ [0           , 5136.11     ]   (range: 5136.11     )
%   x12  ∈ [0           , 2.79787e+07 ]   (range: 2.79787e+07 )
%
% Effective contrast ratio (max range / min range): 17395.73109990797
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
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
ub_work = [9554.217003866015;18937582.30974078;5755.985443024179;34265622.23141751;85860996.76227817;12190303.17503868;7346.068102579959;47244700.90293269;89346347.26516595;12647528.02665699;5136.107631925778;27978715.49137587];
scale_factors = [9554.217003866015;18937582.30974078;5755.985443024179;34265622.23141751;85860996.76227817;12190303.17503868;7346.068102579959;47244700.90293269;89346347.26516595;12647528.02665699;5136.107631925778;27978715.49137587];
contrast_ratio = 17395.73109990797;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ5';
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
    info.pf_expression = 'Degenerate curve on unit sphere (1D manifold in 3D obj space)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i = 0.5 for i = m..n; theta_i = pi/4 for i = 2..m-1';
    info.ideal_point = [0;0;0];
    info.nadir_point = [1;1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1;1.1];
    info.pareto_note = 'DTLZ5 (m=3): Degenerate PF (curve on sphere). Ref: Deb et al. (2002).';
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

