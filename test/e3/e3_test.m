% Darlington pair example: evaluate nonlinear function
% x = [VB1, VC, VM, VE2, Vcc]
%   VB1=1.30 V, VC=10.0 V, VM=0.65 V, VE2=0.0 V, Vcc=15.0 V

% Build function
f = build_example();

% Test input (Darlington in forward-active region)
x = [1.30; 10.0; 0.65; 0.0; 15.0];

% Evaluate
y = eval_nonlinear(f, x);

% Display
disp('Input x:');
disp(x);

disp('Output y:');
disp(y);
