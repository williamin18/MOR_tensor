% Six-node diode network example: evaluate nonlinear function
% x = [V1, V2, V3, V4, V5, V6]
%   Descending node voltages with V6 = 0 (ground)

% Build function
f = build_example_e4();

% Test input
x = [3.0; 2.5; 2.0; 1.5; 1.0; 0.0];

% Evaluate
y = eval_nonlinear(f, x);

% Display
disp('Input x:');
disp(x);

disp('Output y:');
disp(y);
