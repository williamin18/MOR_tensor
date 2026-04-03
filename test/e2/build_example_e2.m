function fstruct = build_example_e2()
% Darlington pair: two cascaded NPN BJTs (Q1 drives Q2).
%
% State variables: x = [VB1, VC, VM, VE2, Vcc]
%   VB1 = base of Q1                        (node 1)
%   VC  = shared collector (Q1 and Q2)      (node 2)
%   VM  = middle node: emitter of Q1 = base of Q2  (node 3)
%   VE2 = emitter of Q2                     (node 4)
%   Vcc = supply rail                       (node 5, no nonlinear element)
%
% Device parameters:
%   Is1 = 1e-14 A, Is2 = 5e-15 A
%   Vt  = 0.026 V,  beta = 100
%
% Q1: base=VB1 (1), collector=VC (2), emitter=VM (3)
%   Ie1 = Is1 * (exp((VB1 - VM) / Vt) - 1)
%   y(1) += Ie1/(beta+1),  y(2) += beta*Ie1/(beta+1),  y(3) -= Ie1
%
% Q2: base=VM (3), collector=VC (2), emitter=VE2 (4)
%   Ie2 = Is2 * (exp((VM - VE2) / Vt) - 1)
%   y(3) += Ie2/(beta+1),  y(2) += beta*Ie2/(beta+1),  y(4) -= Ie2

    fstruct(1).type  = 'npn_bjt';
    fstruct(1).nodes = [1, 2, 3];   % Q1: base=VB1, collector=VC, emitter=VM
    fstruct(1).Is    = 1e-14;
    fstruct(1).Vt    = 0.026;
    fstruct(1).beta  = 100;

    fstruct(2).type  = 'npn_bjt';
    fstruct(2).nodes = [3, 2, 4];   % Q2: base=VM, collector=VC, emitter=VE2
    fstruct(2).Is    = 5e-15;
    fstruct(2).Vt    = 0.026;
    fstruct(2).beta  = 100;
end
