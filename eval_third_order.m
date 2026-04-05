function T = eval_third_order(fstruct, x)
    % eval_third_order  Compute the third-order derivative tensor of f(x) w.r.t. x.
    %
    %   T = eval_third_order(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of element structs (see eval_nonlinear)
    %     x       - m x 1 node-voltage vector
    %
    %   Output:
    %     T - m x m x m x m tensor where T(i,j,l,p) = d^3 f_i / (dx_j dx_l dx_p)
    %
    %   For each element with junction voltage u = c*x:
    %     scale3 = (Is / Vt^3) * exp(u / Vt)
    %   Contributions are scattered to terminal rows with appropriate weights:
    %     T(node_row, :, :, :) += weight * scale3 * (c ⊗ c ⊗ c)

    m = length(x);
    T = zeros(m, m, m, m);

    for k = 1:length(fstruct)
        elem = fstruct(k);
        nd   = elem.nodes;

        c = zeros(1, m);

        if strcmp(elem.type, 'diode')
            c(nd(1)) =  1;
            c(nd(2)) = -1;
            u      = c * x;
            scale3 = (elem.Is / elem.Vt^3) * exp(u / elem.Vt);

            % Compute outer product c ⊗ c ⊗ c  (m x m x m tensor)
            coeff_outer = zeros(m, m, m);
            for j = 1:m
                coeff_outer(j, :, :) = c(j) * (c' * c);
            end

            T(nd(1), :, :, :) = squeeze(T(nd(1), :, :, :)) + scale3 * coeff_outer;
            T(nd(2), :, :, :) = squeeze(T(nd(2), :, :, :)) - scale3 * coeff_outer;

        elseif strcmp(elem.type, 'npn_bjt')
            c(nd(1)) =  1;   % base
            c(nd(3)) = -1;   % emitter
            u      = c * x;
            scale3 = (elem.Is / elem.Vt^3) * exp(u / elem.Vt);

            % Compute outer product c ⊗ c ⊗ c  (m x m x m tensor)
            coeff_outer = zeros(m, m, m);
            for j = 1:m
                coeff_outer(j, :, :) = c(j) * (c' * c);
            end

            T(nd(1), :, :, :) = squeeze(T(nd(1), :, :, :)) + scale3 / (elem.beta + 1) * coeff_outer;
            T(nd(2), :, :, :) = squeeze(T(nd(2), :, :, :)) + scale3 * elem.beta / (elem.beta + 1) * coeff_outer;
            T(nd(3), :, :, :) = squeeze(T(nd(3), :, :, :)) - scale3 * coeff_outer;
        elseif strcmp(elem.type, 'resistor')
            % Linear element: no third-order contribution.
        end
    end
end
