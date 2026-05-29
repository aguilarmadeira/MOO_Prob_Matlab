# Changelog

All notable changes to this benchmark repository are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-05-29

First publicly citable release, accompanying the DMS-SI-Mix manuscript.

### Added
- **`problems/`** — the 108 base multiobjective problems (MATLAB conversions
  of the original DMS AMPL formulations), provided for provenance; the scaled
  suites are derived from these.
- **`problems_continuous/`** — continuous heterogeneous-scale suite:
  108 problems × 8 scaling strategies (864 self-contained problem files).
- **`problems_mixed/`** — mixed-variable heterogeneous suite:
  108 problems × 8 scaling strategies (864 self-contained problem files),
  with continuous, ordered-discrete, and categorical coordinates.
- Eight scaling strategies in both suites: `baseline` (kappa = 1),
  `moderate` (1e4), `progressive` (1e6), `extreme` (1e8),
  `spatial_thermal` (≈9e4), `sobol_oscillatory` (1e6),
  `sobol_digit_oscillatory` (1e6), `halton_oscillatory` (1e6).
- Per-suite `INDEX.txt`, `add_strategy.m`, and `add_all_strategies.m`
  path helpers.
- `CITATION.cff` and dual licensing (MIT for code, CC-BY 4.0 for docs).

### Notes
- All scaled problem files are self-contained: each embeds its original
  problem definition and requires no external generation utilities at runtime.
- The base problems are provided in `problems/`; the scaling and
  type-conversion pipeline that produces the per-strategy instances is not
  distributed, only its output is.
