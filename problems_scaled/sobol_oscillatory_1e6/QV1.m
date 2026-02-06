function varargout = QV1(varargin)
%QV1  QV1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 149289      ]   (range: 149289      )
%   x2   ∈ [0           , 648.789     ]   (range: 648.789     )
%   x3   ∈ [0           , 399039      ]   (range: 399039      )
%   x4   ∈ [0           , 898.539     ]   (range: 898.539     )
%   x5   ∈ [0           , 86851.6     ]   (range: 86851.6     )
%   x6   ∈ [0           , 586.352     ]   (range: 586.352     )
%   x7   ∈ [0           , 336602      ]   (range: 336602      )
%   x8   ∈ [0           , 836.102     ]   (range: 836.102     )
%   x9   ∈ [0           , 211727      ]   (range: 211727      )
%   x10  ∈ [0           , 711.227     ]   (range: 711.227     )
%
% Effective contrast ratio (max range / min range): 680.5457476716454
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = QV1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = QV1('bounds')  % Get bounds
%   info = QV1()          % Get complete problem information
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
ub_work = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625;211726.5625;711.2265625];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625;211726.5625;711.2265625];
contrast_ratio = 680.5457476716454;

if nargin == 0
    info.name = mfilename;
    info.problem = 'QV1';
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
    info.pareto_note = 'QV1: Quagliarella-Vicini. No closed-form PF. Ref: Huband et al. (2006).';
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
    error('Input x must have 10 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = QV1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to QV1_orig)
% -------------------------------------------------------------------------
function f = QV1_orig(x)
% QV1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example QV1, see the previous cited paper for the original reference.
%
%   In the original reference the number of variables was n=16. 
%   We selected n=10 as default.
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
n = 10;

% Função objetivo 1
sum1 = 0;
for i = 1:n
    sum1 = sum1 + (x(i)^2 - 10*cos(2*pi*x(i)) + 10);
end
f1 = (sum1/n)^0.25;

% Função objetivo 2
sum2 = 0;
for i = 1:n
    sum2 = sum2 + ((x(i)-1.5)^2 - 10*cos(2*pi*(x(i)-1.5)) + 10);
end
f2 = (sum2/n)^0.25;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

