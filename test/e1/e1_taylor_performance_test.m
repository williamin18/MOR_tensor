% e1_taylor_performance_test.m
% Taylor expansion convergence test for Example 1: NPN BJT.
%
% Verifies that the k-th order Taylor approximation error scales as O(h^(k+1))
% for k = 0, 1, 2, 3.  Run from the repository root so that the shared
% eval_* functions and run_convergence_test are on the MATLAB path.

f  = build_example_e1();
x0 = [0.70; 5.0; 0.0; 12.0];

run_convergence_test(f, x0, 'e1 (NPN BJT)');
