import numpy as np
import scipy.sparse as sp
import scipy.sparse.linalg as spla

# grid: N interior points per direction on [0, 2pi] (Type I, Dirichlet)
N = 64
ell = 2*np.pi
x = np.linspace(0, ell, N + 2)[1:-1]   # drop the two boundary nodes
dx = x[1] - x[0]
X, Y = np.meshgrid(x, x)    # X[j, i] = x_i and Y[j, i] = y_j
# grid values are stored as U[j, i], so U.ravel() stacks the rows,
# matching the row-wise ordering of the text

k = 1.0                     # diffusivity

# 2D five-point Laplacian on the interior unknowns (Kronecker build)
e = np.ones(N)
D2 = sp.diags([e[:-1], -2*e, e[:-1]], [-1, 0, 1]) / dx**2
I_N = sp.identity(N)
L = (sp.kron(I_N, D2) + sp.kron(D2, I_N)).tocsr()
I_n = sp.identity(N*N, format='csr')


def phi_exact(t):
    ###
    # IMPLEMENT: the manufactured solution at time t on the grid,
    # returned as a flattened vector of length N*N
    ###
    return np.zeros(N*N)


def g(t):
    ###
    # IMPLEMENT: the forcing f at time t on the grid, plus any boundary
    # contributions (Section on boundary conditions), flattened
    ###
    return np.zeros(N*N)


def F(t, phi):
    # right-hand side of the semi-discrete system d(phi)/dt = F(t, phi)
    return k*(L @ phi) + g(t)


def rel_err(phi_num, phi_ex):
    # relative error in the discrete 2-norm
    nrm = np.linalg.norm(phi_ex)
    if nrm == 0.0:
        print('phi_exact is zero -- implement it first')
        return np.nan
    return np.linalg.norm(phi_num - phi_ex) / nrm


# time stepping parameters
T = 2*np.pi                 # final time
Nt = 2000                   # number of steps; dt = T/Nt divides T exactly
dt = T / Nt

# implicit methods: the matrix does not change from step to step,
# so factor it ONCE, before the time loop.
# example: the backward Euler matrix (other methods need their own matrix)
A_BE = (I_n - dt*k*L).tocsc()
solve_BE = spla.factorized(A_BE)   # returns a function b -> A_BE^{-1} b

phi = phi_exact(0.0)        # initial condition, phi^0
for n in range(Nt):         # n = 0, ..., Nt-1 takes phi^n to phi^(n+1)
    t = n*dt                # time of the KNOWN level phi^n
                            # (compute from n; do not accumulate t += dt)
    ###
    # IMPLEMENT ONE TIME STEP HERE: phi^n -> phi^(n+1)
    # e.g. for an implicit method, build the right-hand side b
    # and call phi = solve_BE(b)
    ###
    pass

# after the loop, phi approximates the solution at t = Nt*dt = T
print(f'N = {N}, dt = {dt:.3e}, relative error = {rel_err(phi, phi_exact(T)):.3e}')

# RK45: an open implementation with adaptive steps
# from scipy.integrate import solve_ivp
# sol = solve_ivp(F, (0.0, T), phi_exact(0.0), method='RK45',
#                 t_eval=[T], rtol=1e-6, atol=1e-9)
# print(sol.nfev, 'evaluations of F')
