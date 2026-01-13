function varargout = I3(varargin)
%I3  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: I3
% Dimension: n = 8, objectives m = 3
% Strategy: baseline (kappa = 1)
% Effective contrast: 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = I3();
%   [lb,ub] = I3('bounds');
%   F = I3(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = I3_orig(x_orig)

nloc = 8;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0];
ub_work = [1;1;1;1;1;1;1;1];
scale_factors = [1;1;1;1;1;1;1;1];
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'I3';
    info.n = nloc; info.m = mloc;
    info.strategy = 'baseline';
    info.kappa = 1;
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
    error('Input x must have 8 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = I3_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to I3_orig)
% -------------------------------------------------------------------------
function f = I3_orig(z)
%###############################################################################
%
%   As described by Huband et al. in "A Scalable Multi-objective Test Problem
%   Toolkit", in C. A. Coello Coello et al. (Eds.): EMO 2005, LNCS 3410, 
%   pp. 280–295, 2005, Springer-Verlag Berlin Heidelberg 2005.
%
%   Example I3.
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
% - Number of variables: 8 (k=4, l=4)
% - Number of objectives: 3
% - Bounds: z in [0.0, 1.0]^8
%


% Parameters
M = 3; % Number of objectives (fixed)
k = 4;
l = 4;
n = k + l;

% Check dimension
if length(z) ~= n
    error('I3 requires exactly %d variables, %d provided', n, length(z));
end

% Ensure z is a column vector
z = z(:);

% Constants
pi2 = pi/2;
S = ones(M, 1);
A = ones(M-1, 1);

% Transform z into [0,1] set
zmax = ones(n, 1);
y = z ./ zmax;

% First level mapping
w = ones(n, 1);
AA = 0.98/49.98;
BB = 0.02;
CC = 50;
t1 = zeros(n, 1);

% Calculate r_sum and t1
t1(1) = y(1);
for i = 2:n
    r_sum = sum(w(1:i-1) .* y(1:i-1)) / sum(w(1:i-1));
    t1(i) = y(i)^(BB + (CC-BB) * (AA - (1-2*r_sum) * abs(floor(0.5-r_sum) + AA)));
end

% Second level mapping
t2 = zeros(n, 1);
for i = 1:n
    if i <= k
        t2(i) = t1(i);
    else
        t2(i) = abs(t1(i) - 0.35) / abs(floor(0.35 - t1(i)) + 0.35);
    end
end

% Third level mapping
t3 = zeros(M, 1);
for i = 1:M
    if i <= M-1
        j_start = (i-1)*k/(M-1) + 1;
        j_end = i*k/(M-1);
        indices = round(j_start):round(j_end);
        t3(i) = sum(w(indices) .* t2(indices)) / sum(w(indices));
    else
        indices = (k+1):n;
        t3(i) = sum(w(indices) .* t2(indices)) / sum(w(indices));
    end
end

% Define objective function variables
x = zeros(M, 1);
for i = 1:M
    if i <= M-1
        x(i) = max(t3(M), A(i)) * (t3(i) - 0.5) + 0.5;
    else
        x(i) = t3(M);
    end
end

% Define shape function h
h = zeros(M, 1);
for m = 1:M
    if m == 1
        h(m) = 1;
        for i = 1:M-1
            h(m) = h(m) * sin(x(i) * pi2);
        end
    elseif m <= M-1
        h(m) = 1;
        for i = 1:M-m
            h(m) = h(m) * sin(x(i) * pi2);
        end
        h(m) = h(m) * cos(x(M-m+1) * pi2);
    else
        h(m) = cos(x(1) * pi2);
    end
end

% Calculate objectives
f = zeros(M, 1);
for m = 1:M
    f(m) = x(M) + S(m) * h(m);
end

end

