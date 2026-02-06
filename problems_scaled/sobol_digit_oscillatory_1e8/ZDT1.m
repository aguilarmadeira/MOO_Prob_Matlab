function varargout = ZDT1(varargin)
%ZDT1  ZDT1 (n=30, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 4862.32     ]   (range: 4862.32     )
%   x2   ∈ [0           , 6096.98     ]   (range: 6096.98     )
%   x3   ∈ [0           , 2467.05     ]   (range: 2467.05     )
%   x4   ∈ [0           , 8.72202e+07 ]   (range: 8.72202e+07 )
%   x5   ∈ [0           , 3.45656e+07 ]   (range: 3.45656e+07 )
%   x6   ∈ [0           , 7192.12     ]   (range: 7192.12     )
%   x7   ∈ [0           , 1.06259e+07 ]   (range: 1.06259e+07 )
%   x8   ∈ [0           , 9.81586e+07 ]   (range: 9.81586e+07 )
%   x9   ∈ [0           , 4038.65     ]   (range: 4038.65     )
%   x10  ∈ [0           , 5.28295e+07 ]   (range: 5.28295e+07 )
%   x11  ∈ [0           , 1.40874e+07 ]   (range: 1.40874e+07 )
%   x12  ∈ [0           , 7.67331e+07 ]   (range: 7.67331e+07 )
%   x13  ∈ [0           , 2.99543e+07 ]   (range: 2.99543e+07 )
%   x14  ∈ [0           , 6.75063e+07 ]   (range: 6.75063e+07 )
%   x15  ∈ [0           , 625.831     ]   (range: 625.831     )
%   x16  ∈ [0           , 9359.76     ]   (range: 9359.76     )
%   x17  ∈ [0           , 4.51432e+07 ]   (range: 4.51432e+07 )
%   x18  ∈ [0           , 5778.25     ]   (range: 5778.25     )
%   x19  ∈ [0           , 1908.78     ]   (range: 1908.78     )
%   x20  ∈ [0           , 8.15401e+07 ]   (range: 8.15401e+07 )
%   x21  ∈ [0           , 3.41918e+07 ]   (range: 3.41918e+07 )
%   x22  ∈ [0           , 7184.02     ]   (range: 7184.02     )
%   x23  ∈ [0           , 814.946     ]   (range: 814.946     )
%   x24  ∈ [0           , 9558.48     ]   (range: 9558.48     )
%   x25  ∈ [0           , 4088.26     ]   (range: 4088.26     )
%   x26  ∈ [0           , 5342.27     ]   (range: 5342.27     )
%   x27  ∈ [0           , 1717.37     ]   (range: 1717.37     )
%   x28  ∈ [0           , 7952.7      ]   (range: 7952.7      )
%   x29  ∈ [0           , 2.73435e+07 ]   (range: 2.73435e+07 )
%   x30  ∈ [0           , 6470.06     ]   (range: 6470.06     )
%
% Effective contrast ratio (max range / min range): 156845.3611898751
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
%   F = ZDT1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZDT1('bounds')  % Get bounds
%   info = ZDT1()          % Get complete problem information
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
ub_work = [4862.320862806715;6096.982306913446;2467.053208230645;87220243.43133861;34565571.40179612;7192.117721419489;10625864.29628848;98158628.1792502;4038.6500877578;52829480.24433135;14087447.9685118;76733142.81165613;29954277.7125896;67506273.66750716;625.8306107020949;9359.763556825603;45143165.82783911;5778.253720106782;1908.784995528009;81540109.26064056;34191812.801984;7184.017405657425;814.9464833149584;9558.477816240384;4088.260218662865;5342.265216546562;1717.366267444656;7952.698201702327;27343485.01441038;6470.064551362571];
scale_factors = [4862.320862806715;6096.982306913446;2467.053208230645;87220243.43133861;34565571.40179612;7192.117721419489;10625864.29628848;98158628.1792502;4038.6500877578;52829480.24433135;14087447.9685118;76733142.81165613;29954277.7125896;67506273.66750716;625.8306107020949;9359.763556825603;45143165.82783911;5778.253720106782;1908.784995528009;81540109.26064056;34191812.801984;7184.017405657425;814.9464833149584;9558.477816240384;4088.260218662865;5342.265216546562;1717.366267444656;7952.698201702327;27343485.01441038;6470.064551362571];
contrast_ratio = 156845.3611898751;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZDT1';
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
    info.pareto_note = 'ZDT1: Convex PF. Ref: Zitzler et al. (2000).';
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
F = ZDT1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZDT1_orig)
% -------------------------------------------------------------------------
function f = ZDT1_orig(x)
% ZDT1 function
%
%   As described by E. Zitzler, K. Deb, and L. Thiele in "Comparison of
%   Multiobjective Evolutionary Algorithms: Empirical Results", Evolutionary 
%   Computation 8(2): 173-195, 2000
%
%   Example T1.
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

% Cálculo de h
h = 1 - sqrt(f1/gx);

% Função objetivo 2
f2 = gx * h;

% Vetor de funções objetivo
f = [f1; f2];


end

