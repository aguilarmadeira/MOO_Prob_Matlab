function varargout = ZLT1(varargin)
%ZLT1  Self-contained scaled MOO test problem.
%
% Wrapper/scaling formulation:
%   J. F. A. Madeira (2026)
%
% Problem: ZLT1
% Dimension: n = 10, objectives m = 3
% Strategy: sobol_digit_oscillatory (kappa = 100000000)
% Effective contrast: 56074.79409725023
% WARNING: Bounds missing/incomplete in header; using canonical fallback [0,1]^n.
%
% API:
%   info = ZLT1();
%   [lb,ub] = ZLT1('bounds');
%   F = ZLT1(x);
%
% Mapping:
%   t      = clip01((x - lb_work)./(ub_work - lb_work))
%   x_orig = lb_orig + t.*(ub_orig - lb_orig)
%   F      = ZLT1_orig(x_orig)

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
F = ZLT1_orig(x_orig);
varargout{1} = F(:);
end

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
%   This file is part of a collection of problems developed for
%   derivative-free multiobjective optimization in
%   A. L. Custódio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   Direct Multisearch for Multiobjective Optimization, 2010.
%
%   Written by the authors in June 1, 2010.
%   Adapted to MATLAB format in November 2025.
%
%   Input: x is a n-dimensional vector, where n = 10
%   Output: f is a M-dimensional vector (M=3) with the function values
%   Output: c is a vector of constraints (empty for this problem - bounds are
%          handled by the optimization algorithm)

% Parâmetros
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

