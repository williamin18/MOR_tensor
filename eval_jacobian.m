function J = eval_jacobian(fstruct, x)
    n = length(fstruct);
    m = length(x);
    J = zeros(n, m);

    for i = 1:n
        terms = fstruct(i).terms;

        for k = 1:length(terms)
            t = terms(k);

            exponent = (t.coeff * x) / t.Vt;
            scale    = (t.Is / t.Vt) * exp(exponent);
            J(i,:)   = J(i,:) + scale * t.coeff;
        end
    end
end
