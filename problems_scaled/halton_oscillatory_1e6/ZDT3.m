function varargout = ZDT3(varargin)
%ZDT3  ZDT3 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 500500      ]   (range: 500500      )
%   x2   ∈ [0           , 250.75      ]   (range: 250.75      )
%   x3   ∈ [0           , 750250      ]   (range: 750250      )
%   x4   ∈ [0           , 125.875     ]   (range: 125.875     )
%   x5   ∈ [0           , 625375      ]   (range: 625375      )
%   x6   ∈ [0           , 375.625     ]   (range: 375.625     )
%   x7   ∈ [0           , 875125      ]   (range: 875125      )
%   x8   ∈ [0           , 63.4375     ]   (range: 63.4375     )
%   x9   ∈ [0           , 562938      ]   (range: 562938      )
%   x10  ∈ [0           , 313.188     ]   (range: 313.188     )
%   x11  ∈ [0           , 812688      ]   (range: 812688      )
%   x12  ∈ [0           , 188.312     ]   (range: 188.312     )
%   x13  ∈ [0           , 687812      ]   (range: 687812      )
%   x14  ∈ [0           , 438.062     ]   (range: 438.062     )
%   x15  ∈ [0           , 937562      ]   (range: 937562      )
%   x16  ∈ [0           , 32.2188     ]   (range: 32.2188     )
%   x17  ∈ [0           , 531719      ]   (range: 531719      )
%   x18  ∈ [0           , 281.969     ]   (range: 281.969     )
%   x19  ∈ [0           , 781469      ]   (range: 781469      )
%   x20  ∈ [0           , 157.094     ]   (range: 157.094     )
%   x21  ∈ [0           , 656594      ]   (range: 656594      )
%   x22  ∈ [0           , 406.844     ]   (range: 406.844     )
%   x23  ∈ [0           , 906344      ]   (range: 906344      )
%   x24  ∈ [0           , 94.6562     ]   (range: 94.6562     )
%   x25  ∈ [0           , 594156      ]   (range: 594156      )
%   x26  ∈ [0           , 344.406     ]   (range: 344.406     )
%   x27  ∈ [0           , 843906      ]   (range: 843906      )
%   x28  ∈ [0           , 219.531     ]   (range: 219.531     )
%   x29  ∈ [0           , 719031      ]   (range: 719031      )
%   x30  ∈ [0           , 469.281     ]   (range: 469.281     )
%
% Effective contrast ratio (max range / min range): 29099.90300678953
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
ub_work = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875;812687.5;188.3125;687812.5;438.0625;937562.5;32.21875;531718.75;281.96875;781468.75;157.09375;656593.75;406.84375;906343.75;94.65625;594156.25;344.40625;843906.25;219.53125;719031.25;469.28125];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875;812687.5;188.3125;687812.5;438.0625;937562.5;32.21875;531718.75;281.96875;781468.75;157.09375;656593.75;406.84375;906343.75;94.65625;594156.25;344.40625;843906.25;219.53125;719031.25;469.28125];
contrast_ratio = 29099.90300678953;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT3';
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

