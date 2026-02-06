function varargout = QV1(varargin)
%QV1  QV1 (n=10, m=2) test problem (heterogeneous WORK-space wrapper).
%
% INPUT SPACE (SOBOL_DIGIT_OSCILLATORY HETEROGENEITY):
%
%   x1   ∈ [0           , 5742.21     ]   (range: 5742.21     )
%   x2   ∈ [0           , 2.16432e+07 ]   (range: 2.16432e+07 )
%   x3   ∈ [0           , 9.81108e+07 ]   (range: 9.81108e+07 )
%   x4   ∈ [0           , 3.70033e+07 ]   (range: 3.70033e+07 )
%   x5   ∈ [0           , 6.38203e+07 ]   (range: 6.38203e+07 )
%   x6   ∈ [0           , 264.84      ]   (range: 264.84      )
%   x7   ∈ [0           , 7911.96     ]   (range: 7911.96     )
%   x8   ∈ [0           , 4.33983e+07 ]   (range: 4.33983e+07 )
%   x9   ∈ [0           , 5338.63     ]   (range: 5338.63     )
%   x10  ∈ [0           , 1767.11     ]   (range: 1767.11     )
%
% Effective contrast ratio (max range / min range): 370452.93399927
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
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
lb_orig = [0;0;0;0;0;0;0;0;0;0];
ub_orig = [1;1;1;1;1;1;1;1;1;1];
lb_work = [0;0;0;0;0;0;0;0;0;0];
ub_work = [5742.210823142932;21643217.23815266;98110833.36659919;37003335.92574134;63820336.1569047;264.8402114336947;7911.964035282034;43398323.17275946;5338.62571555662;1767.106669983495];
scale_factors = [5742.210823142932;21643217.23815266;98110833.36659919;37003335.92574134;63820336.1569047;264.8402114336947;7911.964035282034;43398323.17275946;5338.62571555662;1767.106669983495];
contrast_ratio = 370452.93399927;

if nargin == 0
    info.name = mfilename;
    info.problem = 'QV1';
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
    info.pareto_note = 'QV1: Quagliarella-Vicini. No closed-form PF. Ref: Huband et al. (2006).';
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
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
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

