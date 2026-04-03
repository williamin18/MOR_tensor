function H = eval_hessian(fstruct, x)
    % eval_hessian  Compute the Hessian tensor of f(x) w.r.t. x.
    %
    %   H = eval_hessian(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of element structs (see eval_nonlinear)
    %     x       - m x 1 node-voltage vector
    %
    %   Output:
    %     H - m x m x m tensor where H(i,j,l) = d^2 f_i / (dx_j dx_l)
    %
    %   For each element with junction voltage u = c*x:
    %     scale2 = (Is / Vt^2) * exp(u / Vt)
    %   Contributions are scattered to terminal rows with appropriate weights:
    %     H(node_row, :, :) += weight * scale2 * (c' * c)

    m = length(x);
    H = zeros(m, m, m);

    for k = 1:length(fstruct)
        elem = fstruct(k);
        nd   = elem.nodes;

        c = zeros(1, m);

        if strcmp(elem.type, 'diode')
            c(nd(1)) =  1;
            c(nd(2)) = -1;
            u      = c * x;
            scale2 = (elem.Is / elem.Vt^2) * exp(u / elem.Vt);
            cc     = c' * c;
            H(nd(1), :, :) = squeeze(H(nd(1), :, :)) + scale2 * cc;
            H(nd(2), :, :) = squeeze(H(nd(2), :, :)) - scale2 * cc;

        elseif strcmp(elem.type, 'npn_bjt')
            c(nd(1)) =  1;   % base
            c(nd(3)) = -1;   % emitter
            u      = c * x;
            scale2 = (elem.Is / elem.Vt^2) * exp(u / elem.Vt);
            cc     = c' * c;
            H(nd(1), :, :) = squeeze(H(nd(1), :, :)) + scale2 / (elem.beta + 1) * cc;
            H(nd(2), :, :) = squeeze(H(nd(2), :, :)) + scale2 * elem.beta / (elem.beta + 1) * cc;
            H(nd(3), :, :) = squeeze(H(nd(3), :, :)) - scale2 * cc;
        end
    end
end
