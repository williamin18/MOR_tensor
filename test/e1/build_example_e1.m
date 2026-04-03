function fstruct = build_example_e1()
% NPN BJT in common-emitter configuration (simplified forward-active model).
%
% State variables: x = [VB, VC, VE, Vcc]
%   VB  = base voltage      (node 1)
%   VC  = collector voltage  (node 2)
%   VE  = emitter voltage   (node 3)
%   Vcc = supply rail       (node 4, no nonlinear element)
%
% Device parameters:
%   Is   = 1e-14 A  (saturation current)
%   Vt   = 0.026 V  (thermal voltage at ~300 K)
%   beta = 100      (forward current gain)
%
% Device model (BE junction, forward-active):
%   Ie = Is * (exp((VB - VE) / Vt) - 1)
%   Ib = Ie / (beta + 1)
%   Ic = beta * Ie / (beta + 1)
%
% KCL contributions:
%   y(1) += Ib    (base)
%   y(2) += Ic    (collector)
%   y(3) -= Ie    (emitter)

    fstruct(1).type  = 'npn_bjt';
    fstruct(1).nodes = [1, 2, 3];   % [base, collector, emitter]
    fstruct(1).Is    = 1e-14;
    fstruct(1).Vt    = 0.026;
    fstruct(1).beta  = 100;
end
