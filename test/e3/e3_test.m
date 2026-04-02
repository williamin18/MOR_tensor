% Six-node diode network example: evaluate nonlinear function
% x = [V1, V2, V3, V4, V5, V6]
%   Descending node voltages with V6 = 0 (ground)

% Build function
f = build_example_e3();

% Test input
x = [0.30; 0.25; 0.20; 0.15; 0.10; 0.0];

% Evaluate
y = eval_nonlinear(f, x);

% Display
disp('Input x:');
disp(x);

disp('Output y:');
disp(y);
