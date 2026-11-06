import numpy as np
import scipy.sparse.linalg as spla
import matplotlib.pyplot as plt

# N interior points per direction on [0, 2pi] (Type I)
N = 63
x = np.linspace(0, 2*np.pi, N + 2)[1:-1]   # drop the two boundary nodes
dx = x[1] - x[0]
X, Y = np.meshgrid(x, x)    # X[j, i] = x_i and Y[j, i] = y_j
# the grid values are stored as U[j, i], so U.ravel() stacks the rows
# and k = i + j*N, as in the text

# f = 0 (the walls are held at u = 0)
f = np.zeros((N, N))

# immersed boundary: an elliptical ring held at height g = 1
Ax, Ay = 1.5, 0.75                      # semi-axes of the ellipse
# measure the perimeter with a fine sampling of the ellipse
th = np.linspace(0, 2*np.pi, 10001)
perimeter = np.sum(np.hypot(np.diff(Ax*np.cos(th)), np.diff(Ay*np.sin(th))))
ds_target = dx                          # average spacing of IB points
Nib = int(np.ceil(perimeter/ds_target))
theta = 2*np.pi*np.arange(Nib)/Nib
Xib = np.pi + Ax*np.cos(theta)
Yib = np.pi + Ay*np.sin(theta)
g = np.ones(Nib)

a = 1.2*dx                              # width of the delta function


def delta_a(rx, ry):
    # two-dimensional Gaussian regularized delta function
    return np.exp(-(rx**2 + ry**2)/(2*a**2))/(2*np.pi*a**2)


def spread(q):
    # charges at the IB points
    F = np.zeros((N, N))
    for k in range(Nib):
        F += q[k]*delta_a(X - Xib[k], Y - Yib[k])
    return F


def interp(U):
    # values at the IB points
    out = np.zeros(Nib)
    for k in range(Nib):
        out[k] = np.sum(U*delta_a(X - Xib[k], Y - Yib[k]))*dx**2
    return out


def apply_L(U):
    # five-point Laplacian, homogeneous Dirichlet
    Up = np.pad(U, 1)
    return (Up[1:-1, :-2] + Up[1:-1, 2:]       # W + E
            + Up[:-2, 1:-1] + Up[2:, 1:-1]     # S + N
            - 4*U)/dx**2


def apply_A(z):
    ###
    # IMPLEMENT THE SADDLE POINT OPERATOR HERE
    # z holds the N*N grid values (flattened row-wise) followed by the
    # Nib charges. Reshape the grid part to N x N, apply L, S, and J,
    # and return the flattened, stacked vector [L u - S q ; J u]
    ###
    return np.zeros(N*N + Nib)


rhs = np.concatenate([f.ravel(), g])

# GMRES without restarts: restart = size of the system, one outer iteration
A = spla.LinearOperator((N*N + Nib, N*N + Nib), matvec=apply_A, dtype=float)
tol = 0.1*dx**2
z, flag = spla.gmres(A, rhs, rtol=tol, restart=N*N + Nib, maxiter=1)
U = z[:N*N].reshape(N, N)
q = z[N*N:]
print(f'GMRES flag {flag}, {Nib} IB points')

# debugging option -- build the matrix one column at a time (small N only!)
# Amat = np.column_stack([apply_A(e) for e in np.eye(N*N + Nib)])
# plt.spy(Amat, precision=1e-8)
# plt.show()

Uib = interp(U)
fig = plt.figure()
ax = fig.add_subplot(projection='3d')
ax.plot_surface(X, Y, U, cmap='viridis', linewidth=0)
ax.plot(np.r_[Xib, Xib[0]], np.r_[Yib, Yib[0]], np.r_[Uib, Uib[0]], 'k.-')
ax.set_xlabel('$x$')
ax.set_ylabel('$y$')
ax.set_zlabel('$u$')
plt.show()
