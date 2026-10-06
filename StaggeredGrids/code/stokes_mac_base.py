import numpy as np
import scipy.sparse as sp
import scipy.sparse.linalg as spla
import matplotlib.pyplot as plt

## USER INPUTS
x_start, x_end = 0.0, 1.0       # domain in x (periodic)
y_start, y_end = 0.0, 1.0       # domain in y (walls)
mu    = 1.0                     # viscosity
Nx    = 50                      # number of cells in x
Ny    = Nx                      # number of cells in y

#any other constants go here :) 

dx = (x_end - x_start) / Nx     # grid spacing in x
dy = (y_end - y_start) / Ny     # grid spacing in y

## GRIDS
# unknowns are ordered k = i + j*Nx (x varies fastest)

# p at cell centers
x_P = x_start + (np.arange(Nx) + 0.5) * dx
y_P = y_start + (np.arange(Ny) + 0.5) * dy

# u on east/west faces (x = x_end is the same face as x = x_start)
x_U = x_start + np.arange(Nx) * dx
y_U = y_P

# v on north/south faces (wall values are known, so they are removed)
x_V = x_P
y_V = y_start + np.arange(1, Ny) * dy

# Note the number of unknowns depends on boundary conditions!
nU = #####                    # number of u unknowns
nV = #####              	     # number of v unknowns
nP = #####                    # number of p unknowns

###
# BUILD THE OPERATORS HERE AS SPARSE MATRICES
#   Lu : (nU x nU)   Laplacian of u
#   Lv : (nV x nV)   Laplacian of v
#   Gx : (nU x nP)   x-derivative of p at the u points
#   Gy : (nV x nP)   y-derivative of p at the v points
#   Dx : (nP x nU)   x-derivative of u at the p points
#   Dy : (nP x nV)   y-derivative of v at the p points
###

###
# BUILD THE RIGHT HAND SIDE HERE
###
bu = np.zeros(nU)
bv = np.zeros(nV)
bp = np.zeros(nP)

# block system (None is a zero block)
A = sp.bmat([[mu*Lu, None,  -Gx ],
             [None,  mu*Lv, -Gy ],
             [Dx,    Dy,    None]], format='csr')
b = np.concatenate([bu, bv, bp])


# solve
sol = spla.spsolve(A, b)

U = sol[:nU].reshape(Ny, Nx)                  # u on its grid
V = sol[nU:nU + nV].reshape(Ny - 1, Nx)       # v on its grid
P = sol[nU + nV:nU + nV + nP].reshape(Ny, Nx) # p on its grid
P = P - np.mean(P)                            # zero-mean pressure

###
# INTERPOLATE U AND V TO THE CELL CENTERS HERE
###

## PLOTS (see Chapter 1 for how to make these better!)
plt.figure()
plt.pcolormesh(x_P, y_P, np.sqrt(Uc**2 + Vc**2), shading='gouraud')
plt.colorbar(label='speed')
plt.xlabel('x')
plt.ylabel('y')

plt.figure()
plt.pcolormesh(x_P, y_P, P, shading='gouraud')
plt.colorbar(label='pressure')
plt.xlabel('x')
plt.ylabel('y')

plt.show()
