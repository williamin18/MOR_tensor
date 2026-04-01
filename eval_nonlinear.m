function y = eval_nonlinear(fstruct, x)
    n = length(fstruct);
    y = zeros(n,1);

    for i = 1:n
        terms = fstruct(i).terms;

        for k = 1:length(terms)
            t = terms(k);

            exponent = (t.coeff * x) / t.Vt;
            y(i) = y(i) + t.Is * exp(exponent);
        end
    end
end