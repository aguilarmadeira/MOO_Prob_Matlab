function varargout = ZDT2(varargin)
%ZDT2  ZDT2 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 276665      ]   (range: 276665      )
%   x2   ∈ [0           , 932.163     ]   (range: 932.163     )
%   x3   ∈ [0           , 237025      ]   (range: 237025      )
%   x4   ∈ [0           , 579.56      ]   (range: 579.56      )
%   x5   ∈ [0           , 407.211     ]   (range: 407.211     )
%   x6   ∈ [0           , 750.765     ]   (range: 750.765     )
%   x7   ∈ [0           , 74285.9     ]   (range: 74285.9     )
%   x8   ∈ [0           , 730.715     ]   (range: 730.715     )
%   x9   ∈ [0           , 324743      ]   (range: 324743      )
%   x10  ∈ [0           , 979.754     ]   (range: 979.754     )
%   x11  ∈ [0           , 157.728     ]   (range: 157.728     )
%   x12  ∈ [0           , 500751      ]   (range: 500751      )
%   x13  ∈ [0           , 442.579     ]   (range: 442.579     )
%   x14  ∈ [0           , 848.077     ]   (range: 848.077     )
%   x15  ∈ [0           , 47.7058     ]   (range: 47.7058     )
%   x16  ∈ [0           , 640224      ]   (range: 640224      )
%   x17  ∈ [0           , 296698      ]   (range: 296698      )
%   x18  ∈ [0           , 890728      ]   (range: 890728      )
%   x19  ∈ [0           , 192.61      ]   (range: 192.61      )
%   x20  ∈ [0           , 598.549     ]   (range: 598.549     )
%   x21  ∈ [0           , 397.001     ]   (range: 397.001     )
%   x22  ∈ [0           , 802.011     ]   (range: 802.011     )
%   x23  ∈ [0           , 124503      ]   (range: 124503      )
%   x24  ∈ [0           , 717.509     ]   (range: 717.509     )
%   x25  ∈ [0           , 373.983     ]   (range: 373.983     )
%   x26  ∈ [0           , 967525      ]   (range: 967525      )
%   x27  ∈ [0           , 146545      ]   (range: 146545      )
%   x28  ∈ [0           , 552.971     ]   (range: 552.971     )
%   x29  ∈ [0           , 478106      ]   (range: 478106      )
%   x30  ∈ [0           , 822.37      ]   (range: 822.37      )
%
% Effective contrast ratio (max range / min range): 20281.09767925604
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
ub_work = [276665.3277851059;932.1634076233233;237025.257352701;579.5602925667848;407.2110609392381;750.7645471201985;74285.91068135451;730.7147911583015;324743.3891236537;979.7535194530889;157.72834971947;500751.0813761418;442.579221577428;848.0765498230627;47.70576387112647;640224.1486979643;296697.8683698502;890728.2508191202;192.6104742451663;598.5491203068894;397.0010850169774;802.0108359103307;124502.7774289773;717.5089926747432;373.9826900172369;967525.2569338396;146544.738003042;552.9709763033075;478106.0030314303;822.3701890389819];
scale_factors = [276665.3277851059;932.1634076233233;237025.257352701;579.5602925667848;407.2110609392381;750.7645471201985;74285.91068135451;730.7147911583015;324743.3891236537;979.7535194530889;157.72834971947;500751.0813761418;442.579221577428;848.0765498230627;47.70576387112647;640224.1486979643;296697.8683698502;890728.2508191202;192.6104742451663;598.5491203068894;397.0010850169774;802.0108359103307;124502.7774289773;717.5089926747432;373.9826900172369;967525.2569338396;146544.738003042;552.9709763033075;478106.0030314303;822.3701890389819];
contrast_ratio = 20281.09767925604;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT2';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 1000000;
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
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a m-dimensional vector, where m = 30
%
%   Problem characteristics:
%   m = 30 variables; 2 objectives.
%   Bounds: x1 in [0,1], x2 in [0,1], x3 in [0,1], x4 in [0,1], x5 in [0,1], x6 in [0,1], x7 in [0,1], x8 in [0,1], x9 in [0,1], x10 in [0,1], x11 in [0,1], x12 in [0,1], x13 in [0,1], x14 in [0,1], x15 in [0,1], x16 in [0,1], x17 in [0,1], x18 in [0,1], x19 in [0,1], x20 in [0,1], x21 in [0,1], x22 in [0,1], x23 in [0,1], x24 in [0,1], x25 in [0,1], x26 in [0,1], x27 in [0,1], x28 in [0,1], x29 in [0,1], x30 in [0,1]
%
%   Output: f is a 2-dimensional vector with the function values
%          handled by the optimization algorithm)

% Número de variáveis
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

