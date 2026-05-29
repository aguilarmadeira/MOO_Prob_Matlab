function varargout = MOP2(varargin)
%MOP2  MOP2 (n=4, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-597156     , 597156      ]   (range: 1.19431e+06 )
%   x2   ∈ [-2595.16    , 2595.16     ]   (range: 5190.31     )
%   x3   ∈ [-1.59616e+06, 1.59616e+06 ]   (range: 3.19231e+06 )
%   x4   ∈ [-3594.16    , 3594.16     ]   (range: 7188.31     )
%
% Effective contrast ratio (max range / min range): 615.0520801974833
%
% Pareto information:
%   Pareto front: KNOWN (concave)
%   PF expression: Same structure as Fonseca (n=4)
%   Ideal point: [0 0]
%   Nadir point: [1 1]
%   Pareto set: x_i equal, in [-1/sqrt(n), 1/sqrt(n)]
%
% USAGE:
%   F = MOP2(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = MOP2('bounds')  % Get bounds
%   info = MOP2()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 4;
mloc = 2;
lb_orig = [-4;-4;-4;-4];
ub_orig = [4;4;4;4];
lb_work = [-597156.25;-2595.15625;-1596156.25;-3594.15625];
ub_work = [597156.25;2595.15625;1596156.25;3594.15625];
scale_factors = [149289.0625;648.7890625;399039.0625;898.5390625];
contrast_ratio = 615.0520801974833;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP2';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'sobol_oscillatory';
    info.kappa = 1000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.pareto_front_known = true;
    info.pf_type = 'concave';
    info.pf_expression = 'Same structure as Fonseca (n=4)';
    info.pareto_set_known = true;
    info.ps_expression = 'x_i equal, in [-1/sqrt(n), 1/sqrt(n)]';
    info.ideal_point = [0;0];
    info.nadir_point = [1;1];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [1.1;1.1];
    info.pareto_note = 'MOP2: Same structure as Fonseca (n=4). Ref: Huband et al. (2006).';
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
    error('Input x must have 4 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP2_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP2_orig)
% -------------------------------------------------------------------------
function f = MOP2_orig(x)
% MOP2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP2, Van Valedhuizen's test suit.
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
% - Number of variables: 4
% - Number of objectives: 2
%   Bounds: x1 in [-4,4], x2 in [-4,4], x3 in [-4,4], x4 in [-4,4]
%
%
%   Input: x is a 4-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Número de variáveis
n = 4;

% Função objetivo 1
sum1 = 0;
for i = 1:n
    sum1 = sum1 + (x(i) - 1/sqrt(n))^2;
end
f1 = 1 - exp(-sum1);

% Função objetivo 2
sum2 = 0;
for i = 1:n
    sum2 = sum2 + (x(i) + 1/sqrt(n))^2;
end
f2 = 1 - exp(-sum2);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

