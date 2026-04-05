function CP = eval_hessian_cp(fstruct, x)
    % eval_hessian_cp  Compute the Hessian tensor in CP decomposition format.
    %
    %   CP = eval_hessian_cp(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of element structs (see eval_nonlinear)
    %     x       - m x 1 node-voltage vector
    %
    %   Output:
    %     CP - m x R x 3 array storing the CP decomposition of the Hessian H.
    %          R is the number of nonlinear elements (diodes + BJTs).
    %          The full tensor can be recovered as:
    %            H(i,j,l) = sum_{r=1}^{R} CP(i,r,1) * CP(j,r,2) * CP(l,r,3)
    %          The scalar weight scale2 is folded into factor 1: CP(:,r,1) = scale2 * d_e.
    %
    %   For each nonlinear element with junction voltage u = c'*x:
    %     scale2 = (Is / Vt^2) * exp(u / Vt)
    %   The output-distribution vector d_e encodes how the device current maps to
    %   node equations; the input-sensitivity vector c_e encodes the junction voltage.
    %   Resistors contribute no rank-1 terms (linear elements).

    m = length(x);

    % Count nonlinear elements to determine CP rank R
    R = 0;
    for k = 1:length(fstruct)
        if strcmp(fstruct(k).type, 'diode') || strcmp(fstruct(k).type, 'npn_bjt')
            R = R + 1;
        end
    end

    CP = zeros(m, R, 3);
    r  = 0;

    for k = 1:length(fstruct)
        elem = fstruct(k);
        nd   = elem.nodes;

        c = zeros(m, 1);

        if strcmp(elem.type, 'diode')
            c(nd(1)) =  1;
            c(nd(2)) = -1;
            u      = c' * x;
            scale2 = (elem.Is / elem.Vt^2) * exp(u / elem.Vt);

            % For a diode the output-distribution vector equals c
            d = c;

            r = r + 1;
            CP(:, r, 1) = scale2 * d;
            CP(:, r, 2) = c;
            CP(:, r, 3) = c;

        elseif strcmp(elem.type, 'npn_bjt')
            c(nd(1)) =  1;   % base
            c(nd(3)) = -1;   % emitter
            u      = c' * x;
            scale2 = (elem.Is / elem.Vt^2) * exp(u / elem.Vt);

            % Output-distribution vector for the BJT
            d = zeros(m, 1);
            d(nd(1)) =  1 / (elem.beta + 1);
            d(nd(2)) =  elem.beta / (elem.beta + 1);
            d(nd(3)) = -1;

            r = r + 1;
            CP(:, r, 1) = scale2 * d;
            CP(:, r, 2) = c;
            CP(:, r, 3) = c;

        end
        % Resistors are linear: no second-order contribution.
    end
end
