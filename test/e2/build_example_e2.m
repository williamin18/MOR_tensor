function fstruct = build_example_e2()
% Darlington pair: two cascaded NPN BJTs (Q1 drives Q2).
%
% State variables: x = [VB1, VC, VM, VE2, Vcc]
%   VB1 = base of Q1
%   VC  = shared collector (Q1 and Q2 tied together)
%   VM  = middle node: emitter of Q1 = base of Q2
%   VE2 = emitter of Q2
%   Vcc = supply rail
%
% Junctions:
%   Q1 BE: Vbe1 = VB1 - VM,  coeff = [1,  0, -1,  0, 0]
%   Q1 BC: Vbc1 = VB1 - VC,  coeff = [1, -1,  0,  0, 0]
%   Q2 BE: Vbe2 = VM  - VE2, coeff = [0,  0,  1, -1, 0]
%   Q2 BC: Vbc2 = VM  - VC,  coeff = [0, -1,  1,  0, 0]
%
% Device parameters:
%   Is1 = 1e-14 A, Is2 = 5e-15 A  (Q1 larger device)
%   Vt    = 0.026 V
%   betaF = 100, betaR = 4
%   alphaF = betaF / (betaF + 1)
%   alphaR = betaR / (betaR + 1)
%
% Nonlinear KCL contributions:
%   y(1) = IB1 = (Is1/betaF)*exp(Vbe1/Vt) + (Is1/betaR)*exp(Vbc1/Vt)
%
%   y(2) = IC  = alphaF*Is1*exp(Vbe1/Vt) + (Is1/alphaR)*exp(Vbc1/Vt)
%              + alphaF*Is2*exp(Vbe2/Vt) + (Is2/alphaR)*exp(Vbc2/Vt)
%
%   y(3) = I_VM (Q1 emitter / Q2 base node)
%        = Is1*(1+1/betaF)*exp(Vbe1/Vt) + Is1*exp(Vbc1/Vt)
%        + (Is2/betaF)*exp(Vbe2/Vt)     + (Is2/betaR)*exp(Vbc2/Vt)
%
%   y(4) = IE2 = Is2*(1+1/betaF)*exp(Vbe2/Vt) + Is2*exp(Vbc2/Vt)
%
%   y(5) = supply rail, no nonlinear elements

    Is1   = 1e-14;
    Is2   = 5e-15;
    Vt    = 0.026;
    betaF = 100;
    betaR = 4;
    alphaF = betaF / (betaF + 1);   % 100/101
    alphaR = betaR / (betaR + 1);   % 4/5

    % y(1): base current of Q1
    fstruct(1).terms(1) = struct('Is', Is1/betaF,         'coeff', [1,  0, -1,  0,  0], 'Vt', Vt);
    fstruct(1).terms(2) = struct('Is', Is1/betaR,         'coeff', [1, -1,  0,  0,  0], 'Vt', Vt);

    % y(2): collector current (Q1 + Q2 contributions, 4 terms)
    fstruct(2).terms(1) = struct('Is', alphaF * Is1,      'coeff', [1,  0, -1,  0,  0], 'Vt', Vt);
    fstruct(2).terms(2) = struct('Is', Is1 / alphaR,      'coeff', [1, -1,  0,  0,  0], 'Vt', Vt);
    fstruct(2).terms(3) = struct('Is', alphaF * Is2,      'coeff', [0,  0,  1, -1,  0], 'Vt', Vt);
    fstruct(2).terms(4) = struct('Is', Is2 / alphaR,      'coeff', [0, -1,  1,  0,  0], 'Vt', Vt);

    % y(3): current at middle node VM (Q1 emitter / Q2 base), 4 terms
    fstruct(3).terms(1) = struct('Is', Is1*(1+1/betaF),   'coeff', [1,  0, -1,  0,  0], 'Vt', Vt);
    fstruct(3).terms(2) = struct('Is', Is1,               'coeff', [1, -1,  0,  0,  0], 'Vt', Vt);
    fstruct(3).terms(3) = struct('Is', Is2/betaF,         'coeff', [0,  0,  1, -1,  0], 'Vt', Vt);
    fstruct(3).terms(4) = struct('Is', Is2/betaR,         'coeff', [0, -1,  1,  0,  0], 'Vt', Vt);

    % y(4): emitter current of Q2
    fstruct(4).terms(1) = struct('Is', Is2*(1+1/betaF),   'coeff', [0,  0,  1, -1,  0], 'Vt', Vt);
    fstruct(4).terms(2) = struct('Is', Is2,               'coeff', [0, -1,  1,  0,  0], 'Vt', Vt);

    % y(5): supply rail — no nonlinear elements
    fstruct(5).terms = [];
end
