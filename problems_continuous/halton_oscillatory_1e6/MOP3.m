function varargout = MOP3(varargin)
%MOP3  MOP3 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (HALTON_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [-1.57237e+06, 1.57237e+06 ]   (range: 3.14473e+06 )
%   x2   ∈ [-787.754    , 787.754     ]   (range: 1575.51     )
%
% Effective contrast ratio (max range / min range): 1996.011964107677
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = MOP3(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = MOP3('bounds')  % Get bounds
%   info = MOP3()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [-3.141592653589793;-3.141592653589793];
ub_orig = [3.141592653589793;3.141592653589793];
lb_work = [-1572367.123121691;-787.7543578876406];
ub_work = [1572367.123121691;787.7543578876406];
scale_factors = [500500;250.75];
contrast_ratio = 1996.011964107677;

if nargin == 0
    info.name = mfilename;
    info.problem = 'MOP3';
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
    info.pareto_note = 'MOP3: No simple analytical PF. Ref: Huband et al. (2006).';
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
    error('Input x must have 2 components.');
end
range = ub_work - lb_work;
range(range == 0) = 1;
t = (x - lb_work)./range;
t = max(0, min(1, t));
x_orig = lb_orig + t.*(ub_orig - lb_orig);
F = MOP3_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to MOP3_orig)
% -------------------------------------------------------------------------
function f = MOP3_orig(x)
% MOP3 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MOP3, Van Valedhuizen's test suit.
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
% - Number of variables: 2
% - Number of objectives: 2
%   Bounds: x1 in [-3.14159265359,3.14159265359], x2 in [-3.14159265359,3.14159265359]
%
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Parâmetros
pi = 4*atan(1);
A1 = 0.5*sin(1) - 2*cos(1) + sin(2) - 1.5*cos(2);
A2 = 1.5*sin(1) - cos(1) + 2*sin(2) - 0.5*cos(2);

% Variáveis adicionais
B1 = 0.5*sin(x(1)) - 2*cos(x(1)) + sin(x(2)) - 1.5*cos(x(2));
B2 = 1.5*sin(x(1)) - cos(x(1)) + 2*sin(x(2)) - 0.5*cos(x(2));

% Função objetivo 1
f1 = -(-1 - (A1-B1)^2 - (A2-B2)^2);

% Função objetivo 2
f2 = -(-(x(1)+3)^2 - (x(2)+1)^2);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

