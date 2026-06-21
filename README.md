# MOO Benchmark Problems for MATLAB

Benchmark suites of **multiobjective optimization (MOO)** test problems in
MATLAB, for benchmarking derivative-free algorithms under controlled
**scale heterogeneity**, over both **continuous** and **mixed-variable**
decision spaces.

[![License: MIT](https://img.shields.io/badge/Code-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![License: CC BY 4.0](https://img.shields.io/badge/Data-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20783713.svg)](https://doi.org/10.5281/zenodo.20783713)

## Overview

This repository provides the base multiobjective problems together with two
parallel collections of self-contained MATLAB test problems, each comprising
**108 problems** instantiated under **8 scaling strategies**:

- **`problems/`** — the 108 base multiobjective problems (original Direct
  Multisearch formulations, converted to MATLAB) from which both scaled suites
  are derived. Included for provenance and traceability.
- **`problems_continuous/`** — heterogeneous-scale continuous problems.
  Each variable lives in a continuous interval; scale heterogeneity is
  applied across coordinates.
- **`problems_mixed/`** — heterogeneous mixed-variable problems. A subset
  of coordinates is converted to ordered discrete or categorical variables;
  scale heterogeneity is applied to the continuous block. The six mixed pairs reported in the DMS-SI-Mix study are flagged in `problems_mixed/INDEX.txt`.

Both scaled collections are derived from the same 108 base multiobjective
functions drawn from the ZDT, DTLZ, WFG, MOP, Lovison, Jin, Deb, and related
families, with dimensions n in {1, 2, 3, 4, 7, 8, 10, 12, 22, 30} and
objective counts m in {2, 3, 4, 5}.

Each generated problem is **self-contained**: it embeds the original problem
code and exposes a uniform runtime interface. The base problems are provided
in `problems/`; the scaling and type-conversion pipeline that produces the
per-strategy instances is not distributed, only its output is.

## Repository structure

```
MOO_Prob_Matlab/
├── README.md
├── LICENSE.md                       # dual license: MIT (.m) + CC-BY 4.0 (.md)
├── CITATION.cff
├── CHANGELOG.md
├── problems/                        # 108 base problems (original DMS, MATLAB)
│   ├── README.md
│   └── INDEX.txt
├── problems_continuous/
│   ├── README.md
│   ├── INDEX.txt
│   ├── add_strategy.m
│   ├── add_all_strategies.m
│   ├── baseline_1/                  # kappa = 1        (no scaling)
│   ├── moderate_1e4/                # kappa = 1e4
│   ├── progressive_1e6/             # kappa = 1e6      (cyclic geometric)
│   ├── extreme_1e8/                 # kappa = 1e8      (binary partition)
│   ├── spatial_thermal_9e4/         # kappa ≈ 9e4      (multiphysics-inspired)
│   ├── sobol_oscillatory_1e6/       # kappa = 1e6      (continuous QMC)
│   ├── sobol_digit_oscillatory_1e6/ # kappa = 1e6      (binary QMC)
│   └── halton_oscillatory_1e6/      # kappa = 1e6      (alternative QMC)
└── problems_mixed/
    ├── README.md
    ├── INDEX.txt
    ├── add_strategy.m
    ├── add_all_strategies.m
    ├── baseline_1/
    ├── moderate_1e4/
    ├── progressive_1e6/
    ├── extreme_1e8/
    ├── spatial_thermal_9e4/
    ├── sobol_oscillatory_1e6/
    ├── sobol_digit_oscillatory_1e6/
    └── halton_oscillatory_1e6/
```

Each strategy subfolder contains the same 108 problems instantiated at that
strategy's scaling. Continuous problem files are named `<problem>.m`;
mixed-variable problem files are named `<problem>_mix.m`.

## Scaling strategies

| Strategy                      | Contrast (kappa) | Description                   |
| ----------------------------- | ---------------- | ----------------------------- |
| `baseline`                    | 1                | No scaling (original bounds)  |
| `moderate`                    | 1e4              | Moderate uniform contrast     |
| `progressive`                 | 1e6              | Cyclic geometric pattern      |
| `extreme`                     | 1e8              | Binary partition (worst-case) |
| `spatial_thermal`             | ≈ 9e4            | Multiphysics-inspired         |
| `sobol_oscillatory`           | 1e6              | Continuous quasi-random       |
| `sobol_digit_oscillatory`     | 1e6              | Binary quasi-random           |
| `halton_oscillatory`          | 1e6              | Alternative QMC sequence      |

> **Note on `sobol_digit_oscillatory`.** In this multiobjective suite the
> digit-oscillatory contrast is **κ = 1e6**, matching the configuration used in
> the DMS-SI-Mix study. The single-objective companion suite
> [`DFO_Benchmark_Suite`](https://github.com/aguilarmadeira/DFO_Benchmark_Suite)
> uses **κ = 1e8** for the same strategy family; the two values are intentional
> and reflect the settings of their respective studies.

## Quick start

### Continuous problems

```matlab
% Add one continuous strategy to the path
addpath('problems_continuous/extreme_1e8');

% Metadata
info = CAM1();
fprintf('Problem: %s, n=%d, m=%d, strategy=%s, kappa=%.0e\n', ...
        info.problem, info.n, info.m, info.strategy, info.kappa);

% Working bounds and a sample evaluation
[lb, ub] = CAM1('bounds');
x = lb + rand(info.n, 1) .* (ub - lb);
F = CAM1(x);
```

To add every continuous strategy at once:

```matlab
run('problems_continuous/add_all_strategies.m');
```

### Mixed-variable problems

```matlab
% Add one mixed strategy to the path
addpath('problems_mixed/extreme_1e8');

% Metadata and mixed-domain specification
PB = ZDT1_mix();
PD = ZDT1_mix('ProblemData');
vt = ZDT1_mix('var_types');     % per-coordinate type: 'C' / 'D' / 'K'

% Evaluate at a mixed point: xcell is a 1-by-n cell, one entry per variable.
% Continuous entries are scalars; discrete/categorical entries are labels.
F = ZDT1_mix(xcell);
```

The mixed wrapper exposes the algorithm only to labels for discrete and
categorical variables; the numeric embedding is used internally during
decoding and evaluation.

### Base problems

```matlab
% Add the base problems to the path
addpath('problems');

info     = CAM1();              % metadata
[lb, ub] = CAM1('bounds');      % original (native) bounds
F        = CAM1(lb + rand(info.n,1).*(ub-lb));
```

## Citation

If you use these benchmark suites, please cite:

```bibtex
@software{Madeira_MOO_Prob_Matlab_2026,
  author    = {Madeira, J. F. A.},
  title     = {{MOO\_Prob\_Matlab}: Continuous and mixed-variable {MATLAB}
               benchmark suites for multiobjective optimization},
  year      = {2026},
  version   = {1.0.0},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.20783714},
  url       = {https://doi.org/10.5281/zenodo.20783714}
}
```

### Related publications

- **DMS-SI-Mix**: Madeira, J.F.A. (2026). *A Scale-Invariant Direct
  Multisearch Method for Mixed-Variable Multiobjective Optimization.*
  (under review).
- **DMS (original)**: Custódio, A.L., Madeira, J.F.A., Vaz, A.I.F.,
  Vicente, L.N. (2011). *Direct Multisearch for Multiobjective
  Optimization.* SIAM J. Optim. 21(3), 1109–1140.
  [DOI:10.1137/10079731X](https://doi.org/10.1137/10079731X)

## License

Dual license:

| Component     | License                                                   | Files       |
| ------------- | --------------------------------------------------------- | ----------- |
| Source code   | [MIT](https://opensource.org/licenses/MIT)                | `.m` files  |
| Documentation | [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) | `.md` files |

See [LICENSE.md](LICENSE.md).

## Acknowledgments

This work was supported by Fundação para a Ciência e a Tecnologia (FCT)
through LAETA (project UID/50022/2025).

The original AMPL formulations were developed for the DMS study and are
available at the FCT NOVA Problems Collections page; their verified MATLAB
conversions are provided in `problems/`.

## Contact

**J. F. A. Madeira**
IDMEC, Instituto Superior Técnico, Universidade de Lisboa
ISEL, Instituto Politécnico de Lisboa
Email: aguilarmadeira@tecnico.ulisboa.pt
ORCID: [0000-0001-9523-3808](https://orcid.org/0000-0001-9523-3808)
