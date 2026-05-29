function varargout = lovison1(varargin)
%LOVISON1  lovison1 (n=2, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (EXTREME HETEROGENEITY):
%
%   x1   ∈ [0           , 3           ]   (range: 3           )
%   x2   ∈ [0           , 3e+08       ]   (range: 3e+08       )
%
% Effective contrast ratio (max range / min range): 100000000
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = lovison1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = lovison1('bounds')  % Get bounds
%   info = lovison1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 2;
mloc = 2;
lb_orig = [0;0];
ub_orig = [3;3];
lb_work = [0;0];
ub_work = [3;300000000];
scale_factors = [1;100000000];
contrast_ratio = 100000000;

if nargin == 0
    info.name = mfilename;
    info.problem = 'lovison1';
    info.source = 'MOModels_Matlab';
    info.dimension = nloc;
    info.n = nloc; info.m = mloc;
    info.type = 'MOO';
    info.strategy = 'extreme';
    info.kappa = 100000000;
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
    info.pareto_note = 'lovison1: No analytical PF documented. Ref: Lovison (2010).';
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
F = lovison1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to lovison1_orig)
% -------------------------------------------------------------------------
function f = lovison1_orig(x)
% LOVISON1 function
%
%   As described by A. Lovison in "A synthetic approach to multiobjective
%   optimization", arxiv Item: http://arxiv.org/abs/1002.0093.
%
%   Example 1.
%
%   In the above paper/papers the variables bounds were not set.
%   We considered 0<=x[i]<=3, i=1,2.
%
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a 2-dimensional vector
%   Output: f is a 2-dimensional vector with the function values
%   Output: c is a vector of constraints (empty for this problem)

% Nota: Este problema é originalmente de maximização, 
% mas para manter a consistência com a interface da coleção DMS,
% convertemos para minimização multiplicando por -1.

% Função objetivo 1
%
%   Bounds: x1 in [0,3], x2 in [0,3]
%
f1 = -(-1.05*x(1)^2 - 0.98*x(2)^2);

% Função objetivo 2
f2 = -(-0.99*(x(1)-3)^2 - 1.03*(x(2)-2.5)^2);

% Vetor de funções objetivo
f = [f1; f2];

% Não há restrições de desigualdade para este problema

end

