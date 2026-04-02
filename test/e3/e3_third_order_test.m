% Six-node diode network example: evaluate third-order derivative tensor and verify with finite differences

% Build function
f = build_example_e3();

% Test input
x = [0.60; 0.40; 0.20; 0.0; 5.0; 0.0];

% Evaluate third-order tensor
T = eval_third_order(f, x);

% Display
disp('Input x:');
disp(x);

disp('Third-order tensor T (d^3y/dx^3), size n x m x m x m:');
disp(size(T));
for i = 1:size(T, 1)
    for j = 1:size(T, 2)
        fprintf('T(%d,%d,:,:) =\n', i, j);
        disp(squeeze(T(i,j,:,:)));
    end
end

% Finite-difference verification (perturb Hessian)
h    = 1e-4;
m    = length(x);
n    = length(f);
T_fd = zeros(n, m, m, m);
H0   = eval_hessian(f, x);

for j = 1:m
    xp          = x;
    xp(j)       = xp(j) + h;
    Hp          = eval_hessian(f, xp);
    T_fd(:,j,:,:) = (Hp - H0) / h;
end

disp('Max absolute error (analytical vs finite-difference):');
disp(max(abs(T(:) - T_fd(:))));
