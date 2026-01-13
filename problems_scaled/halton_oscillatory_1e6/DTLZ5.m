function varargout = DTLZ5(varargin)
%DTLZ5  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DTLZ5
% Dimension: n = 12, objectives m = 3
% Strategy: halton_oscillatory (kappa = 1000000)
% Effective contrast: 13795.07389162562
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = DTLZ5();
%   [lb,ub] = DTLZ5('bounds');
%   F = DTLZ5(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DTLZ5_orig(x_orig)

nloc = 12;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875;812687.5;188.3125];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875;812687.5;188.3125];
contrast_ratio = 13795.07389162562;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ5';
    info.n = nloc; info.m = mloc;
    info.strategy = 'halton_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
    varargout{1} = info;
    return;
end

arg1 = varargin{1};
if ischar(arg1) && strcmpi(arg1,'bounds')
    varargout{1} = lb_work;
    if nargout >= 2, varargout{2} = ub_work; end
    return;
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
end

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
% - Bounds: x in [0.0, 1.0]^n
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

