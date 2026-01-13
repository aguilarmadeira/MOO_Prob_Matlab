# Test Problems

This directory contains MATLAB implementations of 108 bound-constrained test problems for multiobjective derivative-free optimization.

## Directory Structure

```
problems/
├── README.md              # This file
└── problems_matlab/       # 108 MATLAB function files
    ├── BK1.m
    ├── CAM1.m
    ├── ZDT1.m
    └── ...
```

## Problem List

| # | Problem | n | m | Bounds | Reference |
|---|---------|---|---|--------|-----------|
| 1 | BK1 | 2 | 2 | [−5, 10]² | Huband et al. 2006 |
| 2 | CAM1 | 2 | 2 | [0.1, 1]×[0, 1] | Deb 1999 |
| 3 | CAM2 | 2 | 2 | [0, 1]² | Deb 1999 |
| 4 | CL1 | 4 | 2 | problem-specific | Cheng & Li 1999 |
| 5 | Deb41 | 2 | 2 | [0, 1]² | Deb 1999 |
| 6 | Deb53 | 2 | 2 | [0, 1]² | Deb 1999 |
| 7 | Deb213 | 2 | 2 | [0, 1]² | Deb 1999 |
| 8 | Deb512a | 2 | 2 | [0, 1]² | Deb 1999 |
| 9 | Deb512b | 2 | 2 | [0, 1]² | Deb 1999 |
| 10 | Deb512c | 2 | 2 | [0, 1]² | Deb 1999 |
| 11 | Deb513 | 2 | 2 | [0, 1]² | Deb 1999 |
| 12 | Deb521a | 2 | 2 | [0, 1]² | Deb 1999 |
| 13 | Deb521b | 2 | 2 | [0, 1]² | Deb 1999 |
| 14 | DG01 | 1 | 2 | [−10, 13] | Huband et al. 2006 |
| 15 | DG02 | 1 | 2 | [−9, 9] | Huband et al. 2006 |
| 16 | DPAM1 | 10 | 2 | [−0.3, 0.3]¹⁰ | Huband et al. 2006 |
| 17 | DTLZ1 | 7 | 3 | [0, 1]⁷ | Deb et al. 2002 |
| 18 | DTLZ1n2 | 2 | 2 | [0, 1]² | Deb et al. 2002 |
| 19 | DTLZ1_4 | 7 | 4 | [0, 1]⁷ | Deb et al. 2002 |
| 20 | DTLZ1_5 | 7 | 5 | [0, 1]⁷ | Deb et al. 2002 |
| 21 | DTLZ2 | 12 | 3 | [0, 1]¹² | Deb et al. 2002 |
| 22 | DTLZ2n2 | 2 | 2 | [0, 1]² | Deb et al. 2002 |
| 23 | DTLZ3 | 12 | 3 | [0, 1]¹² | Deb et al. 2002 |
| 24 | DTLZ3n2 | 2 | 2 | [0, 1]² | Deb et al. 2002 |
| 25 | DTLZ3_4 | 12 | 4 | [0, 1]¹² | Deb et al. 2002 |
| 26 | DTLZ3_5 | 12 | 5 | [0, 1]¹² | Deb et al. 2002 |
| 27 | DTLZ4 | 12 | 3 | [0, 1]¹² | Deb et al. 2002 |
| 28 | DTLZ4n2 | 2 | 2 | [0, 1]² | Deb et al. 2002 |
| 29 | DTLZ5 | 12 | 3 | [0, 1]¹² | Deb et al. 2002 |
| 30 | DTLZ5n2 | 2 | 2 | [0, 1]² | Deb et al. 2002 |
| 31 | DTLZ6 | 22 | 3 | [0, 1]²² | Deb et al. 2002 |
| 32 | DTLZ6n2 | 2 | 2 | [0, 1]² | Deb et al. 2002 |
| 33 | ex005 | 2 | 2 | [−1, 2]² | Hwang & Masud 1979 |
| 34 | Far1 | 2 | 2 | [−1, 1]² | Huband et al. 2006 |
| 35 | FES1 | 10 | 2 | [0, 1]¹⁰ | Huband et al. 2006 |
| 36 | FES2 | 10 | 3 | [0, 1]¹⁰ | Huband et al. 2006 |
| 37 | FES3 | 10 | 4 | [0, 1]¹⁰ | Huband et al. 2006 |
| 38 | Fonseca | 2 | 2 | [−4, 4]² | Fonseca & Fleming 1998 |
| 39 | I1 | 8 | 3 | [0, 1]⁸ | Huband et al. 2005 |
| 40 | I2 | 8 | 3 | [0, 1]⁸ | Huband et al. 2005 |
| 41 | I3 | 8 | 3 | [0, 1]⁸ | Huband et al. 2005 |
| 42 | I4 | 8 | 3 | [0, 1]⁸ | Huband et al. 2005 |
| 43 | I5 | 8 | 3 | [0, 1]⁸ | Huband et al. 2005 |
| 44 | IKK1 | 2 | 3 | [−50, 50]² | Huband et al. 2006 |
| 45 | IM1 | 2 | 2 | [1, 4]×[1, 2] | Huband et al. 2006 |
| 46 | Jin1 | 2 | 2 | [0, 1]² | Jin et al. 2001 |
| 47 | Jin2 | 2 | 2 | [0, 1]² | Jin et al. 2001 |
| 48 | Jin3 | 2 | 2 | [0, 1]² | Jin et al. 2001 |
| 49 | Jin4 | 2 | 2 | [0, 1]² | Jin et al. 2001 |
| 50 | Kursawe | 3 | 2 | [−5, 5]³ | Kursawe 1990 |
| 51 | L1ZDT4 | 10 | 2 | [0, 1]×[−5, 5]⁹ | Deb et al. 2006 |
| 52 | L2ZDT1 | 30 | 2 | [0, 1]³⁰ | Deb et al. 2006 |
| 53 | L2ZDT2 | 30 | 2 | [0, 1]³⁰ | Deb et al. 2006 |
| 54 | L2ZDT3 | 30 | 2 | [0, 1]³⁰ | Deb et al. 2006 |
| 55 | L2ZDT4 | 30 | 2 | [0, 1]×[−5, 5]²⁹ | Deb et al. 2006 |
| 56 | L2ZDT6 | 10 | 2 | [0, 1]¹⁰ | Deb et al. 2006 |
| 57 | L3ZDT1 | 30 | 2 | [0, 1]³⁰ | Deb et al. 2006 |
| 58 | L3ZDT2 | 30 | 2 | [0, 1]³⁰ | Deb et al. 2006 |
| 59 | L3ZDT3 | 30 | 2 | [0, 1]³⁰ | Deb et al. 2006 |
| 60 | L3ZDT4 | 30 | 2 | [0, 1]×[−5, 5]²⁹ | Deb et al. 2006 |
| 61 | L3ZDT6 | 10 | 2 | [0, 1]¹⁰ | Deb et al. 2006 |
| 62 | LE1 | 2 | 2 | problem-specific | Huband et al. 2006 |
| 63 | lovison1 | 2 | 2 | [0, 3]² | Lovison 2010 |
| 64 | lovison2 | 2 | 2 | [−0.5, 0]² | Lovison 2010 |
| 65 | lovison3 | 2 | 2 | [0, 6]² | Lovison 2010 |
| 66 | lovison4 | 2 | 2 | [0, 6]² | Lovison 2010 |
| 67 | lovison5 | 3 | 3 | [−1, 4]³ | Lovison 2010 |
| 68 | lovison6 | 3 | 3 | [−1, 4]³ | Lovison 2010 |
| 69 | LRS1 | 2 | 2 | [−50, 50]² | Huband et al. 2006 |
| 70 | MHHM1 | 1 | 3 | [0, 1] | Huband et al. 2006 |
| 71 | MHHM2 | 2 | 3 | [0, 1]² | Huband et al. 2006 |
| 72 | MLF1 | 1 | 2 | [0, 20] | Huband et al. 2006 |
| 73 | MLF2 | 2 | 2 | [−2, 2]² | Huband et al. 2006 |
| 74 | MOP1 | 1 | 2 | [−10⁵, 10⁵] | Huband et al. 2006 |
| 75 | MOP2 | 4 | 2 | [−4, 4]⁴ | Huband et al. 2006 |
| 76 | MOP3 | 2 | 2 | [−π, π]² | Huband et al. 2006 |
| 77 | MOP4 | 3 | 2 | [−5, 5]³ | Huband et al. 2006 |
| 78 | MOP5 | 2 | 3 | [−30, 30]² | Huband et al. 2006 |
| 79 | MOP6 | 2 | 2 | [0, 1]² | Huband et al. 2006 |
| 80 | MOP7 | 2 | 3 | [−400, 400]² | Huband et al. 2006 |
| 81 | OKA1 | 2 | 2 | problem-specific | Okabe et al. 2004 |
| 82 | OKA2 | 3 | 2 | problem-specific | Okabe et al. 2004 |
| 83 | QV1 | 10 | 2 | [−5.12, 5.12]¹⁰ | Huband et al. 2006 |
| 84 | Sch1 | 1 | 2 | [0, 5] | Huband et al. 2006 |
| 85 | SK1 | 1 | 2 | [−10, 10] | Huband et al. 2006 |
| 86 | SK2 | 4 | 2 | [−10, 10]⁴ | Huband et al. 2006 |
| 87 | SP1 | 2 | 2 | [−1, 5]² | Huband et al. 2006 |
| 88 | SSFYY1 | 2 | 2 | [−100, 100]² | Huband et al. 2006 |
| 89 | SSFYY2 | 1 | 2 | [−100, 100] | Huband et al. 2006 |
| 90 | TKLY1 | 4 | 2 | [0.1, 1]⁴ | Huband et al. 2006 |
| 91 | VFM1 | 2 | 3 | [−2, 2]² | Huband et al. 2006 |
| 92 | VU1 | 2 | 2 | [−3, 3]² | Huband et al. 2006 |
| 93 | VU2 | 2 | 2 | [−3, 3]² | Huband et al. 2006 |
| 94 | ZDT1 | 30 | 2 | [0, 1]³⁰ | Zitzler et al. 2000 |
| 95 | ZDT2 | 30 | 2 | [0, 1]³⁰ | Zitzler et al. 2000 |
| 96 | ZDT3 | 30 | 2 | [0, 1]³⁰ | Zitzler et al. 2000 |
| 97 | ZDT4 | 10 | 2 | [0, 1]×[−5, 5]⁹ | Zitzler et al. 2000 |
| 98 | ZDT6 | 10 | 2 | [0, 1]¹⁰ | Zitzler et al. 2000 |
| 99 | ZLT1 | 10 | 3 | [−1000, 1000]¹⁰ | Huband et al. 2006 |
| 100 | Schaffer | 1 | 2 | [−10, 10] | Schaffer 1985 |
| 101 | Poloni | 2 | 2 | [−π, π]² | Poloni et al. 2000 |
| 102 | Binh1 | 2 | 2 | [0, 5]² | Binh & Korn 1997 |
| 103 | Binh2 | 2 | 2 | [0, 5]×[0, 3] | Binh & Korn 1997 |
| 104 | Viennet2 | 2 | 3 | [−4, 4]² | Viennet et al. 1996 |
| 105 | Viennet3 | 2 | 3 | [−3, 3]² | Viennet et al. 1996 |
| 106 | Viennet4 | 2 | 3 | [−4, 4]² | Viennet et al. 1996 |
| 107 | Osyczka | 6 | 2 | problem-specific | Osyczka & Kundu 1995 |
| 108 | Constr | 2 | 2 | [0.1, 1]×[0, 5] | Constrained test |

## Usage

Each problem is implemented as a MATLAB function:

```matlab
% Add path
addpath('problems_matlab');

% Example: BK1 function
x = [0; 0];  % x is a column vector of dimension n=2
F = BK1(x);  % F is a column vector of m=2 objective values
fprintf('BK1([0;0]) = [%.4f, %.4f]\n', F(1), F(2));
```

## Function Interface

All problem functions follow the same interface:

```matlab
function F = problem_name(x)
% PROBLEM_NAME  Evaluates the multiobjective test function
%   F = problem_name(x) returns the objective values at x
%
% Input:
%   x - column vector of dimension n
%
% Output:
%   F - column vector of m objective values
```

## Source

These problems were converted from AMPL format to MATLAB. The original AMPL formulations are available at:
- [FCT NOVA Problems Collections](https://docentes.fct.unl.pt/algb/pages/problems-collections)

## References

1. Custódio, A.L., Madeira, J.F.A., Vaz, A.I.F., Vicente, L.N. (2011). Direct Multisearch for Multiobjective Optimization. *SIAM J. Optim.* 21(3), 1109–1140.

2. Huband, S., Hingston, P., Barone, L., While, L. (2006). A review of multiobjective test problems and a scalable test problem toolkit. *IEEE Trans. Evol. Comput.* 10(5), 477–506.

3. Deb, K., Thiele, L., Laumanns, M., Zitzler, E. (2002). Scalable multi-objective optimization test problems. *CEC 2002*, 825–830.

4. Zitzler, E., Deb, K., Thiele, L. (2000). Comparison of multiobjective evolutionary algorithms: Empirical results. *Evol. Comput.* 8(2), 173–195.

5. Lovison, A. (2010). Singular continuation: Generating piecewise linear approximations to Pareto sets via global analysis. *SIAM J. Optim.* 21(2), 463–490.
