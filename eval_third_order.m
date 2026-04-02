function T = eval_third_order(fstruct, x)
    % eval_third_order  Compute the third-order derivative tensor of f(x) w.r.t. x.
    %
    %   T = eval_third_order(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of structs describing the nonlinear system
    %     x       - m x 1 input vector
    %
    %   Output:
    %     T - n x m x m x m tensor where T(i,j,l,p) = d^3 f_i / (dx_j dx_l dx_p)
    %
    %   Each term in fstruct(i).terms contributes:
    %     d^3 f_i / (dx_j dx_l dx_p) += (Is / Vt^3) * coeff(j) * coeff(l) * coeff(p) * exp(coeff' * x / Vt)

    n = length(fstruct);
    m = length(x);
    T = zeros(n, m, m, m);

    for i = 1:n
        terms = fstruct(i).terms;

        for k = 1:length(terms)
            t = terms(k);

            exponent = (t.coeff * x) / t.Vt;
            scale    = (t.Is / t.Vt^3) * exp(exponent);

            % Compute outer product coeff ⊗ coeff ⊗ coeff (m x m x m tensor)
            coeff_outer = zeros(m, m, m);
            for j = 1:m
                coeff_outer(j,:,:) = t.coeff(j) * (t.coeff' * t.coeff);
            end

            T(i,:,:,:) = squeeze(T(i,:,:,:)) + scale * coeff_outer;
        end
    end
end
