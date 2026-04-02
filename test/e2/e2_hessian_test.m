% NPN BJT example: evaluate Hessian and verify with finite differences
% x = [VB, VC, VE, Vcc]

% Build function
f = build_example_e2();

% Test input
x = [0.70; 5.0; 0.0; 12.0];

% Evaluate Hessian
H = eval_hessian(f, x);

% Display
disp('Input x:');
disp(x);

disp('Hessian H (d^2y/dx^2), size n x m x m:');
disp(size(H));
for i = 1:size(H, 1)
    fprintf('H(%d,:,:) =\n', i);
    disp(squeeze(H(i,:,:)));
end

% Finite-difference verification (perturb Jacobian)
h    = 1e-5;
m    = length(x);
n    = length(f);
H_fd = zeros(n, m, m);
J0   = eval_jacobian(f, x);

for j = 1:m
    xp          = x;
    xp(j)       = xp(j) + h;
    Jp          = eval_jacobian(f, xp);
    H_fd(:,j,:) = (Jp - J0) / h;
end

disp('Max absolute error (analytical vs finite-difference):');
disp(max(abs(H(:) - H_fd(:))));
