function varargout = QV1(varargin)
%QV1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: QV1
% Dimension: n = 10, objectives m = 2
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 370452.93399927
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = QV1();
%   [lb,ub] = QV1('bounds');
%   F = QV1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = QV1_orig(x_orig)

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
    info.n = nloc; info.m = mloc;
    info.strategy = 'sobol_digit_oscillatory';
    info.kappa = 100000000;
    info.lb_orig = lb_orig; info.ub_orig = ub_orig;
    info.lb_work = lb_work; info.ub_work = ub_work;
    info.scale_factors = scale_factors;
    info.contrast_ratio = contrast_ratio;
    info.warning = 'Bounds missing/incomplete in header; using canonical fallback [0,1]^n.';
    varargout{1} = info;
    return;
end

arg1 = varargin{1};
if ischar(arg1) && strcmpi(arg1,'bounds')
    varargout{1} = lb_work;
    if nargout >= 2, varargout{2} = ub_work; end
    return;
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
end

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

