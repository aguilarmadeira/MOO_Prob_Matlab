# Scaled Problem Variants

This directory contains **self-contained** scaled versions of the 108 MOO benchmark problems for testing algorithm robustness under heterogeneous variable scales.

## Overview

Scale heterogeneity across variables is a major challenge in derivative-free optimization. When design variables span vastly different numerical ranges (e.g., millimeters vs. megapascals), algorithms with fixed step sizes may explore some directions excessively while barely moving in others.

Each scaled problem is **fully autonomous**: it contains all necessary information (bounds, scaling factors, original function) embedded in a single `.m` file with a flexible API.

## Directory Structure

```
problems_scaled/
├── README.md
├── baseline_1/               # κ = 1 (no scaling, reference)
│   ├── BK1.m
│   ├── CAM1.m
│   └── ... (108 problems)
├── progressive_1e6/          # κ = 10⁶ (cyclic geometric)
├── extreme_1e8/              # κ = 10⁸ (binary partition)
├── spatial_thermal_9e4/      # κ ≈ 9×10⁴ (multiphysics)
├── sobol_oscillatory_1e6/    # κ = 10⁶ (quasi-random)
├── sobol_digit_oscillatory_1e8/  # κ = 10⁸ (quasi-random binary)
└── halton_oscillatory_1e6/   # κ = 10⁶ (Halton sequence)
```

## Scaling Strategies

### Category I: Systematic Geometric Scaling

| Strategy | Contrast (κ) | Pattern |
|----------|--------------|---------|
| `baseline_1` | 1 | No scaling (original bounds) |
| `progressive_1e6` | 10⁶ | Cyclic geometric: exponents cycle through {0, 1, 2, 3, −1, −2, −3} |
| `extreme_1e8` | 10⁸ | Binary partition: half variables at κ^(−1/2), half at κ^(1/2) |

### Category II: Quasi-Random Oscillatory Scaling

| Strategy | Contrast (κ) | Sequence |
|----------|--------------|----------|
| `sobol_oscillatory_1e6` | 10⁶ | Sobol low-discrepancy, continuous mapping |
| `sobol_digit_oscillatory_1e8` | 10⁸ | Sobol with digit-based binary assignment |
| `halton_oscillatory_1e6` | 10⁶ | Halton low-discrepancy sequence |

### Category III: Application-Inspired Scaling

| Strategy | Contrast (κ) | Motivation |
|----------|--------------|------------|
| `spatial_thermal_9e4` | ≈9×10⁴ | Multiphysics: spatial coordinates vs. thermal properties |

## Self-Contained API

Each scaled problem provides a flexible interface:

### Get Problem Information

```matlab
info = CAM1();
% Returns structure with:
%   info.name           - Function name
%   info.problem        - Original problem name
%   info.n              - Number of variables
%   info.m              - Number of objectives
%   info.strategy       - Scaling strategy name
%   info.kappa          - Target contrast ratio
%   info.contrast_ratio - Actual contrast ratio
%   info.lb_orig        - Original lower bounds
%   info.ub_orig        - Original upper bounds
%   info.lb_work        - Working (scaled) lower bounds
%   info.ub_work        - Working (scaled) upper bounds
%   info.scale_factors  - Per-variable scale factors
```

### Get Working Bounds

```matlab
[lb, ub] = CAM1('bounds');
% Returns:
%   lb - Lower bounds in working (scaled) coordinates
%   ub - Upper bounds in working (scaled) coordinates
```

### Evaluate Objective Functions

```matlab
F = CAM1(x);
% Input:
%   x - Point in working (scaled) coordinates
% Output:
%   F - Objective values (computed in original coordinates)
```

## Usage Example

```matlab
% Add path to a scaling strategy
addpath('problems_scaled/extreme_1e8');

% Get problem information
info = CAM1();
fprintf('Problem: %s\n', info.problem);
fprintf('Strategy: %s (κ = %.0e)\n', info.strategy, info.kappa);
fprintf('Dimension: n = %d, m = %d\n', info.n, info.m);

% Get working bounds
[lb, ub] = CAM1('bounds');
fprintf('Working bounds:\n');
for i = 1:info.n
    fprintf('  x%d: [%.2e, %.2e]\n', i, lb(i), ub(i));
end

% Evaluate at random point
x = lb + rand(info.n, 1) .* (ub - lb);
F = CAM1(x);
fprintf('F(x) = [%.4f, %.4f]\n', F(1), F(2));
```

## Running All Problems in a Strategy

```matlab
% Add path
addpath('problems_scaled/progressive_1e6');

% List all .m files
files = dir('problems_scaled/progressive_1e6/*.m');

for i = 1:length(files)
    % Get function name (without .m extension)
    fname = files(i).name(1:end-2);
    
    % Get function handle
    fh = str2func(fname);
    
    % Get problem info
    info = fh();
    
    % Get bounds and evaluate at center
    [lb, ub] = fh('bounds');
    x0 = (lb + ub) / 2;
    F0 = fh(x0);
    
    fprintf('%3d. %-12s n=%2d m=%d κ=%.0e F0=[%.2e, %.2e]\n', ...
        i, info.problem, info.n, info.m, info.kappa, F0(1), F0(2));
end
```

## Internal Coordinate Mapping

Each scaled problem performs the following coordinate transformation internally:

```matlab
% Normalize to [0,1]
t = (x - lb_work) ./ (ub_work - lb_work);
t = max(0, min(1, t));  % Clip to [0,1]

% Map to original coordinates
x_orig = lb_orig + t .* (ub_orig - lb_orig);

% Evaluate original function
F = problem_orig(x_orig);
```

This ensures that:
1. The optimization problem is mathematically equivalent (same Pareto front)
2. The algorithm works in scaled coordinates (heterogeneous bounds)
3. Objective evaluation occurs in original coordinates

## Application to DMS-SI Testing

These scaled problems were used to evaluate the DMS-SI algorithm's robustness:

- **Baseline (κ = 1):** Establishes reference performance on well-scaled problems
- **Progressive (κ = 10⁶):** Tests moderate scale heterogeneity typical of engineering problems
- **Extreme (κ = 10⁸):** Stress-tests algorithm limits under severe heterogeneity
- **Spatial-thermal:** Mimics realistic multiphysics scenarios

Results show that DMS-SI, operating in normalized coordinates, maintains consistent performance across all strategies, while standard DMS degrades as κ increases.

## References

1. Madeira, J.F.A. (2025). DMS-SI: Direct Multisearch – A Scale-Invariant Approach for Multiobjective Optimization. (submitted)

2. Hansen, N., Auger, A., Finck, S., Ros, R. (2009). Real-parameter black-box optimization benchmarking 2009: Experimental setup. *GECCO Workshop on BBOB*.
