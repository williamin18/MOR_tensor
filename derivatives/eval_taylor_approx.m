function y_approx = eval_taylor_approx(fstruct, x0, dx, order)
    % eval_taylor_approx  Evaluate the Taylor series approximation of fstruct at x0 + dx.
    %
    %   y_approx = eval_taylor_approx(fstruct, x0, dx, order)
    %
    %   Inputs:
    %     fstruct - array of structs describing the nonlinear system (see eval_nonlinear)
    %     x0      - m x 1 expansion point
    %     dx      - m x 1 perturbation vector
    %     order   - Taylor expansion order: 0, 1, 2, or 3
    %
    %   Output:
    %     y_approx - n x 1 Taylor approximation of f(x0 + dx)
    %
    %   Approximation formula:
    %     order 0: f(x0)
    %     order 1: f(x0) + J*dx
    %     order 2: f(x0) + J*dx + (1/2) * H:(dx,dx)
    %     order 3: f(x0) + J*dx + (1/2) * H:(dx,dx) + (1/6) * T:(dx,dx,dx)

    y_approx = eval_nonlinear(fstruct, x0);

    if order >= 1
        J = eval_jacobian(fstruct, x0);
        y_approx = y_approx + J * dx;
    end

    if order >= 2
        H  = eval_hessian(fstruct, x0);
        n  = size(H, 1);
        h2 = zeros(n, 1);
        for i = 1:n
            Hi    = squeeze(H(i,:,:));
            h2(i) = dx' * Hi * dx;
        end
        y_approx = y_approx + 0.5 * h2;
    end

    if order >= 3
        T  = eval_third_order(fstruct, x0);
        n  = size(T, 1);
        m  = length(dx);
        t3 = zeros(n, 1);
        for i = 1:n
            Ti  = squeeze(T(i,:,:,:));
            val = 0;
            for j = 1:m
                val = val + dx(j) * (dx' * squeeze(Ti(j,:,:)) * dx);
            end
            t3(i) = val;
        end
        y_approx = y_approx + (1/6) * t3;
    end
end
