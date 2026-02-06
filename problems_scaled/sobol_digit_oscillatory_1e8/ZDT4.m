function varargout = ZDT4(varargin)
%ZDT4  ZDT4 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 4.13568e+07 ]   (range: 4.13568e+07 )
%   x2   ∈ [0           , 9.0212e+07  ]   (range: 9.0212e+07  )
%   x3   ∈ [0           , 1973.62     ]   (range: 1973.62     )
%   x4   ∈ [0           , 7.40901e+07 ]   (range: 7.40901e+07 )
%   x5   ∈ [0           , 3.27177e+07 ]   (range: 3.27177e+07 )
%   x6   ∈ [0           , 8616.85     ]   (range: 8616.85     )
%   x7   ∈ [0           , 3.48834e+06 ]   (range: 3.48834e+06 )
%   x8   ∈ [0           , 5305.16     ]   (range: 5305.16     )
%   x9   ∈ [0           , 4857.91     ]   (range: 4857.91     )
%   x10  ∈ [0           , 9509.7      ]   (range: 9509.7      )
%
% Effective contrast ratio (max range / min range): 45709.02651946369
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (convex)
%   PF expression: f2 = 1 - sqrt(f1), f1 in [0,1]
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x1 in [0,1], x_i = 0 for i = 2..n
%
% USAGE:
%   F = ZDT4(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZDT4('bounds')  % Get bounds
%   info = ZDT4()          % Get complete problem information
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
ub_work = [41356800.26334448;90212047.30442536;1973.615589166212;74090119.76932323;32717680.64882512;8616.846520480358;3488337.020353825;5305.156577226224;4857.906701299827;9509.697278297423];
scale_factors = [41356800.26334448;90212047.30442536;1973.615589166212;74090119.76932323;32717680.64882512;8616.846520480358;3488337.020353825;5305.156577226224;4857.906701299827;9509.697278297423];
contrast_ratio = 45709.02651946369;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT4';
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
    info.pf_type = 'convex';
    info.pf_expression = 'f2 = 1 - sqrt(f1), f1 in [0,1]';
    info.pareto_set_known = true;
    info.ps_expression = 'x1 in [0,1], x_i = 0 for i = 2..n';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'ZDT4: Same PF as ZDT1; multimodal landscape (21^9 local fronts). Ref: Zitzler et al. (2000).';
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
F = ZDT4_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT4_orig)
% -------------------------------------------------------------------------
function f = ZDT4_orig(x)
% ZDT4 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T4.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
m = 10;
pi = 4*atan(1);

% Função objetivo 1
f1 = x(1);

% Cálculo de g(x) - Multimodal com muitos ótimos locais
gx = 1 + 10*(m-1) + sum(x(2:m).^2 - 10*cos(4*pi*x(2:m)));

% Cálculo de h - Similar ao ZDT1
h = 1 - sqrt(f1/gx);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


% Note que este problema tem limites diferentes:
% 0 <= x(1) <= 1
% -5 <= x(i) <= 5 para i=2,...,m

end

