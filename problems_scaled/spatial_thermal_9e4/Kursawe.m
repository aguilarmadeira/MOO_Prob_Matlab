function varargout = Kursawe(varargin)
%KURSAWE  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: Kursawe
% Dimension: n = 3, objectives m = 2
% Strategy: spatial_thermal (kappa = 90000)
% Effective contrast: 300
%
% API:
%   info = Kursawe();
%   [lb,ub] = Kursawe('bounds');
%   F = Kursawe(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = Kursawe_orig(x_orig)

nloc = 3;
mloc = 2;
lb_orig = [-5;-5;-5];
ub_orig = [5;5;5];
lb_work = [-5;-1500;-1500];
ub_work = [5;1500;1500];
scale_factors = [1;300;300];
contrast_ratio = 300;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Kursawe';
    info.n = nloc; info.m = mloc;
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
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
    error('Input x must have 3 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = Kursawe_orig(x_orig);
varargout{1} = F(:);
end

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Kursawe_orig)
% -------------------------------------------------------------------------
function f = Kursawe_orig(x)
%###############################################################################
%
%   As described by F. Kursawe in "A variant of evolution strategies for
%   vector optimization", in H. P. Schwefel and R. Männer, editors, Parallel 
%   Problem Solving from Nature, 1st Workshop, PPSN I, volume 496 of Lecture 
%   Notes in Computer Science, pages 193-197, Berlin, Germany, Oct 1991, 
%   Springer-Verlag.
%
%   In the above paper the variables bounds were not set.
%   We considered -5.0 <= x[i] <= 5.0, i=1,2,3.
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
% - Number of variables: 3
% - Number of objectives: 2
% - Bounds: x in [-5.0, 5.0] x [-5.0, 5.0] x [-5.0, 5.0]
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 3
    error('Kursawe requires exactly 3 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = 0;
for i = 1:n-1
    f(1) = f(1) - 10*exp(-0.2*sqrt(x(i)^2 + x(i+1)^2));
end

f(2) = 0;
for i = 1:n
    f(2) = f(2) + abs(x(i))^0.8 + 5*sin(x(i))^3;
end

end

