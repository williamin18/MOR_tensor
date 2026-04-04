function y = eval_nonlinear(fstruct, x)
    % eval_nonlinear  Evaluate the nonlinear KCL residual f(x).
    %
    %   y = eval_nonlinear(fstruct, x)
    %
    %   Inputs:
    %     fstruct - array of element structs (one per nonlinear device).
    %               Each struct has fields: type, nodes, Is, Vt, beta.
    %               Supported types: 'diode', 'npn_bjt'.
    %     x       - m x 1 node-voltage vector
    %
    %   Output:
    %     y - m x 1 nonlinear current vector (KCL contributions)
    %
    %   Device models:
    %     Diode:   I = Is * (exp((x(a) - x(c)) / Vt) - 1)
    %              y(anode) += I,  y(cathode) -= I
    %
    %     NPN BJT (forward-active, BE junction):
    %              Ie = Is * (exp((x(b) - x(e)) / Vt) - 1)
    %              Ib = Ie / (beta + 1),  Ic = beta * Ie / (beta + 1)
    %              y(base) += Ib,  y(collector) += Ic,  y(emitter) -= Ie

    m = length(x);
    y = zeros(m, 1);

    for k = 1:length(fstruct)
        elem = fstruct(k);
        nd   = elem.nodes;

        if strcmp(elem.type, 'diode')
            u  = x(nd(1)) - x(nd(2));
            I  = elem.Is * (exp(u / elem.Vt) - 1);
            y(nd(1)) = y(nd(1)) + I;
            y(nd(2)) = y(nd(2)) - I;

        elseif strcmp(elem.type, 'npn_bjt')
            u  = x(nd(1)) - x(nd(3));   % Vbe = Vbase - Vemitter
            Ie = elem.Is * (exp(u / elem.Vt) - 1);
            Ib = Ie / (elem.beta + 1);
            Ic = elem.beta * Ie / (elem.beta + 1);
            y(nd(1)) = y(nd(1)) + Ib;   % base
            y(nd(2)) = y(nd(2)) + Ic;   % collector
            y(nd(3)) = y(nd(3)) - Ie;   % emitter

        elseif strcmp(elem.type, 'resistor')
            % nodes = [a, b], R = resistance
            % I = (x(a) - x(b)) / R  flows from node a toward node b
            G = 1 / elem.R;
            I = G * (x(nd(1)) - x(nd(2)));
            y(nd(1)) = y(nd(1)) + I;
            y(nd(2)) = y(nd(2)) - I;
        end
    end
end