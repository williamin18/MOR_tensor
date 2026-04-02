function fstruct = build_example_e1()
% NPN BJT in common-emitter configuration (Ebers-Moll model).
%
% State variables: x = [VB, VC, VE, Vcc]
%   VB  = base voltage
%   VC  = collector voltage
%   VE  = emitter voltage
%   Vcc = supply rail (typically held constant by a source)
%
% Junctions:
%   BE: Vbe = VB - VE,  coeff = [1, 0, -1, 0]
%   BC: Vbc = VB - VC,  coeff = [1, -1, 0, 0]
%
% Device parameters:
%   Is    = 1e-14 A  (saturation current)
%   Vt    = 0.026 V  (thermal voltage at ~300 K)
%   betaF = 100      (forward current gain)
%   betaR = 4        (reverse current gain)
%   alphaF = betaF / (betaF + 1)
%   alphaR = betaR / (betaR + 1)
%
% Nonlinear KCL contributions (Ebers-Moll):
%   y(1) = IB = (Is/betaF)*exp(Vbe/Vt) + (Is/betaR)*exp(Vbc/Vt)
%   y(2) = IC = alphaF*Is*exp(Vbe/Vt)  + (Is/alphaR)*exp(Vbc/Vt)
%   y(3) = IE = Is*(1+1/betaF)*exp(Vbe/Vt) + Is*exp(Vbc/Vt)
%   y(4) = supply rail, no nonlinear elements

    Is    = 1e-14;
    Vt    = 0.026;
    betaF = 100;
    betaR = 4;
    alphaF = betaF / (betaF + 1);   % 100/101
    alphaR = betaR / (betaR + 1);   % 4/5

    % y(1): base current IB
    fstruct(1).terms(1) = struct('Is', Is/betaF,        'coeff', [1,  0, -1,  0], 'Vt', Vt);
    fstruct(1).terms(2) = struct('Is', Is/betaR,        'coeff', [1, -1,  0,  0], 'Vt', Vt);

    % y(2): collector current IC
    fstruct(2).terms(1) = struct('Is', alphaF * Is,     'coeff', [1,  0, -1,  0], 'Vt', Vt);
    fstruct(2).terms(2) = struct('Is', Is / alphaR,     'coeff', [1, -1,  0,  0], 'Vt', Vt);

    % y(3): emitter current IE (magnitude)
    fstruct(3).terms(1) = struct('Is', Is*(1+1/betaF),  'coeff', [1,  0, -1,  0], 'Vt', Vt);
    fstruct(3).terms(2) = struct('Is', Is,              'coeff', [1, -1,  0,  0], 'Vt', Vt);

    % y(4): supply rail — no nonlinear elements
    fstruct(4).terms = [];
end
