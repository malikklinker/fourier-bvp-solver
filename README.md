# Fourier BVP solver

A Fortran solver for the periodic equation `u - u'' = f` on `[0, 2π)`. Explicit real Fourier matrices transform the forcing, apply spectral scaling, and reconstruct the solution. A manufactured exact solution provides a maximum-error check.

## Build and run

Requires gfortran and GNU Make; plotting requires Python, NumPy, and Matplotlib.

```sh
make -j4
./build/debug/bvp.ex
python3 compare_solutions.py data/sol_021.dat --no-show -o comparison.pdf
```

Set `num_points` in `bvp.init` to an odd integer ≥ 3. Output is written to `data/sol_NNN.dat`, replacing any previous file for that resolution. Columns are position, solution, forcing, and scaled Fourier coefficient.

The explicit transforms use O(N²) work and storage. Use `make release` for an optimized build, `make sanitize` for runtime checks and sanitizers, and `make clean` to remove build files. Binaries are stored in `build/<mode>/`.
