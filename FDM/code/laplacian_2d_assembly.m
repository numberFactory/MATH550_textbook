%% USER INPUTS
Nx = 8;                   % grid points per side (Type I grid, boundaries included)
L  = 1.0;                 % domain is [0, L] x [0, L]
h  = L / (Nx - 1);        % grid spacing

% Dirichlet boundary values
BC = @(x, y) sin(pi*x) .* sinh(pi*y);

% unknowns are stacked row-wise: k = i + (j-1)*n, as in the text
% (MATLAB indices start at 1, so i = 1 is x = 0 and j = 1 is y = 0)

% 5-point stencil coefficients
P = -4 / h^2;             % this point
W =  1 / h^2;             % west neighbor
E =  1 / h^2;             % east neighbor
S =  1 / h^2;             % south neighbor
N =  1 / h^2;             % north neighbor


%% OPTION 1: every grid point is an unknown
% boundary rows just say phi = BC, interior rows get the 5-point stencil
rows = []; cols = []; vals = [];
f_full = zeros(Nx*Nx, 1);

for j = 1:Nx
    for i = 1:Nx
        k = i + (j - 1)*Nx;
        x = (i - 1)*h;
        y = (j - 1)*h;

        if i == 1 || i == Nx || j == 1 || j == Nx      % boundary point
            rows(end+1) = k; cols(end+1) = k; vals(end+1) = 1;
            f_full(k) = BC(x, y);
        else                                           % interior point
            rows(end+1) = k; cols(end+1) = k;      vals(end+1) = P;
            rows(end+1) = k; cols(end+1) = k - 1;  vals(end+1) = W;
            rows(end+1) = k; cols(end+1) = k + 1;  vals(end+1) = E;
            rows(end+1) = k; cols(end+1) = k - Nx; vals(end+1) = S;
            rows(end+1) = k; cols(end+1) = k + Nx; vals(end+1) = N;
        end
    end
end

A_full = sparse(rows, cols, vals, Nx*Nx, Nx*Nx);


%% OPTION 2: only interior points are unknowns
% boundary values are known, so they move to the right hand side:
%   (stencil on interior points) = f_P - alpha / h^2
% where alpha is the known value at a boundary neighbor (see Chapter 2)
n = Nx - 2;               % interior points per side
rows = []; cols = []; vals = [];
f_int = zeros(n*n, 1);    % f = 0 for Laplace's equation

for j = 2:Nx-1
    for i = 2:Nx-1
        k = (i - 1) + (j - 2)*n;
        x = (i - 1)*h;
        y = (j - 1)*h;

        rows(end+1) = k; cols(end+1) = k; vals(end+1) = P;

        if i == 2                      % W is on the boundary x = 0
            alpha = BC(0, y);
            f_int(k) = f_int(k) - alpha / h^2;
        else
            rows(end+1) = k; cols(end+1) = k - 1; vals(end+1) = W;
        end

        if i == Nx - 1                 % E is on the boundary x = L
            alpha = BC(L, y);
            f_int(k) = f_int(k) - alpha / h^2;
        else
            rows(end+1) = k; cols(end+1) = k + 1; vals(end+1) = E;
        end

        if j == 2                      % S is on the boundary y = 0
            alpha = BC(x, 0);
            f_int(k) = f_int(k) - alpha / h^2;
        else
            rows(end+1) = k; cols(end+1) = k - n; vals(end+1) = S;
        end

        if j == Nx - 1                 % N is on the boundary y = L
            alpha = BC(x, L);
            f_int(k) = f_int(k) - alpha / h^2;
        else
            rows(end+1) = k; cols(end+1) = k + n; vals(end+1) = N;
        end
    end
end

A_int = sparse(rows, cols, vals, n*n, n*n);


%% OPTION 3: same matrix as option 2, built with Kronecker products
% 1D second derivative on the interior points (boundaries removed)
e = ones(n, 1);
Dxx = spdiags([e, -2*e, e], [-1, 0, 1], n, n) / h^2;
Dyy = Dxx;                % same here since the grid is square
I = speye(n);

% unknowns are stacked row-wise, so x-derivatives act within each block of n rows
A_kron = kron(I, Dxx) + kron(Dyy, I);

%% SPARSITY PLOTS
figure('Position', [100, 100, 2100, 700]);

mats   = {A_full, A_int, A_kron};
titles = {'Full-grid matrix', 'Interior-only matrix', 'Kronecker matrix'};
colors = {[0.39, 0.58, 0.93], [1.0, 0.1, 0.45], [1.0, 0.55, 0.0]};

for m = 1:3
    ax = subplot(1, 3, m);
    spy(mats{m}, 'o', 6)
    set(get(ax, 'Children'), 'Color', colors{m})   % marker color
    set(ax, 'FontSize', 16)                         % tick labels (set first!)
    title(titles{m}, 'FontSize', 20)
    xlabel('column index', 'FontSize', 20)
    ylabel('row index', 'FontSize', 20)
end
