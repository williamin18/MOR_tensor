% e3_taylor_performance_test.m
% Taylor expansion convergence test for Example 3: Six-Node Diode Network.
%
% Verifies that the k-th order Taylor approximation error scales as O(h^(k+1))
% for k = 0, 1, 2, 3.  Run from the repository root so that the shared
% eval_* functions and run_convergence_test are on the MATLAB path.

f  = build_example_e3();
x0 = [0.30; 0.25; 0.20; 0.15; 0.10; 0.0];

run_convergence_test(f, x0, 'e3 (Six-Node Diode Network)');
