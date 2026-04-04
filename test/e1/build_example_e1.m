function fstruct = build_example_e1()
% NPN BJT common-emitter amplifier (simplified forward-active model).
%
% State variables: x = [VB, VC, VE, Vcc]
%   VB  = base voltage       (node 1)
%   VC  = collector voltage  (node 2)
%   VE  = emitter voltage    (node 3, held at 0 V during transient)
%   Vcc = supply rail        (node 4, held at 12 V during transient)
%
% Device parameters:
%   Is   = 1e-14 A  (saturation current)
%   Vt   = 0.026 V  (thermal voltage at ~300 K)
%   beta = 100      (forward current gain)
%
% Bias resistors (sized so that KCL at nodes 1 and 2 is satisfied with
% zero external excitation at the DC operating point VB=0.78, VC=5, VE=0,
% Vcc=12):
%   RB: base bias resistor, node 4 (Vcc) -> node 1 (base)
%   RC: collector load resistor, node 4 (Vcc) -> node 2 (collector)
%
% KCL contributions at DC:
%   node 1: Ib  + (VB  - Vcc)/RB = 0   =>  RB = (Vcc - VB) / Ib
%   node 2: Ic  + (VC  - Vcc)/RC = 0   =>  RC = (Vcc - VC) / Ic

    Is_val   = 1e-14;
    Vt_val   = 0.026;
    beta_val = 100;

    % DC operating-point voltages (must match x_dc in the test).
    % VB_dc is chosen so that Ib_dc ≈ 1 mA, which ensures that a signal
    % amplitude of 1e-4 A is a true small signal (< 10 % of the DC bias
    % current) and the circuit stays in the forward-active region for both
    % half-cycles of the sinusoidal excitation.
    VB_dc  = 0.78;
    VC_dc  = 5.0;
    VE_dc  = 0.0;
    Vcc_dc = 12.0;

    % DC currents at the operating point.
    Ie_dc = Is_val * (exp((VB_dc - VE_dc) / Vt_val) - 1);
    Ib_dc = Ie_dc / (beta_val + 1);
    Ic_dc = beta_val * Ie_dc / (beta_val + 1);

    % Bias resistors that zero the KCL mismatch at nodes 1 and 2.
    RB = (Vcc_dc - VB_dc) / Ib_dc;   % base bias resistor  [Ohm]
    RC = (Vcc_dc - VC_dc) / Ic_dc;   % collector load      [Ohm]

    % NPN BJT: [base=1, collector=2, emitter=3]
    fstruct(1).type  = 'npn_bjt';
    fstruct(1).nodes = [1, 2, 3];
    fstruct(1).Is    = Is_val;
    fstruct(1).Vt    = Vt_val;
    fstruct(1).beta  = beta_val;

    % Base bias resistor (Vcc node 4 -> base node 1).
    fstruct(2).type  = 'resistor';
    fstruct(2).nodes = [1, 4];
    fstruct(2).R     = RB;

    % Collector load resistor (Vcc node 4 -> collector node 2).
    fstruct(3).type  = 'resistor';
    fstruct(3).nodes = [2, 4];
    fstruct(3).R     = RC;
end
