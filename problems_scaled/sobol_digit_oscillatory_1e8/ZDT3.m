function varargout = ZDT3(varargin)
%ZDT3  ZDT3 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 7384.02     ]   (range: 7384.02     )
%   x2   ∈ [0           , 1910.63     ]   (range: 1910.63     )
%   x3   ∈ [0           , 8813.24     ]   (range: 8813.24     )
%   x4   ∈ [0           , 4238.8      ]   (range: 4238.8      )
%   x5   ∈ [0           , 5.219e+07   ]   (range: 5.219e+07   )
%   x6   ∈ [0           , 3.3209e+06  ]   (range: 3.3209e+06  )
%   x7   ∈ [0           , 8477.25     ]   (range: 8477.25     )
%   x8   ∈ [0           , 3316.34     ]   (range: 3316.34     )
%   x9   ∈ [0           , 6.77823e+07 ]   (range: 6.77823e+07 )
%   x10  ∈ [0           , 1.26577e+07 ]   (range: 1.26577e+07 )
%   x11  ∈ [0           , 9.41781e+07 ]   (range: 9.41781e+07 )
%   x12  ∈ [0           , 4882.45     ]   (range: 4882.45     )
%   x13  ∈ [0           , 6051.6      ]   (range: 6051.6      )
%   x14  ∈ [0           , 9.01046e+06 ]   (range: 9.01046e+06 )
%   x15  ∈ [0           , 7752.09     ]   (range: 7752.09     )
%   x16  ∈ [0           , 2.95248e+07 ]   (range: 2.95248e+07 )
%   x17  ∈ [0           , 6.99044e+07 ]   (range: 6.99044e+07 )
%   x18  ∈ [0           , 2464.22     ]   (range: 2464.22     )
%   x19  ∈ [0           , 9312.97     ]   (range: 9312.97     )
%   x20  ∈ [0           , 3.88902e+07 ]   (range: 3.88902e+07 )
%   x21  ∈ [0           , 5.40767e+07 ]   (range: 5.40767e+07 )
%   x22  ∈ [0           , 296.187     ]   (range: 296.187     )
%   x23  ∈ [0           , 8.39726e+07 ]   (range: 8.39726e+07 )
%   x24  ∈ [0           , 3558.56     ]   (range: 3558.56     )
%   x25  ∈ [0           , 6.34665e+07 ]   (range: 6.34665e+07 )
%   x26  ∈ [0           , 1.8595e+07  ]   (range: 1.8595e+07  )
%   x27  ∈ [0           , 9957.98     ]   (range: 9957.98     )
%   x28  ∈ [0           , 4494.96     ]   (range: 4494.96     )
%   x29  ∈ [0           , 5.63637e+07 ]   (range: 5.63637e+07 )
%   x30  ∈ [0           , 1158.99     ]   (range: 1158.99     )
%
% Effective contrast ratio (max range / min range): 317968.4186351744
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
ub_work = [7384.018015367712;1910.63388435596;8813.244278294094;4238.804273409765;52189990.74744542;3320902.078762356;8477.252413752487;3316.336548192228;67782311.31749824;12657709.73500984;94178070.09372877;4882.4454162573;6051.604271861484;9010458.000496369;7752.094988396489;29524781.92636903;69904438.9960928;2464.216138123277;9312.968708022598;38890182.20873015;54076681.20192858;296.1868681738022;83972553.01334235;3558.55890241423;63466497.5809245;18595013.02355465;9957.984626859185;4494.957218492251;56363715.26485982;1158.988091059878];
scale_factors = [7384.018015367712;1910.63388435596;8813.244278294094;4238.804273409765;52189990.74744542;3320902.078762356;8477.252413752487;3316.336548192228;67782311.31749824;12657709.73500984;94178070.09372877;4882.4454162573;6051.604271861484;9010458.000496369;7752.094988396489;29524781.92636903;69904438.9960928;2464.216138123277;9312.968708022598;38890182.20873015;54076681.20192858;296.1868681738022;83972553.01334235;3558.55890241423;63466497.5809245;18595013.02355465;9957.984626859185;4494.957218492251;56363715.26485982;1158.988091059878];
contrast_ratio = 317968.4186351744;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT3';
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

