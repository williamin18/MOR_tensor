function pass = e1_hessian_cp_test()
    % e1_hessian_cp_test  Verify eval_hessian_cp for the NPN BJT example (e1).
    %
    % Builds the Hessian in CP format, recovers it with recover_cp_tensor, and
    % compares the result with the reference tensor from eval_hessian.
    % Returns true if max absolute error is below tolerance.

    tol = 1e-8;

    f = build_example_e1();
    x = [0.70; 5.0; 0.0; 12.0];

    % Reference dense Hessian
    H_ref = eval_hessian(f, x);

    % CP format and recovery
    CP    = eval_hessian_cp(f, x);
    H_rec = recover_cp_tensor(CP);

    max_err = max(abs(H_ref(:) - H_rec(:)));

    fprintf('e1 Hessian CP test\n');
    fprintf('  CP size:        %d x %d x %d\n', size(CP, 1), size(CP, 2), size(CP, 3));
    fprintf('  Max abs error:  %.2e  (tol = %.2e)\n', max_err, tol);

    pass = max_err < tol;
    result_strs = {'FAIL', 'PASS'};
    fprintf('  Result: %s\n\n', result_strs{pass + 1});
end
