import matplotlib.pyplot as plt
import numpy as np
import sys

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(
        description="Compare a spectral solution with the exact solution")
    parser.add_argument('input')
    parser.add_argument('-o', '--output', default='comparison.pdf')
    parser.add_argument('--no-show', action='store_true')
    args = parser.parse_args()
    fname = args.input
    N = str(len(np.atleast_2d(np.loadtxt(fname))))

    data = np.loadtxt(fname)

    x = np.linspace(0, 2 * np.pi, 500)
    exact_solution = np.exp(np.sin(x)) - np.exp(np.cos(3 * x))

    fig, ax = plt.subplots()

    ax.plot(x, exact_solution)
    ax.scatter(data[:, 0], data[:, 1], color='red', marker='+')
    ax.legend(['Exact solution', 'Numerical solution'])
    ax.set_xlabel('x', fontsize='x-large')
    ax.set_ylabel('u(x)', fontsize='x-large')
    ax.set_title(
        'Comparison of exact solution and numerical solution\nwith grid resolution of N=' +
        N,
        fontsize='x-large')

    plt.savefig(args.output)
    if not args.no_show:
        plt.show()
