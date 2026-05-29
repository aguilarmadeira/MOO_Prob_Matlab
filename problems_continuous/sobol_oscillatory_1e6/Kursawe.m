function varargout = Kursawe(varargin)
%KURSAWE  Kursawe (n=3, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-746445     , 746445      ]   (range: 1.49289e+06 )
%   x2   ∈ [-3243.95    , 3243.95     ]   (range: 6487.89     )
%   x3   ∈ [-1.9952e+06 , 1.9952e+06  ]   (range: 3.99039e+06 )
%
% Effective contrast ratio (max range / min range): 615.0520801974833
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = Kursawe(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = Kursawe('bounds')  % Get bounds
%   info = Kursawe()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 3;
mloc = 2;
lb_orig = [-5;-5;-5];
ub_orig = [5;5;5];
lb_work = [-746445.3125;-3243.9453125;-1995195.3125];
ub_work = [746445.3125;3243.9453125;1995195.3125];
scale_factors = [149289.0625;648.7890625;399039.0625];
contrast_ratio = 615.0520801974833;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Kursawe';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'Kursawe: Disconnected PF, no closed-form known. Ref: Kursawe (1990).';
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
    error('Input x must have 3 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = Kursawe_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

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
%   Bounds: x1 in [-5,5], x2 in [-5,5], x3 in [-5,5]
%
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

