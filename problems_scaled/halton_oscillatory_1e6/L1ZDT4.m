function varargout = L1ZDT4(varargin)
%L1ZDT4  L1ZDT4 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
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
%
% Effective contrast ratio (max range / min range): 13795.07389162562
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = L1ZDT4(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = L1ZDT4('bounds')  % Get bounds
%   info = L1ZDT4()          % Get complete problem information
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
ub_work = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875];
scale_factors = [500500;250.75;750250;125.875;625375;375.625;875125;63.4375;562937.5;313.1875];
contrast_ratio = 13795.07389162562;

if nargin == 0
    info.name = mfilename;
    info.problem = 'L1ZDT4';
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
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'L1ZDT4: Expected PF same as ZDT1 (f2=1-sqrt(f1)); landscape-modified. Ref: Deb et al. (2006).';
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
F = L1ZDT4_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to L1ZDT4_orig)
% -------------------------------------------------------------------------
function f = L1ZDT4_orig(x)
% L1ZDT4 - Linkage L1 variant of ZDT4
%
% As described by K. Deb, A. Sinha and S. Kukkonen in "Multi-objective
% test problems, linkages, and evolutionary methodologies", GECCO'06:
% Proceedings of the 8th Annual Conference on Genetic and Evolutionary
% Computation, 1141-1148, 2006.
%
% Example T4 (ZDT4), with linkage L1.
%
% This file is part of a collection of problems developed for
% derivative-free multiobjective optimization in
% A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
% Direct Multisearch for Multiobjective Optimization, 2011.
%
% Converted to MATLAB format by J. F. A. Madeira in 2025.

% Problem dimensions
n = 10;  % number of variables
m = 2;   % number of objectives

% Bounds
lb = zeros(n, 1);
ub = ones(n, 1);
lb(1) = 0.0;
ub(1) = 1.0;
lb(2:n) = -5.0;
ub(2:n) = 5.0;

% Linkage matrix A (10x10)
A = [
    1.0000000   0.0000000   0.0000000   0.0000000   0.0000000   0.0000000   0.0000000   0.0000000   0.0000000   0.0000000;
    0.0000000   0.8840430  -0.2729510  -0.9938220   0.5111970  -0.0997948  -0.6597560   0.5754960   0.6756170   0.1803320;
    0.0000000  -0.4927220   0.0646786  -0.6665030  -0.9457160  -0.3345820   0.6118940   0.2810320   0.5087490  -0.0265389;
    0.0000000   0.3088610  -0.0437502  -0.3742030   0.2073590  -0.2194330   0.9141040   0.1844080   0.5205990  -0.8856500;
    0.0000000  -0.7089480  -0.3790200   0.5765780   0.0194674  -0.4702620   0.5725760   0.3512450  -0.4804770   0.2382610;
    0.0000000  -0.8273020   0.6692480   0.4944750   0.6917150  -0.1985850   0.0492812   0.9596690   0.8840860  -0.2186320;
    0.0000000  -0.7159970   0.2207720   0.6923560   0.6464530  -0.4017240   0.6154430  -0.0601957  -0.7481760  -0.2079870;
    0.0000000   0.6137320  -0.5257120  -0.9957280   0.3896330  -0.0641730   0.6621310  -0.7070480  -0.3404230   0.6062400;
    0.0000000  -0.1604460  -0.3945850  -0.1675810   0.0679849   0.4497990   0.7335050  -0.00918638  0.00446808  0.4043960;
    0.0000000   0.1627110   0.2944540  -0.5633450  -0.1149930   0.5495890  -0.7751410   0.6777260   0.6107150   0.0850755
];

% If no input, return only problem info
if nargin == 0
    f = [];
    return;
end

% Ensure x is a column vector
x = x(:);

% Variable transformation: y = A * x
y = A * x;

% Objective functions
f1 = y(1)^2;

% g(x)
gx = 1 + 10*(n-1);
for i = 2:n
    gx = gx + (y(i)^2 - 10*cos(4*pi*y(i)));
end

% h function
h = 1 - sqrt(f1/gx);

% Second objective
f2 = gx * h;

% Output
f = [f1; f2];
end
