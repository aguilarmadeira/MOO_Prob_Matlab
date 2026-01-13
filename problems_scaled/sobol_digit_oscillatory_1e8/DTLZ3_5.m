function varargout = DTLZ3_5(varargin)
%DTLZ3_5  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: DTLZ3_5
% Dimension: n = 12, objectives m = 5
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 26067.57960696918
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = DTLZ3_5();
%   [lb,ub] = DTLZ3_5('bounds');
%   F = DTLZ3_5(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = DTLZ3_5_orig(x_orig)

nloc = 12;
mloc = 5;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [8481.566717437641;3169.797764426665;63240170.52183197;16360422.12365675;9165.293291910741;38531244.32850724;5717.663873400142;10315765.24997647;8079.658294632632;27709989.18131928;7115.91050758505;2426.008531491151];
scale_factors = [8481.566717437641;3169.797764426665;63240170.52183197;16360422.12365675;9165.293291910741;38531244.32850724;5717.663873400142;10315765.24997647;8079.658294632632;27709989.18131928;7115.91050758505;2426.008531491151];
contrast_ratio = 26067.57960696918;

if nargin == 0
    info.name = mfilename;
    info.problem = 'DTLZ3_5';
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 100000000;
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
F = DTLZ3_5_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to DTLZ3_5_orig)
% -------------------------------------------------------------------------
function f = DTLZ3_5_orig(x)
%###############################################################################
%
%   As described by K. Deb, L. Thiele, M. Laumanns and E. Zitzler in "Scalable
%   Multi-Objective Optimization Test Problems", Congress on Evolutionary 
%   Computation (CEC'2002): 825-830, 2002.
%
%   Example DTLZ3 with M = 5 objectives.
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
% - Number of variables: n >= 5 (recommended n = 14, i.e., k = 10)
% - Number of objectives: M = 5 (fixed)
% - Bounds: x in [0.0, 1.0]^n
%

% Get dimension
n = length(x);

% Fixed parameters
M = 5;  % Number of objectives (fixed for DTLZ3_5)
k = n - M + 1;  % Calculate k from dimension

% Check minimum dimension
if n < M
    error('DTLZ3_5 requires n >= M, but n = %d and M = %d', n, M);
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

