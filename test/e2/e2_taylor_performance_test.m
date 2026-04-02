% e2_taylor_performance_test.m
% Taylor expansion convergence test for Example 2: Darlington Pair.
%
% Verifies that the k-th order Taylor approximation error scales as O(h^(k+1))
% for k = 0, 1, 2, 3.  Run from the repository root so that the shared
% eval_* functions and run_convergence_test are on the MATLAB path.

f  = build_example_e2();
x0 = [1.30; 10.0; 0.65; 0.0; 15.0];

run_convergence_test(f, x0, 'e2 (Darlington Pair)');
