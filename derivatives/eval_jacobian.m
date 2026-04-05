function J = eval_jacobian(fstruct, x)
    % eval_jacobian  Compute the Jacobian matrix of f(x) w.r.t. x.
    %
    %   J = eval_jacobian(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of element structs (see eval_nonlinear)
    %     x       - m x 1 node-voltage vector
    %
    %   Output:
    %     J - m x m matrix where J(i,j) = d f_i / d x_j
    %
    %   The -1 constant in each device model vanishes under differentiation.
    %   For each element with junction voltage u = c*x:
    %     scale = (Is / Vt) * exp(u / Vt)
    %   Contributions are scattered to terminal rows with appropriate weights.

    m = length(x);
    J = zeros(m, m);

    for k = 1:length(fstruct)
        elem = fstruct(k);
        nd   = elem.nodes;

        % Build coefficient row vector c (1 x m)
        c = zeros(1, m);

        if strcmp(elem.type, 'diode')
            c(nd(1)) =  1;
            c(nd(2)) = -1;
            u     = c * x;
            scale = (elem.Is / elem.Vt) * exp(u / elem.Vt);
            J(nd(1), :) = J(nd(1), :) + scale * c;
            J(nd(2), :) = J(nd(2), :) - scale * c;

        elseif strcmp(elem.type, 'npn_bjt')
            c(nd(1)) =  1;   % base
            c(nd(3)) = -1;   % emitter
            u     = c * x;
            scale = (elem.Is / elem.Vt) * exp(u / elem.Vt);
            J(nd(1), :) = J(nd(1), :) + scale / (elem.beta + 1) * c;
            J(nd(2), :) = J(nd(2), :) + scale * elem.beta / (elem.beta + 1) * c;
            J(nd(3), :) = J(nd(3), :) - scale * c;

        elseif strcmp(elem.type, 'resistor')
            % nodes = [a, b], R = resistance
            % Conductance stamp: G added to (a,a) and (b,b), -G to (a,b) and (b,a).
            G = 1 / elem.R;
            J(nd(1), nd(1)) = J(nd(1), nd(1)) + G;
            J(nd(1), nd(2)) = J(nd(1), nd(2)) - G;
            J(nd(2), nd(1)) = J(nd(2), nd(1)) - G;
            J(nd(2), nd(2)) = J(nd(2), nd(2)) + G;
        end
    end
end
