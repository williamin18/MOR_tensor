% Build function
f = build_example_e1();

% Test input
x = [0.7; 0.6; 0.65; 0.2];

% Evaluate
y = eval_nonlinear(f, x);

% Display
disp('Input x:');
disp(x);

disp('Output y:');
disp(y);