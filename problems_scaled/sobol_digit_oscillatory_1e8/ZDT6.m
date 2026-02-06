function varargout = ZDT6(varargin)
%ZDT6  ZDT6 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 9573.37     ]   (range: 9573.37     )
%   x2   ∈ [0           , 3393.8      ]   (range: 3393.8      )
%   x3   ∈ [0           , 6618.9      ]   (range: 6618.9      )
%   x4   ∈ [0           , 416.284     ]   (range: 416.284     )
%   x5   ∈ [0           , 7903.33     ]   (range: 7903.33     )
%   x6   ∈ [0           , 4.12648e+07 ]   (range: 4.12648e+07 )
%   x7   ∈ [0           , 5.8667e+07  ]   (range: 5.8667e+07  )
%   x8   ∈ [0           , 2.10586e+07 ]   (range: 2.10586e+07 )
%   x9   ∈ [0           , 9.24768e+07 ]   (range: 9.24768e+07 )
%   x10  ∈ [0           , 3104.27     ]   (range: 3104.27     )
%
% Effective contrast ratio (max range / min range): 222148.0782110359
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   Pareto front: KNOWN (concave)
%   PF expression: f2 = 1 - f1^2, f1 in [f1_min, 1]
%   Nadir point: [1 1]
%   Pareto set: x1 in [0,1], x_i = 0 for i = 2..n
%
% USAGE:
%   F = ZDT6(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZDT6('bounds')  % Get bounds
%   info = ZDT6()          % Get complete problem information
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
ub_work = [9573.372416205617;3393.801210263781;6618.903551868677;416.2842874645036;7903.328786311145;41264773.29520749;58666987.13907769;21058578.2847199;92476754.44968989;3104.268702095551];
scale_factors = [9573.372416205617;3393.801210263781;6618.903551868677;416.2842874645036;7903.328786311145;41264773.29520749;58666987.13907769;21058578.2847199;92476754.44968989;3104.268702095551];
contrast_ratio = 222148.0782110359;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT6';
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
    info.pf_expression = 'f2 = 1 - f1^2, f1 in [f1_min, 1]';
    info.pareto_set_known = true;
    info.ps_expression = 'x1 in [0,1], x_i = 0 for i = 2..n';
    info.ideal_point = [];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'ZDT6: Concave PF, non-uniform density. f1_min ~= 0.2808 (numerically computed), not stored as ideal_point. Ref: Zitzler et al. (2000).';
    info.f1_min_approx = 0.2807753191;  % approximate, not stored as ideal_point
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
F = ZDT6_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT6_orig)
% -------------------------------------------------------------------------
function f = ZDT6_orig(x)
% ZDT6 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T6.
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

% Função objetivo 1 - Função não-uniforme
f1 = 1 - exp(-4*x(1)) * (sin(6*pi*x(1)))^6;

% Cálculo de g(x) - Usa potência de 1/4
gx = 1 + 9 * ((sum(x(2:m)))/(m-1))^0.25;

% Cálculo de h - Similar ao ZDT2: usa (f1/gx)^2
h = 1 - (f1/gx)^2;

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

