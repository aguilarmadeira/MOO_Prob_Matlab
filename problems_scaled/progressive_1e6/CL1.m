function varargout = CL1(varargin)
%CL1  CL1 (n=4, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (PROGRESSIVE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 10          ]   (range: 10          )
%   x3   ∈ [0           , 100         ]   (range: 100         )
%   x4   ∈ [0           , 1000        ]   (range: 1000        )
%
% Effective contrast ratio (max range / min range): 1000
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
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
lb_orig = [0;0;0;0];
ub_orig = [1;1;1;1];
lb_work = [0;0;0;0];
ub_work = [1;10;100;1000];
scale_factors = [1;10;100;1000];
contrast_ratio = 1000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'CL1';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'progressive';
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
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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

