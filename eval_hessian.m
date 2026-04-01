function H = eval_hessian(fstruct, x)
    % eval_hessian  Compute the Hessian tensor of f(x) w.r.t. x.
    %
    %   H = eval_hessian(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of structs describing the nonlinear system
    %     x       - m x 1 input vector
    %
    %   Output:
    %     H - n x m x m tensor where H(i,j,l) = d^2 f_i / (dx_j dx_l)
    %
    %   Each term in fstruct(i).terms contributes:
    %     d^2 f_i / (dx_j dx_l) += (Is / Vt^2) * coeff(j) * coeff(l) * exp(coeff' * x / Vt)

    n = length(fstruct);
    m = length(x);
    H = zeros(n, m, m);

    for i = 1:n
        terms = fstruct(i).terms;

        for k = 1:length(terms)
            t = terms(k);

            exponent = (t.coeff * x) / t.Vt;
            scale    = (t.Is / t.Vt^2) * exp(exponent);
            H(i,:,:) = squeeze(H(i,:,:)) + scale * (t.coeff' * t.coeff);
        end
    end
end
