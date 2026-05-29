function varargout = ZDT3(varargin)
%ZDT3  ZDT3 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 738.637     ]   (range: 738.637     )
%   x2   ∈ [0           , 191.792     ]   (range: 191.792     )
%   x3   ∈ [0           , 881.431     ]   (range: 881.431     )
%   x4   ∈ [0           , 424.399     ]   (range: 424.399     )
%   x5   ∈ [0           , 522330      ]   (range: 522330      )
%   x6   ∈ [0           , 34079.2     ]   (range: 34079.2     )
%   x7   ∈ [0           , 847.862     ]   (range: 847.862     )
%   x8   ∈ [0           , 332.235     ]   (range: 332.235     )
%   x9   ∈ [0           , 678113      ]   (range: 678113      )
%   x10  ∈ [0           , 127363      ]   (range: 127363      )
%   x11  ∈ [0           , 941833      ]   (range: 941833      )
%   x12  ∈ [0           , 488.705     ]   (range: 488.705     )
%   x13  ∈ [0           , 605.516     ]   (range: 605.516     )
%   x14  ∈ [0           , 90923.6     ]   (range: 90923.6     )
%   x15  ∈ [0           , 775.412     ]   (range: 775.412     )
%   x16  ∈ [0           , 295882      ]   (range: 295882      )
%   x17  ∈ [0           , 699315      ]   (range: 699315      )
%   x18  ∈ [0           , 247.1       ]   (range: 247.1       )
%   x19  ∈ [0           , 931.359     ]   (range: 931.359     )
%   x20  ∈ [0           , 389452      ]   (range: 389452      )
%   x21  ∈ [0           , 541180      ]   (range: 541180      )
%   x22  ∈ [0           , 30.4921     ]   (range: 30.4921     )
%   x23  ∈ [0           , 839870      ]   (range: 839870      )
%   x24  ∈ [0           , 356.436     ]   (range: 356.436     )
%   x25  ∈ [0           , 634994      ]   (range: 634994      )
%   x26  ∈ [0           , 186683      ]   (range: 186683      )
%   x27  ∈ [0           , 995.802     ]   (range: 995.802     )
%   x28  ∈ [0           , 449.991     ]   (range: 449.991     )
%   x29  ∈ [0           , 564030      ]   (range: 564030      )
%   x30  ∈ [0           , 116.695     ]   (range: 116.695     )
%
% Effective contrast ratio (max range / min range): 30887.75675935903
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
ub_work = [738.6372634615806;191.7915041975802;881.4312465262326;424.3989868123168;522330.2405910388;34079.21968880481;847.8623023641098;332.2352446888725;678113.1013719445;127363.2565784061;941833.1035467051;488.7051676008643;605.5158183407964;90923.5677817369;775.4118305238617;295882.1596603926;699315.2770986769;247.0999021887343;931.3587098024377;389451.8654517594;541180.1632235888;30.49211734229707;839869.7915824484;356.4356779189735;634993.8102144572;186682.8483901499;995.8022444476773;449.9912252499008;564029.9184877983;116.6945797548573];
scale_factors = [738.6372634615806;191.7915041975802;881.4312465262326;424.3989868123168;522330.2405910388;34079.21968880481;847.8623023641098;332.2352446888725;678113.1013719445;127363.2565784061;941833.1035467051;488.7051676008643;605.5158183407964;90923.5677817369;775.4118305238617;295882.1596603926;699315.2770986769;247.0999021887343;931.3587098024377;389451.8654517594;541180.1632235888;30.49211734229707;839869.7915824484;356.4356779189735;634993.8102144572;186682.8483901499;995.8022444476773;449.9912252499008;564029.9184877983;116.6945797548573];
contrast_ratio = 30887.75675935903;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT3';
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

% Parâmetros
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

