function varargout = Far1(varargin)
%FAR1  Far1 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 8476        ]   (range: 8476        )
%   x2   ∈ [0           , 8.00594e+06 ]   (range: 8.00594e+06 )
%
% Effective contrast ratio (max range / min range): 944.5418503941836
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = Far1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = Far1('bounds')  % Get bounds
%   info = Far1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [1;1];
lb_work = [0;0];
ub_work = [8476.000654904426;8005937.342525739];
scale_factors = [8476.000654904426;8005937.342525739];
contrast_ratio = 944.5418503941836;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Far1';
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
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'Far1: No analytical PF documented. Ref: Huband et al. (2006).';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = Far1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Far1_orig)
% -------------------------------------------------------------------------
function f = Far1_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example Far1, see the previous cited paper for the original reference.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 2
    error('Far1 requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = -2*exp(15*(-(x(1)-0.1)^2 - x(2)^2)) ...
       - exp(20*(-(x(1)-0.6)^2 - (x(2)-0.6)^2)) ...
       + exp(20*(-(x(1)+0.6)^2 - (x(2)-0.6)^2)) ...
       + exp(20*(-(x(1)-0.6)^2 - (x(2)+0.6)^2)) ...
       + exp(20*(-(x(1)+0.6)^2 - (x(2)+0.6)^2));

f(2) = 2*exp(20*(-x(1)^2 - x(2)^2)) ...
       + exp(20*(-(x(1)-0.4)^2 - (x(2)-0.6)^2)) ...
       - exp(20*(-(x(1)+0.5)^2 - (x(2)-0.7)^2)) ...
       - exp(20*(-(x(1)-0.5)^2 - (x(2)+0.7)^2)) ...
       + exp(20*(-(x(1)+0.4)^2 - (x(2)+0.8)^2));

end

