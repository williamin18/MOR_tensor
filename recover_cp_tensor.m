function T = recover_cp_tensor(CP)
    % recover_cp_tensor  Recover a full tensor from its CP decomposition.
    %
    %   T = recover_cp_tensor(CP)
    %
    %   Input:
    %     CP - m x R x k array storing the CP decomposition.
    %          CP(:, r, d) is the d-th factor vector for rank-1 term r.
    %
    %   Output:
    %     T - k-order tensor of size m x m x ... x m (k dimensions)
    %         T(i_1,...,i_k) = sum_{r=1}^{R} prod_{d=1}^{k} CP(i_d, r, d)
    %
    %   Example: for k=3 (Hessian),
    %     T = recover_cp_tensor(eval_hessian_cp(fstruct, x))
    %   gives the same m x m x m tensor as eval_hessian(fstruct, x).

    [m, R, k] = size(CP);

    % Allocate full k-order tensor
    sz = m * ones(1, k);
    T  = zeros(sz);

    for r = 1:R
        % Build rank-1 outer product of the k factor vectors via broadcasting.
        % Start with scalar 1 and iteratively multiply each factor vector
        % reshaped to be along its own dimension.
        term = 1;
        for d = 1:k
            vec      = CP(:, r, d);          % m x 1
            new_dims        = ones(1, k);
            new_dims(d)     = m;
            term = term .* reshape(vec, new_dims);
        end
        T = T + term;
    end
end
