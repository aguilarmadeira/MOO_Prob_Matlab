function varargout = MOP1(varargin)
%MOP1  MOP1 (n=1, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SPATIAL_THERMAL HETEROGENEITY):
%
%   x1   ∈ [0           , 300         ]   (range: 300         )
%
% Effective contrast ratio (max range / min range): 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f1 = x^2, f2 = (x-2)^2; PF parametric via x in [0,2]
%   Ideal point: [0 0]
%   Nadir point: [4 4]
%   Pareto set: x in [0, 2]
%
% USAGE:
%   F = MOP1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = MOP1('bounds')  % Get bounds
%   info = MOP1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 1;
mloc = 2;
lb_orig = 0;
ub_orig = 1;
lb_work = 0;
ub_work = 300;
scale_factors = 300;
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP1';
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
    info.pf_type = 'convex';
    info.pf_expression = 'f1 = x^2, f2 = (x-2)^2; PF parametric via x in [0,2]';
    info.pareto_set_known = true;
    info.ps_expression = 'x in [0, 2]';
    info.ideal_point = [0;0];
    info.nadir_point = [4;4];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [4.4;4.4];
    info.pareto_note = 'MOP1: Same structure as Sch1. Ref: Huband et al. (2006).';
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
    error('Input x must have 1 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP1_orig)
% -------------------------------------------------------------------------
function f = MOP1_orig(x)
% MOP1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP1, Van Valedhuizen's test suit.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
f1 = x^2;

% Função objetivo 2
f2 = (x-2)^2;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

