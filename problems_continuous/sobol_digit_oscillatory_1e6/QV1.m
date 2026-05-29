function varargout = QV1(varargin)
%QV1  QV1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-2941.97    , 2941.97     ]   (range: 5883.95     )
%   x2   ∈ [-1.11174e+06, 1.11174e+06 ]   (range: 2.22349e+06 )
%   x3   ∈ [-5.02336e+06, 5.02336e+06 ]   (range: 1.00467e+07 )
%   x4   ∈ [-1.89747e+06, 1.89747e+06 ]   (range: 3.79495e+06 )
%   x5   ∈ [-3.26927e+06, 3.26927e+06 ]   (range: 6.53854e+06 )
%   x6   ∈ [-140.085    , 140.085     ]   (range: 280.169     )
%   x7   ∈ [-4051.89    , 4051.89     ]   (range: 8103.78     )
%   x8   ∈ [-2.2246e+06 , 2.2246e+06  ]   (range: 4.44921e+06 )
%   x9   ∈ [-2735.52    , 2735.52     ]   (range: 5471.05     )
%   x10  ∈ [-908.553    , 908.553     ]   (range: 1817.11     )
%
% Effective contrast ratio (max range / min range): 35859.4862157862
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = QV1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = QV1('bounds')  % Get bounds
%   info = QV1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 2;
lb_orig = [-5.12;-5.12;-5.12;-5.12;-5.12;-5.12;-5.12;-5.12;-5.12;-5.12];
ub_orig = [5.12;5.12;5.12;5.12;5.12;5.12;5.12;5.12;5.12;5.12];
lb_work = [-2941.974126920424;-1111743.764247247;-5023361.729874496;-1897473.975996159;-3269268.536875975;-140.0845985256502;-4051.887849263263;-2224602.612560095;-2735.524542452869;-908.5527116876864];
ub_work = [2941.974126920424;1111743.764247247;5023361.729874496;1897473.975996159;3269268.536875975;140.0845985256502;4051.887849263263;2224602.612560095;2735.524542452869;908.5527116876864];
scale_factors = [574.6043216641453;217137.4539545405;981125.3378661125;370600.3859367497;638529.0111085889;27.36027314954105;791.3843455592311;434492.6977656436;534.282137197826;177.4517015015012];
contrast_ratio = 35859.4862157862;

if nargin == 0
    info.name = mfilename;
    info.problem = 'QV1';
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
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'QV1: Quagliarella-Vicini. No closed-form PF. Ref: Huband et al. (2006).';
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
    error('Input x must have 10 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = QV1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to QV1_orig)
% -------------------------------------------------------------------------
function f = QV1_orig(x)
% QV1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example QV1, see the previous cited paper for the original reference.
%
%   In the original reference the number of variables was n=16. 
%   We selected n=10 as default.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
% Problem characteristics:
% - Number of variables: 10
% - Number of objectives: 2
%   Bounds: x1 in [-5.12,5.12], x2 in [-5.12,5.12], x3 in [-5.12,5.12], x4 in [-5.12,5.12], x5 in [-5.12,5.12], x6 in [-5.12,5.12], x7 in [-5.12,5.12], x8 in [-5.12,5.12], x9 in [-5.12,5.12], x10 in [-5.12,5.12]
%
%
%   Input: x is a 10-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
pi = 4*atan(1);
n = 10;

% Função objetivo 1
sum1 = 0;
for i = 1:n
    sum1 = sum1 + (x(i)^2 - 10*cos(2*pi*x(i)) + 10);
end
f1 = (sum1/n)^0.25;

% Função objetivo 2
sum2 = 0;
for i = 1:n
    sum2 = sum2 + ((x(i)-1.5)^2 - 10*cos(2*pi*(x(i)-1.5)) + 10);
end
f2 = (sum2/n)^0.25;

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

