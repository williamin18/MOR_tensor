function pass = e3_third_order_cp_test()
    % e3_third_order_cp_test  Verify eval_third_order_cp for the six-node diode network (e3).
    %
    % Builds the third-order tensor in CP format, recovers it with recover_cp_tensor,
    % and compares the result with the reference tensor from eval_third_order.
    % Returns true if max absolute error is below tolerance.

    tol = 1e-4;

    f = build_example_e3();
    x = [0.30; 0.25; 0.20; 0.15; 0.10; 0.0];

    % Reference dense third-order tensor
    T_ref = eval_third_order(f, x);

    % CP format and recovery
    CP    = eval_third_order_cp(f, x);
    T_rec = recover_cp_tensor(CP);

    max_err = max(abs(T_ref(:) - T_rec(:)));

    fprintf('e3 Third-order CP test\n');
    fprintf('  CP size:        %d x %d x %d\n', size(CP, 1), size(CP, 2), size(CP, 3));
    fprintf('  Max abs error:  %.2e  (tol = %.2e)\n', max_err, tol);

    pass = max_err < tol;
    result_strs = {'FAIL', 'PASS'};
    fprintf('  Result: %s\n\n', result_strs{pass + 1});
end
