function varargout = ZDT2(varargin)
%ZDT2  ZDT2 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (MODERATE HETEROGENEITY):
%
%   x1   ∈ [0           , 1           ]   (range: 1           )
%   x2   ∈ [0           , 4.64159     ]   (range: 4.64159     )
%   x3   ∈ [0           , 21.5443     ]   (range: 21.5443     )
%   x4   ∈ [0           , 100         ]   (range: 100         )
%   x5   ∈ [0           , 0.215443    ]   (range: 0.215443    )
%   x6   ∈ [0           , 0.0464159   ]   (range: 0.0464159   )
%   x7   ∈ [0           , 0.01        ]   (range: 0.01        )
%   x8   ∈ [0           , 1           ]   (range: 1           )
%   x9   ∈ [0           , 4.64159     ]   (range: 4.64159     )
%   x10  ∈ [0           , 21.5443     ]   (range: 21.5443     )
%   x11  ∈ [0           , 100         ]   (range: 100         )
%   x12  ∈ [0           , 0.215443    ]   (range: 0.215443    )
%   x13  ∈ [0           , 0.0464159   ]   (range: 0.0464159   )
%   x14  ∈ [0           , 0.01        ]   (range: 0.01        )
%   x15  ∈ [0           , 1           ]   (range: 1           )
%   x16  ∈ [0           , 4.64159     ]   (range: 4.64159     )
%   x17  ∈ [0           , 21.5443     ]   (range: 21.5443     )
%   x18  ∈ [0           , 100         ]   (range: 100         )
%   x19  ∈ [0           , 0.215443    ]   (range: 0.215443    )
%   x20  ∈ [0           , 0.0464159   ]   (range: 0.0464159   )
%   x21  ∈ [0           , 0.01        ]   (range: 0.01        )
%   x22  ∈ [0           , 1           ]   (range: 1           )
%   x23  ∈ [0           , 4.64159     ]   (range: 4.64159     )
%   x24  ∈ [0           , 21.5443     ]   (range: 21.5443     )
%   x25  ∈ [0           , 100         ]   (range: 100         )
%   x26  ∈ [0           , 0.215443    ]   (range: 0.215443    )
%   x27  ∈ [0           , 0.0464159   ]   (range: 0.0464159   )
%   x28  ∈ [0           , 0.01        ]   (range: 0.01        )
%   x29  ∈ [0           , 1           ]   (range: 1           )
%   x30  ∈ [0           , 4.64159     ]   (range: 4.64159     )
%
% Effective contrast ratio (max range / min range): 10000
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
ub_work = [1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778];
scale_factors = [1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778;21.54434690031884;100;0.2154434690031884;0.04641588833612779;0.01;1;4.641588833612778];
contrast_ratio = 10000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT2';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'moderate';
    info.kappa = 10000;
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

