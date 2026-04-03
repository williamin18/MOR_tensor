% run_all_taylor_tests.m
% Top-level runner for all Taylor expansion performance tests.
%
% Runs the convergence test for each of the three circuit examples and prints
% an overall pass/fail summary.  Execute this script from the repository root.

addpath('test/e1');
addpath('test/e2');
addpath('test/e3');

result_strs = {'FAIL', 'PASS'};

f1  = build_example_e1();
x01 = [0.70; 5.0; 0.0; 12.0];
p1  = run_convergence_test(f1, x01, 'e1 (NPN BJT)');

f2  = build_example_e2();
x02 = [1.30; 10.0; 0.65; 0.0; 15.0];
p2  = run_convergence_test(f2, x02, 'e2 (Darlington Pair)');

f3  = build_example_e3();
x03 = [0.30; 0.25; 0.20; 0.15; 0.10; 0.0];
p3  = run_convergence_test(f3, x03, 'e3 (Six-Node Diode Network)');

fprintf('\n%s\n', repmat('*', 1, 40));
fprintf('OVERALL SUMMARY\n');
fprintf('%s\n', repmat('*', 1, 40));
fprintf('e1 (NPN BJT):                %s\n', result_strs{p1 + 1});
fprintf('e2 (Darlington Pair):        %s\n', result_strs{p2 + 1});
fprintf('e3 (Six-Node Diode Network): %s\n', result_strs{p3 + 1});
fprintf('%s\n', repmat('*', 1, 40));
