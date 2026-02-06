function f = L1ZDT4(x)
% L1ZDT4 - Linkage L1 variant of ZDT4
%
% As described by K. Deb, A. Sinha and S. Kukkonen in "Multi-objective
% test problems, linkages, and evolutionary methodologies", GECCO'06:
% Proceedings of the 8th Annual Conference on Genetic and Evolutionary
% Computation, 1141-1148, 2006.
%
% Example T4 (ZDT4), with linkage L1.
%
%   This file implements a multiobjective test problem originally
%   formulated in AMPL and used in
%    A. L. Custodio, J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente,
%   "Direct Multisearch for Multiobjective Optimization", 2011.
%
%   This MATLAB file was written in 2025 by J. F. A. Madeira,
%   based on the original AMPL formulations.

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