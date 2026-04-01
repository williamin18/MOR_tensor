% NPN BJT example: evaluate nonlinear function
% x = [VB, VC, VE, Vcc]
%   VB=0.70 V (base), VC=5.0 V (collector), VE=0.0 V (emitter), Vcc=12 V

% Build function
f = build_example();

% Test input
x = [0.70; 5.0; 0.0; 12.0];

% Evaluate
y = eval_nonlinear(f, x);

% Display
disp('Input x:');
disp(x);

disp('Output y:');
disp(y);
