# continuous benchmark suite

Heterogeneous-scale **continuous** multiobjective optimization problems:
108 problems, each instantiated under 8 scaling strategies.

Each strategy subfolder contains 108 self-contained `<problem>.m` files.

## Strategies

| Folder                          | Contrast (kappa) |
| ------------------------------- | ---------------- |
| `baseline_1/`                   | 1                |
| `moderate_1e4/`                 | 1e4              |
| `progressive_1e6/`              | 1e6              |
| `extreme_1e8/`                  | 1e8              |
| `spatial_thermal_9e4/`          | ≈ 9e4            |
| `sobol_oscillatory_1e6/`        | 1e6              |
| `sobol_digit_oscillatory_1e6/`  | 1e6              |
| `halton_oscillatory_1e6/`       | 1e6              |

## Usage

Add every strategy at once with `run('add_all_strategies.m')`, or a single
strategy with `add_strategy('extreme_1e8')`. See `INDEX.txt` for the full
problem list.

See the [repository README](../README.md) for the full description,
citation, and license.
