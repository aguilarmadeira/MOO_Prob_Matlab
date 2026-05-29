# Base problems (original DMS formulations)

The 108 base multiobjective test problems, in MATLAB, from which both
`problems_continuous/` and `problems_mixed/` are derived.

These are the multiobjective benchmark collection assembled for the
**Direct Multisearch (DMS)** study, where they are distributed as **AMPL**
formulations. The files here are MATLAB conversions of those original
formulations, verified against the original specifications, and are included
for provenance and traceability: every scaled instance under
`problems_continuous/<strategy>/` and `problems_mixed/<strategy>/` is obtained
by applying a scaling strategy (and, for the mixed suite, a type conversion)
to the corresponding base problem here. In particular, the `baseline_1/`
folders reproduce these base problems at contrast kappa = 1 (original bounds,
no scale heterogeneity).

## Interface

Each base problem is a self-contained MATLAB file `<problem>.m`:

```matlab
info     = <problem>();          % metadata: name, n, m, source family
[lb, ub] = <problem>('bounds');  % original (native) bounds
F        = <problem>(x);         % objective vector at x
```

Problems span the ZDT, DTLZ, WFG, MOP, Lovison, Jin, Deb, and related
families, with n in {1, 2, 3, 4, 7, 8, 10, 12, 22, 30} and m in {2, 3, 4, 5}.

## Provenance and attribution

- Collection assembled for the DMS study; the original AMPL formulations are
  available at the FCT NOVA Problems Collections page.
- Each family carries its own original attribution (Zitzler-Deb-Thiele,
  Deb-Thiele-Laumanns-Zitzler, Huband et al., Lovison, Jin et al., and others).
- If you use these problems, please cite the DMS paper (see the repository
  `README.md` and `CITATION.cff`), and the originating family references where
  appropriate.
