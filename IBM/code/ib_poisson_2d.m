% grid: N interior points per direction on [0, 2*pi] (Type I)
N = 63;
x = linspace(0, 2*pi, N+2)';
x(1) = [];               % remove boundary node x = 0 (Dirichlet, known)
x(end) = [];             % remove boundary node x = 2*pi
dx = x(2) - x(1);
[X, Y] = ndgrid(x, x);   % X(i,j) = x_i and Y(i,j) = y_j
% the grid values are stored as U(i,j), so U(:) stacks the rows
% and k = i + (j-1)*N, as in the text

% load: f = 0 (the walls are held at u = 0)
f = zeros(N, N);

% immersed boundary: an elliptical ring held at height g = 1
Ax = 1.5;                % semi-axes of the ellipse
Ay = 0.75;
% measure the perimeter with a fine sampling of the ellipse
th = linspace(0, 2*pi, 10001);
perimeter = sum(hypot(diff(Ax*cos(th)), diff(Ay*sin(th))));
ds_target = dx;          % average spacing of IB points
Nib = ceil(perimeter/ds_target);
theta = 2*pi*(0:Nib-1)'/Nib;
Xib = pi + Ax*cos(theta);
Yib = pi + Ay*sin(theta);
g = ones(Nib, 1);

a = 1.2*dx;              % width of the delta function

rhs = [f(:); g];

% GMRES without restarts: restart = size of the system, one outer iteration
Afun = @(z) apply_A(z, X, Y, dx, Xib, Yib, a);
tol = 0.1*dx^2;
[z, FLAG, RELRES, ITER] = gmres(Afun, rhs, N*N + Nib, tol, 1);
U = reshape(z(1:N*N), N, N);
q = z(N*N+1:end);
disp(['GMRES flag ' num2str(FLAG) ', ' num2str(Nib) ' IB points'])

% debugging: build the matrix one column at a time (small N only!)
% n = N*N + Nib;
% Amat = zeros(n);
% I = eye(n);
% for c = 1:n
%     Amat(:,c) = Afun(I(:,c));
% end
% spy(abs(Amat) > 1e-8*max(abs(Amat(:))))

Uib = interp_J(U, X, Y, dx, Xib, Yib, a);
figure
surf(X, Y, U, 'EdgeColor', 'none')
hold on
plot3([Xib; Xib(1)], [Yib; Yib(1)], [Uib; Uib(1)], 'k.-')
hold off
xlabel('x')
ylabel('y')
zlabel('u')

function d = delta_a(rx, ry, a)
    % two-dimensional Gaussian regularized delta function
    d = exp(-(rx.^2 + ry.^2)/(2*a^2))/(2*pi*a^2);
end

function F = spread_S(q, X, Y, Xib, Yib, a)
    % S q: charges at the IB points -> N x N grid function
    F = zeros(size(X));
    for k = 1:length(Xib)
        F = F + q(k)*delta_a(X - Xib(k), Y - Yib(k), a);
    end
end

function Uib = interp_J(U, X, Y, dx, Xib, Yib, a)
    % J u: N x N grid function -> values at the IB points
    Uib = zeros(length(Xib), 1);
    for k = 1:length(Xib)
        Uib(k) = sum(sum(U.*delta_a(X - Xib(k), Y - Yib(k), a)))*dx^2;
    end
end

function V = apply_L(U, dx)
    % five-point Laplacian, homogeneous Dirichlet (zero ghost layer)
    N = size(U, 1);
    Up = zeros(N+2, N+2);
    Up(2:end-1, 2:end-1) = U;
    V = (Up(1:end-2, 2:end-1) + Up(3:end, 2:end-1) ...   % W + E
       + Up(2:end-1, 1:end-2) + Up(2:end-1, 3:end) ...   % S + N
       - 4*U)/dx^2;
end

function y = apply_A(z, X, Y, dx, Xib, Yib, a)
    N = size(X, 1);
    y = zeros(size(z));
    %%%
    % IMPLEMENT THE SADDLE POINT OPERATOR HERE
    % z holds the N*N grid values (stacked as U(:)) followed by the
    % Nib charges. Reshape the grid part to N x N, apply L, S, and J,
    % and return the stacked vector [L u - S q ; J u]
    %%%
end
