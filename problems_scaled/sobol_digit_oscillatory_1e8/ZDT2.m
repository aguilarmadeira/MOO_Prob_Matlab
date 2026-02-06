function varargout = ZDT2(varargin)
%ZDT2  ZDT2 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 2.76014e+07 ]   (range: 2.76014e+07 )
%   x2   ∈ [0           , 9321.02     ]   (range: 9321.02     )
%   x3   ∈ [0           , 2.36338e+07 ]   (range: 2.36338e+07 )
%   x4   ∈ [0           , 5791.82     ]   (range: 5791.82     )
%   x5   ∈ [0           , 4066.77     ]   (range: 4066.77     )
%   x6   ∈ [0           , 7505.4      ]   (range: 7505.4      )
%   x7   ∈ [0           , 7.34519e+06 ]   (range: 7.34519e+06 )
%   x8   ∈ [0           , 7304.72     ]   (range: 7304.72     )
%   x9   ∈ [0           , 3.24135e+07 ]   (range: 3.24135e+07 )
%   x10  ∈ [0           , 9797.35     ]   (range: 9797.35     )
%   x11  ∈ [0           , 1569.7      ]   (range: 1569.7      )
%   x12  ∈ [0           , 5.00301e+07 ]   (range: 5.00301e+07 )
%   x13  ∈ [0           , 4420.77     ]   (range: 4420.77     )
%   x14  ∈ [0           , 8479.4      ]   (range: 8479.4      )
%   x15  ∈ [0           , 468.478     ]   (range: 468.478     )
%   x16  ∈ [0           , 6.399e+07   ]   (range: 6.399e+07   )
%   x17  ∈ [0           , 2.96064e+07 ]   (range: 2.96064e+07 )
%   x18  ∈ [0           , 8.9063e+07  ]   (range: 8.9063e+07  )
%   x19  ∈ [0           , 1918.83     ]   (range: 1918.83     )
%   x20  ∈ [0           , 5981.87     ]   (range: 5981.87     )
%   x21  ∈ [0           , 3964.58     ]   (range: 3964.58     )
%   x22  ∈ [0           , 8018.32     ]   (range: 8018.32     )
%   x23  ∈ [0           , 1.23714e+07 ]   (range: 1.23714e+07 )
%   x24  ∈ [0           , 7172.54     ]   (range: 7172.54     )
%   x25  ∈ [0           , 3734.19     ]   (range: 3734.19     )
%   x26  ∈ [0           , 9.67496e+07 ]   (range: 9.67496e+07 )
%   x27  ∈ [0           , 1.45776e+07 ]   (range: 1.45776e+07 )
%   x28  ∈ [0           , 5525.68     ]   (range: 5525.68     )
%   x29  ∈ [0           , 4.77636e+07 ]   (range: 4.77636e+07 )
%   x30  ∈ [0           , 8222.1      ]   (range: 8222.1      )
%
% Effective contrast ratio (max range / min range): 206518.8014966316
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (concave)
%   PF expression: f2 = 1 - f1^2, f1 in [0,1]
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x1 in [0,1], x_i = 0 for i = 2..n
%
% USAGE:
%   F = ZDT2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZDT2('bounds')  % Get bounds
%   info = ZDT2()          % Get complete problem information
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
ub_work = [27601367.49272547;9321.022935761372;23633789.27196854;5791.815180555837;4066.770168499942;7505.400106761626;7345193.402431069;7304.721918710567;32413504.98345759;9797.352793805241;1569.69546430929;50030130.75755797;4420.770406959662;8479.396818499303;468.4784113587523;63990002.63094039;29606426.2845859;89062980.78018402;1918.830962940358;5981.874528477065;3964.578427512269;8018.324672940336;12371404.11924268;7172.544962717476;3734.187104586939;96749600.04085548;14577585.93886304;5525.682474531302;47763582.82593866;8222.101621822603];
scale_factors = [27601367.49272547;9321.022935761372;23633789.27196854;5791.815180555837;4066.770168499942;7505.400106761626;7345193.402431069;7304.721918710567;32413504.98345759;9797.352793805241;1569.69546430929;50030130.75755797;4420.770406959662;8479.396818499303;468.4784113587523;63990002.63094039;29606426.2845859;89062980.78018402;1918.830962940358;5981.874528477065;3964.578427512269;8018.324672940336;12371404.11924268;7172.544962717476;3734.187104586939;96749600.04085548;14577585.93886304;5525.682474531302;47763582.82593866;8222.101621822603];
contrast_ratio = 206518.8014966316;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT2';
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
    info.pf_type = 'concave';
    info.pf_expression = 'f2 = 1 - f1^2, f1 in [0,1]';
    info.pareto_set_known = true;
    info.ps_expression = 'x1 in [0,1], x_i = 0 for i = 2..n';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'ZDT2: Concave PF. Ref: Zitzler et al. (2000).';
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
F = ZDT2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT2_orig)
% -------------------------------------------------------------------------
function f = ZDT2_orig(x)
% ZDT2 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T2.
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

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x)
gx = 1 + 9/(m-1) * sum(x(2:m));

% Cálculo de h - Note a diferença em relação ao ZDT1: aqui usa (f1/gx)^2
h = 1 - (f1/gx)^2;

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

