function pass = e3_hessian_cp_test()
    % e3_hessian_cp_test  Verify eval_hessian_cp for the six-node diode network (e3).
    %
    % Builds the Hessian in CP format, recovers it with recover_cp_tensor, and
    % compares the result with the reference tensor from eval_hessian.
    % Returns true if max absolute error is below tolerance.

    tol = 1e-8;

    f = build_example_e3();
    x = [0.30; 0.25; 0.20; 0.15; 0.10; 0.0];

    % Reference dense Hessian
    H_ref = eval_hessian(f, x);

    % CP format and recovery
    CP    = eval_hessian_cp(f, x);
    H_rec = recover_cp_tensor(CP);

    max_err = max(abs(H_ref(:) - H_rec(:)));

    fprintf('e3 Hessian CP test\n');
    fprintf('  CP size:        %d x %d x %d\n', size(CP, 1), size(CP, 2), size(CP, 3));
    fprintf('  Max abs error:  %.2e  (tol = %.2e)\n', max_err, tol);

    pass = max_err < tol;
    result_strs = {'FAIL', 'PASS'};
    fprintf('  Result: %s\n\n', result_strs{pass + 1});
end
