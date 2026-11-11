% grid: N interior points per direction on [0, 2*pi] (Type I, Dirichlet)
N = 64;
ell = 2*pi;
x = linspace(0, ell, N+2)';
x(1) = [];               % remove boundary node x = 0 (Dirichlet, known)
x(end) = [];             % remove boundary node x = 2*pi
dx = x(2) - x(1);
[X, Y] = ndgrid(x, x);   % X(i,j) = x_i and Y(i,j) = y_j
% grid values are stored as U(i,j), so U(:) stacks the rows,
% matching the row-wise ordering of the text

k = 1.0;                 % diffusivity

% 2D five-point Laplacian on the interior unknowns (Kronecker build)
e = ones(N, 1);
D2 = spdiags([e, -2*e, e], [-1, 0, 1], N, N) / dx^2;
I_N = speye(N);
L = kron(I_N, D2) + kron(D2, I_N);
I_n = speye(N*N);

% right-hand side of the semi-discrete system d(phi)/dt = F(t, phi)
F = @(t, phi) k*(L*phi) + g(t, X, Y);

% time stepping parameters
T = 2*pi;                % final time
Nt = 2000;               % number of steps; dt = T/Nt divides T exactly
dt = T / Nt;

% implicit methods: the matrix does not change from step to step,
% so factor it ONCE, before the time loop.
% example: the backward Euler matrix (other methods need their own matrix)
A_BE = I_n - dt*k*L;
dA_BE = decomposition(A_BE, 'chol');   % sparse Cholesky; dA_BE \ b solves

phi = phi_exact(0.0, X, Y);   % initial condition, phi^0
for n = 0:Nt-1           % n = 0, ..., Nt-1 takes phi^n to phi^(n+1)
    t = n*dt;            % time of the KNOWN level phi^n
                         % (compute from n; do not accumulate t = t + dt)
    %%%
    % IMPLEMENT ONE TIME STEP HERE: phi^n -> phi^(n+1)
    % e.g. for an implicit method, build the right-hand side b
    % and solve with phi = dA_BE \ b;
    %%%
end

% after the loop, phi approximates the solution at t = Nt*dt = T
err = rel_err(phi, phi_exact(T, X, Y));
disp(['N = ' num2str(N) ', dt = ' num2str(dt) ...
      ', relative error = ' num2str(err)])

% RK45: an open implementation with adaptive steps
% opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-9, 'Stats', 'on');
% [tout, phiout] = ode45(F, [0 T], phi_exact(0.0, X, Y), opts);
% phi_RK45 = phiout(end, :)';

function phi = phi_exact(t, X, Y)
    %%%
    % IMPLEMENT: the manufactured solution at time t on the grid,
    % returned as a column vector of length N*N
    %%%
    phi = zeros(numel(X), 1);
end

function gt = g(t, X, Y)
    %%%
    % IMPLEMENT: the forcing f at time t on the grid, plus any boundary
    % contributions (Section on boundary conditions), as a column vector
    %%%
    gt = zeros(numel(X), 1);
end

function err = rel_err(phi_num, phi_ex)
    % relative error in the discrete 2-norm
    nrm = norm(phi_ex);
    if nrm == 0
        disp('phi_exact is zero -- implement it first')
        err = NaN;
        return
    end
    err = norm(phi_num - phi_ex) / nrm;
end
