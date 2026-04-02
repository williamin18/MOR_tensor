% NPN BJT example: evaluate Jacobian and verify with finite differences
% x = [VB, VC, VE, Vcc]

% Build function
f = build_example_e2();

% Test input
x = [0.70; 5.0; 0.0; 12.0];

% Evaluate Jacobian
J = eval_jacobian(f, x);

% Display
disp('Input x:');
disp(x);

disp('Jacobian J (dy/dx):');
disp(J);

% Finite-difference verification
h    = 1e-6;
m    = length(x);
n    = length(f);
J_fd = zeros(n, m);
y0   = eval_nonlinear(f, x);

for j = 1:m
    xp       = x;
    xp(j)    = xp(j) + h;
    J_fd(:,j) = (eval_nonlinear(f, xp) - y0) / h;
end

disp('Finite-difference Jacobian (verification):');
disp(J_fd);

disp('Max absolute error:');
disp(max(abs(J(:) - J_fd(:))));
