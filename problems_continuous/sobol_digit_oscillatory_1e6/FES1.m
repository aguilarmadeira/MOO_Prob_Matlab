function varargout = FES1(varargin)
%FES1  FES1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 689.531     ]   (range: 689.531     )
%   x2   ∈ [0           , 439925      ]   (range: 439925      )
%   x3   ∈ [0           , 942109      ]   (range: 942109      )
%   x4   ∈ [0           , 192.715     ]   (range: 192.715     )
%   x5   ∈ [0           , 610449      ]   (range: 610449      )
%   x6   ∈ [0           , 360.601     ]   (range: 360.601     )
%   x7   ∈ [0           , 865.219     ]   (range: 865.219     )
%   x8   ∈ [0           , 116.068     ]   (range: 116.068     )
%   x9   ∈ [0           , 635222      ]   (range: 635222      )
%   x10  ∈ [0           , 385617      ]   (range: 385617      )
%
% Effective contrast ratio (max range / min range): 8116.890637199493
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = FES1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = FES1('bounds')  % Get bounds
%   info = FES1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [689.5310561065849;439925.1316157087;942109.0088980271;192.7149259537234;610448.9293028406;360.6005406499301;865.2193262851392;116.0677223591466;635221.5705218224;385617.080242917];
scale_factors = [689.5310561065849;439925.1316157087;942109.0088980271;192.7149259537234;610448.9293028406;360.6005406499301;865.2193262851392;116.0677223591466;635221.5705218224;385617.080242917];
contrast_ratio = 8116.890637199493;

if nargin == 0
    info.name = mfilename;
    info.problem = 'FES1';
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
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'FES1: No analytical PF. Ref: Huband et al. (2006).';
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
    error('Input x must have 10 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = FES1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to FES1_orig)
% -------------------------------------------------------------------------
function f = FES1_orig(x)
%###############################################################################
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example FES1, see the previous cited paper for the original reference.
%
%   In the above paper the number of variables was left undefined. 
%   We selected n=10 as default.
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
% - Number of variables: 10 (default)
% - Number of objectives: 2
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1]
%
%

M = 2; % Number of objectives (fixed)

% Check dimension
n = length(x);
if n ~= 10
    error('FES1 requires exactly 10 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
sum1 = 0;
sum2 = 0;
for i = 1:n
    sum1 = sum1 + abs(x(i) - exp((i/n)^2)/3)^0.5;
    sum2 = sum2 + (x(i) - 0.5*cos(10*pi*i/n) - 0.5)^2;
end

f(1) = sum1;
f(2) = sum2;

end

