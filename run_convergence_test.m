function all_pass = run_convergence_test(f, x0, example_name)
    % run_convergence_test  Verify Taylor expansion convergence for a given example.
    %
    %   all_pass = run_convergence_test(f, x0, example_name)
    %
    %   Tests that the approximation error of the k-th order Taylor expansion
    %   scales as O(h^(k+1)) for k = 0, 1, 2, 3 by fitting a log-log slope
    %   over a range of perturbation sizes.  Errors are normalized by norm(f(x0))
    %   so that results are scale-independent across examples.
    %
    %   Inputs:
    %     f            - nonlinear function struct (see eval_nonlinear)
    %     x0           - expansion point (m x 1)
    %     example_name - string used in the printed header
    %
    %   Output:
    %     all_pass - true if every convergence-rate and monotonicity check passes

    m               = length(x0);
    h_vals          = logspace(-4, -0.5, 30);
    n_h             = length(h_vals);
    n_fit           = 15;          % small-h points used for slope fitting
    expected_slopes = [1, 2, 3, 4];
    tol             = 0.3;         % allowed deviation from expected slope
    log_h           = log(h_vals(1:n_fit))';
    result_strs     = {'FAIL', 'PASS'};

    y0      = eval_nonlinear(f, x0);
    norm_y0 = norm(y0);

    % Identify active perturbation directions (columns of J with non-zero norm).
    J0        = eval_jacobian(f, x0);
    col_norms = sqrt(sum(J0.^2, 1));

    % Primary direction: first axis with non-trivial sensitivity.
    first_active = find(col_norms > 1e-20, 1);
    dv           = zeros(m, 1);
    dv(first_active) = 1;

    fprintf('\n%s\n', repmat('=', 1, 60));
    fprintf('Taylor Performance Test: %s\n', example_name);
    fprintf('%s\n', repmat('=', 1, 60));
    fprintf('Primary perturbation direction: e_%d\n\n', first_active);

    all_pass = true;

    % ------------------------------------------------------------------
    % Single-direction convergence test
    % ------------------------------------------------------------------
    err = zeros(4, n_h);
    for idx = 1:n_h
        h       = h_vals(idx);
        dx      = h * dv;
        y_exact = eval_nonlinear(f, x0 + dx);
        for ord = 0:3
            err(ord+1, idx) = ...
                norm(y_exact - eval_taylor_approx(f, x0, dx, ord)) / norm_y0;
        end
    end

    slopes = zeros(1, 4);
    for ord = 0:3
        p            = polyfit(log_h, log(err(ord+1, 1:n_fit))', 1);
        slopes(ord+1) = p(1);
    end

    fprintf('%-10s %-16s %-16s %-6s\n', 'Order', 'Meas. Slope', 'Exp. Slope', 'Result');
    fprintf('%s\n', repmat('-', 1, 52));
    for ord = 0:3
        pass = abs(slopes(ord+1) - expected_slopes(ord+1)) <= tol;
        if ~pass, all_pass = false; end
        fprintf('%-10d %-16.4f %-16d %-6s\n', ord, slopes(ord+1), ...
            expected_slopes(ord+1), result_strs{pass + 1});
    end
    fprintf('%s\n', repmat('-', 1, 52));

    % ------------------------------------------------------------------
    % Monotonicity check at h = 0.01
    % ------------------------------------------------------------------
    h_test    = 0.01;
    dx_test   = h_test * dv;
    y_ex      = eval_nonlinear(f, x0 + dx_test);
    errs_mono = zeros(4, 1);
    for ord = 0:3
        errs_mono(ord+1) = ...
            norm(y_ex - eval_taylor_approx(f, x0, dx_test, ord)) / norm_y0;
    end
    mono_pass = all(diff(errs_mono) < 0);
    if ~mono_pass, all_pass = false; end

    fprintf('\nMonotonicity at h=0.01 (each higher order must reduce the error):\n');
    for ord = 0:3
        fprintf('  Order %d: %.6e\n', ord, errs_mono(ord+1));
    end
    fprintf('Monotonicity: %s\n', result_strs{mono_pass + 1});

    % ------------------------------------------------------------------
    % Multi-direction convergence test (each active axis direction)
    % ------------------------------------------------------------------
    fprintf('\nMulti-Direction Convergence Test:\n');
    fprintf('%-12s %-13s %-13s %-13s %-13s %-6s\n', ...
        'Direction', 'Slope(k=0)', 'Slope(k=1)', 'Slope(k=2)', 'Slope(k=3)', 'Result');
    fprintf('%s\n', repmat('-', 1, 74));

    for dir = 1:m
        if col_norms(dir) < 1e-20
            fprintf('%-12s  (skipped: no sensitivity)\n', sprintf('e_%d', dir));
            continue;
        end

        ev = zeros(m, 1);
        ev(dir) = 1;

        err_dir = zeros(4, n_fit);
        for idx = 1:n_fit
            h       = h_vals(idx);
            dx      = h * ev;
            y_exact = eval_nonlinear(f, x0 + dx);
            for ord = 0:3
                err_dir(ord+1, idx) = ...
                    norm(y_exact - eval_taylor_approx(f, x0, dx, ord)) / norm_y0;
            end
        end

        slopes_dir = zeros(1, 4);
        for ord = 0:3
            p               = polyfit(log_h, log(err_dir(ord+1, :))', 1);
            slopes_dir(ord+1) = p(1);
        end

        dir_pass = all(abs(slopes_dir - expected_slopes) <= tol);
        if ~dir_pass, all_pass = false; end
        fprintf('%-12s %-13.4f %-13.4f %-13.4f %-13.4f %-6s\n', ...
            sprintf('e_%d', dir), slopes_dir(1), slopes_dir(2), ...
            slopes_dir(3), slopes_dir(4), result_strs{dir_pass + 1});
    end

    fprintf('\n%s\n', repmat('=', 1, 60));
    fprintf('Overall: %s\n', result_strs{all_pass + 1});
    fprintf('%s\n\n', repmat('=', 1, 60));
end
