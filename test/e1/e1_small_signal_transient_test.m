% e1_small_signal_transient_test.m
% Small signal time-domain transient analysis of the NPN BJT (Example 1)
% using Newton's method.
%
% At each time step the nonlinear KCL system
%
%   eval_nonlinear(f, x)(free_nodes) = b_dc(free_nodes) + u(t) * e_base(free_nodes)
%
% is solved via Newton iterations, where u(t) is a small sinusoidal signal
% injected at the base node.  Nodes 3 (VE = 0) and 4 (Vcc = 12 V) are
% voltage-constrained and remain fixed throughout; only the free nodes
% free_nodes = [1, 2] (VB and VC) are updated.
%
% Two methods are compared:
%
%   (A) Standard Newton:
%       Jacobian J(x_k) is recomputed from x_k at every iteration.
%
%   (B) Taylor Newton with backtracking line search:
%       Jacobian is approximated by the first-order Taylor expansion
%       around the DC operating point x_dc:
%           J(x_k) ≈ J(x_dc) + sum_j H(x_dc)(i,j,k) * (x_k - x_dc)(j)
%       Only J0 = eval_jacobian(f, x_dc) and H0 = eval_hessian(f, x_dc)
%       are computed once before the time loop.  A backtracking line
%       search (Armijo) scales each step so that ||r|| strictly decreases,
%       which prevents divergence when the Taylor approximation of J
%       underestimates the true (exponential) Jacobian.
%
% Pass criteria:
%   1. Both methods converge at every time step.
%   2. Maximum pointwise solution difference is below tol_sol.

f    = build_example_e1();
x_dc = [0.70; 5.0; 0.0; 12.0];           % DC operating point
b_dc = eval_nonlinear(f, x_dc);           % KCL residual at DC point (= 0 at free nodes)
m    = length(x_dc);

% Nodes whose voltages are solved by Newton (VB=1, VC=2).
% Nodes 3 (VE=0) and 4 (Vcc=12) are voltage-constrained and held fixed.
free_nodes = [1, 2];

% Pre-compute Jacobian and Hessian at the DC operating point once.
J0 = eval_jacobian(f, x_dc);              % m x m
H0 = eval_hessian(f, x_dc);              % m x m x m  (H0(i,j,k) = d^2 f_i/dx_j dx_k)

% Time-domain setup: sinusoidal perturbation injected at base node.
T_period  = 1.0e-3;                       % signal period [s]
n_periods = 3;
n_steps   = 30 * n_periods;               % 30 steps per period
t_vec     = linspace(0, n_periods * T_period, n_steps);
amplitude = 1.0e-4;                       % signal amplitude [A]

e_base      = zeros(m, 1);
e_base(1)   = 1;                          % perturb KCL at base node (node 1)

% Newton solver settings.
max_iter  = 50;
tol_res   = 1e-12;
max_ls    = 30;    % maximum backtracking halvings

% Set verbose = true to print per-iteration diagnostics.
verbose = false;

% Result storage.
x_std  = zeros(m, n_steps);
x_tay  = zeros(m, n_steps);
ok_std = true(1, n_steps);
ok_tay = true(1, n_steps);

for t_idx = 1:n_steps
    t   = t_vec(t_idx);
    u_t = amplitude * sin(2 * pi / T_period * t);
    b_t = b_dc + u_t * e_base;

    % (A) Standard Newton: recompute J(x_k) at each iteration.
    x_k       = x_dc;
    converged = false;
    for iter = 1:max_iter
        r = eval_nonlinear(f, x_k) - b_t;
        if norm(r(free_nodes)) <= tol_res
            converged = true;
            break;
        end
        J_k   = eval_jacobian(f, x_k);
        delta = J_k(free_nodes, free_nodes) \ r(free_nodes);
        x_k(free_nodes) = x_k(free_nodes) - delta;

        if verbose
            fprintf('  StdNewton  t_idx=%2d iter=%2d |r|=%.3e\n', ...
                t_idx, iter, norm(r(free_nodes)));
        end
    end
    x_std(:, t_idx) = x_k;
    ok_std(t_idx)   = converged;
    if ~converged
        r_debug = eval_nonlinear(f, x_k) - b_t;
        fprintf('[DEBUG] Standard Newton failed at t_idx=%d (t=%.4e s), |r|=%.3e\n', ...
            t_idx, t, norm(r_debug(free_nodes)));
    end

    % (B) Taylor Newton with backtracking line search.
    %     J(x_k) ≈ J0 + sum_j H0(:,j,:) * (x_k - x_dc)(j).
    %     The backtracking line search halves the step alpha until ||r|| decreases,
    %     preventing divergence when J_approx underestimates the true Jacobian.
    x_k       = x_dc;
    converged = false;
    for iter = 1:max_iter
        r       = eval_nonlinear(f, x_k) - b_t;
        r_norm  = norm(r(free_nodes));
        if r_norm <= tol_res
            converged = true;
            break;
        end

        dx       = x_k - x_dc;
        J_approx = J0;
        for j = 1:m
            J_approx = J_approx + dx(j) * squeeze(H0(:, j, :));
        end
        delta = J_approx(free_nodes, free_nodes) \ r(free_nodes);

        % Backtracking line search: halve alpha until ||r|| strictly decreases.
        alpha = 1.0;
        x_try = x_k;
        x_try(free_nodes) = x_k(free_nodes) - alpha * delta;
        for ls = 1:max_ls
            r_try = eval_nonlinear(f, x_try) - b_t;
            if norm(r_try(free_nodes)) < r_norm
                break;
            end
            alpha = alpha * 0.5;
            x_try(free_nodes) = x_k(free_nodes) - alpha * delta;
        end
        x_k = x_try;

        if verbose
            fprintf('  TayNewton  t_idx=%2d iter=%2d |r|=%.3e alpha=%.3e\n', ...
                t_idx, iter, r_norm, alpha);
        end
    end
    x_tay(:, t_idx) = x_k;
    ok_tay(t_idx)   = converged;
    if ~converged
        r_final = eval_nonlinear(f, x_k) - b_t;
        fprintf('[DEBUG] Taylor Newton failed at t_idx=%d (t=%.4e s), |r|=%.3e\n', ...
            t_idx, t, norm(r_final(free_nodes)));
    end
end

% Evaluate results.
result_str         = {'FAIL', 'PASS'};
all_std_converged  = all(ok_std);
all_tay_converged  = all(ok_tay);
max_err            = max(sqrt(sum((x_std - x_tay).^2, 1)));
tol_sol            = 1e-6;
solutions_agree    = (max_err < tol_sol);

fprintf('\n%s\n', repmat('=', 1, 60));
fprintf('Small Signal Transient Test: e1 (NPN BJT)\n');
fprintf('%s\n', repmat('=', 1, 60));
fprintf('DC operating point: VB=%.3f  VC=%.2f  VE=%.1f  Vcc=%.1f\n', ...
    x_dc(1), x_dc(2), x_dc(3), x_dc(4));
fprintf('Signal amplitude: %.2e A,  periods: %d,  steps: %d\n\n', ...
    amplitude, n_periods, n_steps);

fprintf('Standard Newton converged at all steps:       %s\n', ...
    result_str{all_std_converged + 1});
fprintf('Taylor Newton   converged at all steps:       %s\n', ...
    result_str{all_tay_converged + 1});
fprintf('Max solution difference between methods:      %.3e\n', max_err);
fprintf('Solutions agree within tolerance (%.0e):  %s\n', ...
    tol_sol, result_str{solutions_agree + 1});

all_pass = all_std_converged && all_tay_converged && solutions_agree;
fprintf('\n%s\n', repmat('-', 1, 60));
fprintf('Overall: %s\n', result_str{all_pass + 1});
fprintf('%s\n\n', repmat('=', 1, 60));
