function varargout = ZDT3(varargin)
%ZDT3  ZDT3 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
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
%   x11  ∈ [0           , 461477      ]   (range: 461477      )
%   x12  ∈ [0           , 960.977     ]   (range: 960.977     )
%   x13  ∈ [0           , 55632.8     ]   (range: 55632.8     )
%   x14  ∈ [0           , 555.133     ]   (range: 555.133     )
%   x15  ∈ [0           , 305383      ]   (range: 305383      )
%   x16  ∈ [0           , 804.883     ]   (range: 804.883     )
%   x17  ∈ [0           , 180508      ]   (range: 180508      )
%   x18  ∈ [0           , 680.008     ]   (range: 680.008     )
%   x19  ∈ [0           , 430258      ]   (range: 430258      )
%   x20  ∈ [0           , 929.758     ]   (range: 929.758     )
%   x21  ∈ [0           , 118070      ]   (range: 118070      )
%   x22  ∈ [0           , 617.57      ]   (range: 617.57      )
%   x23  ∈ [0           , 367820      ]   (range: 367820      )
%   x24  ∈ [0           , 867.32      ]   (range: 867.32      )
%   x25  ∈ [0           , 242945      ]   (range: 242945      )
%   x26  ∈ [0           , 742.445     ]   (range: 742.445     )
%   x27  ∈ [0           , 492695      ]   (range: 492695      )
%   x28  ∈ [0           , 992.195     ]   (range: 992.195     )
%   x29  ∈ [0           , 4902.34     ]   (range: 4902.34     )
%   x30  ∈ [0           , 504.402     ]   (range: 504.402     )
%
% Effective contrast ratio (max range / min range): 976.7902917282985
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (disconnected)
%   PF expression: f2 = 1 - sqrt(f1) - f1*sin(10*pi*f1), f1 in [0,1] (disconnected segments)
%   Pareto set: x1 in [0,1], x_i = 0 for i = 2..n (multiple segments)
%
% USAGE:
%   F = ZDT3(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZDT3('bounds')  % Get bounds
%   info = ZDT3()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 30;
mloc = 2;
lb_orig = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
ub_work = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625;211726.5625;711.2265625;461476.5625;960.9765625;55632.8125;555.1328125;305382.8125;804.8828125;180507.8125;680.0078125;430257.8125;929.7578125;118070.3125;617.5703125;367820.3125;867.3203125;242945.3125;742.4453125;492695.3125;992.1953125;4902.34375;504.40234375];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625;86851.5625;586.3515625;336601.5625;836.1015625;211726.5625;711.2265625;461476.5625;960.9765625;55632.8125;555.1328125;305382.8125;804.8828125;180507.8125;680.0078125;430257.8125;929.7578125;118070.3125;617.5703125;367820.3125;867.3203125;242945.3125;742.4453125;492695.3125;992.1953125;4902.34375;504.40234375];
contrast_ratio = 976.7902917282985;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT3';
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
    info.pareto_front_known = true;
    info.pf_type = 'disconnected';
    info.pf_expression = 'f2 = 1 - sqrt(f1) - f1*sin(10*pi*f1), f1 in [0,1] (disconnected segments)';
    info.pareto_set_known = true;
    info.ps_expression = 'x1 in [0,1], x_i = 0 for i = 2..n (multiple segments)';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'ZDT3: Disconnected PF (5 segments). Ideal/nadir not provided (disconnected geometry). Ref: Zitzler et al. (2000).';
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
    error('Input x must have 30 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = ZDT3_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT3_orig)
% -------------------------------------------------------------------------
function f = ZDT3_orig(x)
% ZDT3 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T3.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
m = 30;
pi = 4*atan(1);

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x)
gx = 1 + 9/(m-1) * sum(x(2:m));

% Cálculo de h - Note que é diferente do ZDT1 e ZDT2: inclui termo senoidal
h = 1 - sqrt(f1/gx) - (f1/gx)*sin(10*pi*f1);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

