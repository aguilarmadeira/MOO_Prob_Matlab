function varargout = ZLT1(varargin)
%ZLT1  ZLT1 (n=10, m=3) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 3783.89     ]   (range: 3783.89     )
%   x2   ∈ [0           , 9170.75     ]   (range: 9170.75     )
%   x3   ∈ [0           , 3.90392e+06 ]   (range: 3.90392e+06 )
%   x4   ∈ [0           , 5152.89     ]   (range: 5152.89     )
%   x5   ∈ [0           , 2.72928e+07 ]   (range: 2.72928e+07 )
%   x6   ∈ [0           , 8.11653e+07 ]   (range: 8.11653e+07 )
%   x7   ∈ [0           , 1758.02     ]   (range: 1758.02     )
%   x8   ∈ [0           , 6.51968e+07 ]   (range: 6.51968e+07 )
%   x9   ∈ [0           , 4620.19     ]   (range: 4620.19     )
%   x10  ∈ [0           , 9.85807e+07 ]   (range: 9.85807e+07 )
%
% Effective contrast ratio (max range / min range): 56074.79409725023
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% Pareto information:
%   - This is a multiobjective problem. Optimality is defined by Pareto dominance.
%   - No analytical Pareto front is documented for this problem.
%
% USAGE:
%   F = ZLT1(x)            % Evaluate objectives at point x (nD vector)
%   [lb, ub] = ZLT1('bounds')  % Get bounds
%   info = ZLT1()          % Get complete problem information
%
% Reference:
%   J. F. A. Madeira,
%   "Wrapper/scaling formulation for heterogeneous benchmarking in multiobjective optimization",
%   2026.
%
nloc = 10;
mloc = 3;
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [3783.889917278902;9170.753037344148;3903916.787406207;5152.890042163124;27292825.5594474;81165277.03557938;1758.020863409909;65196794.81352062;4620.191003155873;98580657.93438071];
scale_factors = [3783.889917278902;9170.753037344148;3903916.787406207;5152.890042163124;27292825.5594474;81165277.03557938;1758.020863409909;65196794.81352062;4620.191003155873;98580657.93438071];
contrast_ratio = 56074.79409725023;

if nargin == 0
    info.name = mfilename;
    info.problem = 'ZLT1';
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
    info.pareto_front_known = false;
    info.pf_type = 'unknown';
    info.pf_expression = '';
    info.pareto_set_known = false;
    info.ps_expression = '';
    info.ideal_point = [];
    info.nadir_point = [];
    info.quality_indicators = {'HV','IGD','Purity','Spread'};
    info.reference_point_default = [];  % No nadir known; let driver define.
    info.pareto_note = 'ZLT1: Tri-objective, no analytical PF. Ref: Huband et al. (2006).';
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
F = ZLT1_orig(x_orig);
varargout{1} = F(:);
return
end  % main wrapper function

% -------------------------------------------------------------------------
% Embedded original problem function (verbatim; only renamed to ZLT1_orig)
% -------------------------------------------------------------------------
function f = ZLT1_orig(x)
% ZLT1 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example ZLT1, see the previous cited paper for the original reference.
%
%   In the above paper the number of variables was set equal to 100. 
%   We selected n=10 as default.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
n = 10;  % número de variáveis
M = 3;   % número de funções objetivo

% Inicializar vetor de funções objetivo
f = zeros(M, 1);

% Cálculo das M funções objetivo
for m = 1:M
    % Termo principal: (x_m - 1)^2
    f(m) = (x(m) - 1)^2;
    
    % Somar os quadrados de todas as outras variáveis
    for i = 1:n
        if i ~= m
            f(m) = f(m) + x(i)^2;
        end
    end
end

% Não há restrições de desigualdade para este problema

end

