function varargout = CL1(varargin)
%CL1  CL1 (n=4, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [149289      , 447867      ]   (range: 298578      )
%   x2   ∈ [917.526     , 1946.37     ]   (range: 1028.84     )
%   x3   ∈ [564326      , 1.19712e+06 ]   (range: 632791      )
%   x4   ∈ [898.539     , 2695.62     ]   (range: 1797.08     )
%
% Effective contrast ratio (max range / min range): 615.0520801974833
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = CL1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = CL1('bounds')  % Get bounds
%   info = CL1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 4;
mloc = 2;
lb_orig = [1;1.414213562373095;1.414213562373095;1];
ub_orig = [3;3;3;3];
lb_work = [149289.0625;917.5262913068256;564326.4541041451;898.5390625];
ub_work = [447867.1875;1946.3671875;1197117.1875;2695.6171875];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625];
contrast_ratio = 615.0520801974833;

if nargin == 0
    info.name = mfilename;
    info.problem = 'CL1';
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
    info.pareto_note = 'CL1: Constrained problem, no analytical PF. Ref: Cheng & Li (1999).';
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
    error('Input x must have 4 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = CL1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to CL1_orig)
% -------------------------------------------------------------------------
function f = CL1_orig(x)
%###############################################################################
%
%   As described by F.Y. Cheng and X.S. Li, "Generalized center method for
%   multiobjective engineering optimization", Engineering Optimization,31:5,
%   641-661, 1999.
%
%   Example 2, four bar truss.
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
% - Number of variables: 4 (fixed)
% - Number of objectives: 2 (fixed)
%   Bounds: x1 in [1,3], x2 in [1.41421356237,3], x3 in [1.41421356237,3], x4 in [1,3]
%
%

% Check dimension
n = length(x);
if n ~= 4
    error('CL1 requires exactly 4 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Parameters
F = 10;
E = 2e5;
L = 200;
sigma = 10;

% Objective functions
f = zeros(2, 1);
f(1) = L * (2*x(1) + sqrt(2)*x(2) + sqrt(x(3)) + x(4));
f(2) = F*L/E * (2/x(1) + (2*sqrt(2))/x(2) - (2*sqrt(2))/x(3) + 2/x(4));

end

