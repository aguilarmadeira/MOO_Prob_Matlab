function f = MHHM2(x)
% MHHM2 function
%
%   As described by Huband et al. in "A review of multiobjective test problems
%   and a scalable test problem toolkit", IEEE Transactions on Evolutionary 
%   Computing 10(5): 477-506, 2006.
%
%   Example MHHM2, see the previous cited paper for the original reference.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.
% 
n = length(x);
if n ~= 2
    error('MHHM2 requires exactly 2 variables, %d provided', n);
end

% Objective functions
f = zeros(3, 1);
f(1) = (x(1) - 0.8)^2 + (x(2) - 0.6)^2;
f(2) = (x(1) - 0.85)^2 + (x(2) - 0.7)^2;
f(3) = (x(1) - 0.9)^2 + (x(2) - 0.6)^2;

end
