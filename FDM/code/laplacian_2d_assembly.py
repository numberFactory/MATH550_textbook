import numpy as np
import scipy.sparse as sp
import matplotlib.pyplot as plt

## USER INPUTS
Nx = 8                    # grid points per side (Type I grid, boundaries included)
L = 1.0                   # domain is [0, L] x [0, L]
h = L / (Nx - 1)          # grid spacing

# Dirichlet boundary values
BC = lambda x, y: np.sin(np.pi * x) * np.sinh(np.pi * y)

# unknowns are stacked row-wise: k = i + j*n, as in the text

# 5-point stencil coefficients
P = -4 / h**2             # this point
W = 1 / h**2              # west neighbor
E = 1 / h**2              # east neighbor
S = 1 / h**2              # south neighbor
N = 1 / h**2              # north neighbor


## OPTION 1: every grid point is an unknown
# boundary rows just say phi = BC, interior rows get the 5-point stencil
rows, cols, vals = [], [], []
f_full = np.zeros(Nx * Nx)

for j in range(Nx):
    for i in range(Nx):
        k = i + j * Nx
        x = i * h
        y = j * h

        if i == 0 or i == Nx - 1 or j == 0 or j == Nx - 1:   # boundary point
            rows.append(k); cols.append(k); vals.append(1.0)
            f_full[k] = BC(x, y)
        else:                                                # interior point
            rows.append(k); cols.append(k);      vals.append(P)
            rows.append(k); cols.append(k - 1);  vals.append(W)
            rows.append(k); cols.append(k + 1);  vals.append(E)
            rows.append(k); cols.append(k - Nx); vals.append(S)
            rows.append(k); cols.append(k + Nx); vals.append(N)

A_full = sp.coo_matrix((vals, (rows, cols)), shape=(Nx * Nx, Nx * Nx)).tocsr()


## OPTION 2: only interior points are unknowns
# boundary values are known, so they move to the right hand side:
#   (stencil on interior points) = f_P - alpha / h^2
# where alpha is the known value at a boundary neighbor (see Chapter 3)
n = Nx - 2                # interior points per side
rows, cols, vals = [], [], []
f_int = np.zeros(n * n)   # f = 0 for Laplace's equation

for j in range(1, Nx - 1):
    for i in range(1, Nx - 1):
        k = (i - 1) + (j - 1) * n
        x = i * h
        y = j * h

        rows.append(k); cols.append(k); vals.append(P)

        if i == 1:                     # W is on the boundary x = 0
            alpha = BC(0, y)
            f_int[k] = f_int[k] - alpha / h**2
        else:
            rows.append(k); cols.append(k - 1); vals.append(W)

        if i == Nx - 2:                # E is on the boundary x = L
            alpha = BC(L, y)
            f_int[k] = f_int[k] - alpha / h**2
        else:
            rows.append(k); cols.append(k + 1); vals.append(E)

        if j == 1:                     # S is on the boundary y = 0
            alpha = BC(x, 0)
            f_int[k] = f_int[k] - alpha / h**2
        else:
            rows.append(k); cols.append(k - n); vals.append(S)

        if j == Nx - 2:                # N is on the boundary y = L
            alpha = BC(x, L)
            f_int[k] = f_int[k] - alpha / h**2
        else:
            rows.append(k); cols.append(k + n); vals.append(N)

A_int = sp.coo_matrix((vals, (rows, cols)), shape=(n * n, n * n)).tocsr()


## OPTION 3: same matrix as option 2, built with Kronecker products
# 1D second derivative on the interior points (boundaries removed)
e = np.ones(n)
Dxx = sp.diags([e[:-1], -2 * e, e[:-1]], [-1, 0, 1]) / h**2
Dyy = Dxx.copy()          # same here since the grid is square
I = sp.identity(n)

# unknowns are stacked row-wise, so x-derivatives act within each block of n rows
A_kron = (sp.kron(I, Dxx) + sp.kron(Dyy, I)).tocsr()


## SPARSITY PLOTS
fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(21, 7))

ax1.spy(A_full, marker='o', markersize=6, color='cornflowerblue')
ax1.set_title('Full-grid matrix', fontsize=20)

ax2.spy(A_int, marker='o', markersize=6, color=[1.0, 0.1, 0.45])
ax2.set_title('Interior-only matrix', fontsize=20)

ax3.spy(A_kron, marker='o', markersize=6, color='darkorange')
ax3.set_title('Kronecker matrix', fontsize=20)

for ax in (ax1, ax2, ax3):
    ax.set_xlabel('column index', fontsize=20)
    ax.set_ylabel('row index', fontsize=20)
    ax.tick_params(labelsize=16)

fig.tight_layout()
plt.show()
