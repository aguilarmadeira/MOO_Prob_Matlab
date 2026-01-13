# MOO Benchmark Problems for MATLAB

A comprehensive collection of **multiobjective optimization (MOO)** test problems in MATLAB format, designed for benchmarking derivative-free algorithms.

[![License: MIT](https://img.shields.io/badge/Code-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![License: CC BY 4.0](https://img.shields.io/badge/Data-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

## Overview

This repository provides MATLAB implementations for benchmarking multiobjective derivative-free optimization algorithms:

- **108 test problems** from ZDT, DTLZ, WFG, MOP, Lovison, Jin, and other families
- **Variable dimensions** n ∈ {1, 2, 3, 4, 7, 8, 10, 12, 22, 30}
- **Multiple objectives** m ∈ {2, 3, 4, 5}
- **Scaled problem variants** for testing algorithm robustness under heterogeneous variable scales
- **Self-contained functions** with flexible API

## Repository Structure

```
MOO_Prob_Matlab/
├── README.md                     # This file
├── LICENSE.md                    # Dual license (MIT + CC-BY 4.0)
├── CITATION.cff                  # Citation metadata
├── problems/                     # Original test problems
│   ├── README.md
│   └── problems_matlab/          # 108 MATLAB implementations
│       ├── BK1.m
│       ├── ZDT1.m
│       └── ...
└── problems_scaled/              # Scaled problem variants
    ├── README.md
    ├── baseline_1/               # κ = 1 (no scaling)
    ├── progressive_1e6/          # κ = 10⁶
    ├── extreme_1e8/              # κ = 10⁸
    ├── spatial_thermal_9e4/      # κ ≈ 9×10⁴
    ├── sobol_oscillatory_1e6/    # κ = 10⁶
    ├── sobol_digit_oscillatory_1e8/  # κ = 10⁸
    └── halton_oscillatory_1e6/   # κ = 10⁶
```

## Quick Start

### Original Problems

```matlab
% Add path
addpath('problems/problems_matlab');

% Evaluate ZDT1
x = rand(30, 1);
F = ZDT1(x);
fprintf('F = [%.4f, %.4f]\n', F(1), F(2));
```

### Scaled Problems (Self-Contained)

Each scaled problem is fully autonomous with a flexible API:

```matlab
% Add path to a scaling strategy
addpath('problems_scaled/extreme_1e8');

% Get problem information
info = CAM1();
fprintf('Problem: %s, n=%d, m=%d\n', info.problem, info.n, info.m);
fprintf('Strategy: %s, κ = %.0e\n', info.strategy, info.kappa);

% Get working bounds
[lb, ub] = CAM1('bounds');

% Evaluate at a point
x = lb + rand(info.n, 1) .* (ub - lb);
F = CAM1(x);
```

## Test Problems

The benchmark includes 108 problems organized by family:

| Family | Problems | n | m | Description |
|--------|----------|---|---|-------------|
| **ZDT** | ZDT1–ZDT6, variants | 10–30 | 2 | Standard bi-objective suite |
| **DTLZ** | DTLZ1–DTLZ6, variants | 2–22 | 2–5 | Scalable many-objective |
| **WFG** | I1–I5 | 8 | 3 | Walking Fish Group |
| **MOP** | MOP1–MOP7 | 1–4 | 2–3 | Classic test functions |
| **Deb** | Deb41, Deb53, Deb213, ... | 2 | 2 | Deb's test problems |
| **Lovison** | lovison1–lovison6 | 2–3 | 2–3 | Lovison benchmark |
| **Jin** | Jin1–Jin4 | 2 | 2 | Jin test functions |
| **Others** | BK1, Fonseca, Kursawe, ... | 1–10 | 2–4 | Miscellaneous classics |

See [`problems/README.md`](problems/README.md) for complete specifications.

## Scaling Strategies

For testing algorithm robustness under heterogeneous variable scales:

| Strategy | Contrast (κ) | Description |
|----------|--------------|-------------|
| `baseline_1` | 1 | No scaling (original bounds) |
| `progressive_1e6` | 10⁶ | Cyclic geometric pattern |
| `extreme_1e8` | 10⁸ | Binary partition (worst-case) |
| `spatial_thermal_9e4` | ≈9×10⁴ | Multiphysics-inspired |
| `sobol_oscillatory_1e6` | 10⁶ | Continuous quasi-random |
| `sobol_digit_oscillatory_1e8` | 10⁸ | Binary quasi-random |
| `halton_oscillatory_1e6` | 10⁶ | Alternative QMC sequence |

See [`problems_scaled/README.md`](problems_scaled/README.md) for details.

## Citation

If you use this benchmark suite, please cite:

```bibtex
@misc{madeira2026moobenchmark,
  author       = {Madeira, Jos{\'e} F. Aguilar},
  title        = {{MOO} Benchmark Problems for {MATLAB}: Test Functions 
                  for Multiobjective Optimization},
  year         = {2026},
  publisher    = {GitHub},
  url          = {https://github.com/aguilarmadeira/MOO_Prob_Matlab},
  note         = {Version 1.0.0}
}
```

### Related Publications

- **DMS (Original)**: Custódio, A.L., Madeira, J.F.A., Vaz, A.I.F., Vicente, L.N. (2011). Direct Multisearch for Multiobjective Optimization. *SIAM J. Optim.* 21(3), 1109–1140. [DOI:10.1137/10079731X](https://doi.org/10.1137/10079731X)

- **DMS-SI**: Madeira, J.F.A. (2025). DMS-SI: Direct Multisearch – A Scale-Invariant Approach for Multiobjective Optimization. (submitted)

## License

This repository uses a **dual license**:

| Component | License | Files |
|-----------|---------|-------|
| Source code | [MIT](https://opensource.org/licenses/MIT) | `.m` files |
| Documentation | [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/) | `.md` files |

See [LICENSE.md](LICENSE.md) for details.

## Acknowledgments

This work was supported by Fundação para a Ciência e a Tecnologia (FCT) through LAETA (project [UID/50022/2025](https://doi.org/10.54499/UID/50022/2025)).

The original AMPL formulations were developed for the DMS study and are available at the [FCT NOVA Problems Collections page](https://docentes.fct.unl.pt/algb/pages/problems-collections). The MATLAB conversions were carefully verified against the original specifications.

## Contact

**José F. Aguilar Madeira**  
IDMEC, Instituto Superior Técnico, Universidade de Lisboa  
ISEL, Instituto Politécnico de Lisboa  
Email: aguilarmadeira@tecnico.ulisboa.pt  
ORCID: [0000-0001-9523-3808](https://orcid.org/0000-0001-9523-3808)
