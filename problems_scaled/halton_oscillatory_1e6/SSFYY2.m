function varargout = SSFYY2(varargin)
%SSFYY2  SSFYY2 (n=1, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 500500      ]   (range: 500500      )
%
% Effective contrast ratio (max range / min range): 1
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f1 = x + 10, f2 = 1/x + 10 for x > 0
%
% USAGE:
%   F = SSFYY2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = SSFYY2('bounds')  % Get bounds
%   info = SSFYY2()          % Get complete problem information
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
ub_work = 500500;
scale_factors = 500500;
contrast_ratio = 1;

if nargin == 0
    info.name = mfilename;
    info.problem = 'SSFYY2';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'halton_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'convex';
    info.pf_expression = 'f1 = x + 10, f2 = 1/x + 10 for x > 0';
    info.pareto_set_known = true;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'SSFYY2: Simple hyperbolic PF. Ideal/nadir depend on domain bounds. Ref: Huband et al. (2006).';
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
F = SSFYY2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to SSFYY2_orig)
% -------------------------------------------------------------------------
function f = SSFYY2_orig(x)
% SSFYY2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example SSFYY2, see the previous cited paper for the original reference.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
pi = 4*atan(1);

% Função objetivo 1
f1 = 10 + x^2 - 10*cos(x*pi/2);

% Função objetivo 2
f2 = (x-4)^2;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

