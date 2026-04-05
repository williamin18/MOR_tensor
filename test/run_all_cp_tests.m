% run_all_cp_tests.m
% Top-level runner for all CP format tests.
%
% For each of the three circuit examples (e1, e2, e3) this script:
%   1. Builds the Hessian in CP format and recovers it, comparing with eval_hessian.
%   2. Builds the third-order tensor in CP format and recovers it, comparing
%      with eval_third_order.
%
% Execute this script from the repository root.

addpath('derivatives');
addpath('cp');
addpath('test/e1');
addpath('test/e2');
addpath('test/e3');

result_strs = {'FAIL', 'PASS'};

fprintf('%s\n', repmat('*', 1, 50));
fprintf('CP FORMAT TESTS\n');
fprintf('%s\n\n', repmat('*', 1, 50));

p1h = e1_hessian_cp_test();
p1t = e1_third_order_cp_test();

p2h = e2_hessian_cp_test();
p2t = e2_third_order_cp_test();

p3h = e3_hessian_cp_test();
p3t = e3_third_order_cp_test();

fprintf('%s\n', repmat('*', 1, 50));
fprintf('OVERALL SUMMARY\n');
fprintf('%s\n', repmat('*', 1, 50));
fprintf('e1 Hessian CP:           %s\n', result_strs{p1h + 1});
fprintf('e1 Third-order CP:       %s\n', result_strs{p1t + 1});
fprintf('e2 Hessian CP:           %s\n', result_strs{p2h + 1});
fprintf('e2 Third-order CP:       %s\n', result_strs{p2t + 1});
fprintf('e3 Hessian CP:           %s\n', result_strs{p3h + 1});
fprintf('e3 Third-order CP:       %s\n', result_strs{p3t + 1});
fprintf('%s\n', repmat('*', 1, 50));

all_pass = p1h && p1t && p2h && p2t && p3h && p3t;
fprintf('OVERALL: %s\n', result_strs{all_pass + 1});
fprintf('%s\n', repmat('*', 1, 50));
