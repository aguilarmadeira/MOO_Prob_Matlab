function varargout = Fonseca(varargin)
%FONSECA  Fonseca (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SPATIAL_THERMAL HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 300         ]   (range: 300         )
%
% Effective contrast ratio (max range / min range): 300
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (concave)
%   PF expression: Concave PF in [0,1]^2, parametric via x_1=...=x_n in [-1/sqrt(n), 1/sqrt(n)]
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x_1 = x_2 = ... = x_n in [-1/sqrt(n), 1/sqrt(n)]
%
% USAGE:
%   F = Fonseca(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = Fonseca('bounds')  % Get bounds
%   info = Fonseca()          % Get complete problem information
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
ub_work = [1;300];
scale_factors = [1;300];
contrast_ratio = 300;

if nargin == 0
    info.name = mfilename;
    info.problem = 'Fonseca';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'spatial_thermal';
    info.kappa = 90000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'concave';
    info.pf_expression = 'Concave PF in [0,1]^2, parametric via x_1=...=x_n in [-1/sqrt(n), 1/sqrt(n)]';
    info.pareto_set_known = true;
    info.ps_expression = 'x_1 = x_2 = ... = x_n in [-1/sqrt(n), 1/sqrt(n)]';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'Fonseca: Concave PF. Ref: Fonseca & Fleming (1998).';
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
F = Fonseca_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to Fonseca_orig)
% -------------------------------------------------------------------------
function f = Fonseca_orig(x)
%###############################################################################
%
%   As described by C.M. Fonseca and P.J. Fleming in "Multiobjective
%   Optimization and Multiple Constraint Handling with Evolutionary
%   Algorithms—Part I: A Unified Formulation", in IEEE Transactions 
%   on Systems, Man, and Cybernetics—Part A: Systems and Humans, 
%   vol. 28, no. 1, January 1998.
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
    error('Fonseca requires exactly 2 variables, %d provided', n);
end

% Ensure x is a column vector
x = x(:);

% Initialize objectives
f = zeros(M, 1);

% Objective functions
f(1) = 1 - exp(-(x(1)-1)^2 - (x(2)+1)^2);
f(2) = 1 - exp(-(x(1)+1)^2 - (x(2)-1)^2);

end

