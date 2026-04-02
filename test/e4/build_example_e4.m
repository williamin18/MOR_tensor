function fstruct = build_example_e4()
% Six-node diode network with main chain and shortcut paths.
%
% State variables: x = [V1, V2, V3, V4, V5, V6]
%   V6 = reference / ground node
%
% Topology — each row lists the diodes whose anode is at that node
% (i.e., current leaves the node through these diodes):
%
%   Node 1: D1  (V1 -> V2, Is_std)   D7  (V1 -> V4, Is_sch)
%   Node 2: D2  (V2 -> V3, Is_std)   D8  (V2 -> V5, Is_std)   D9  (V2 -> V6, Is_sch)
%   Node 3: D3  (V3 -> V4, Is_std)   D10 (V3 -> V6, Is_sch)
%   Node 4: D4  (V4 -> V5, Is_std)   D11 (V4 -> V2, Is_std)   D12 (V4 -> V6, Is_sch)
%   Node 5: D5  (V5 -> V6, Is_std)
%   Node 6: reference — no outgoing nonlinear elements
%
% Standard diodes: Is_std = 1e-9 A,  Vt = 0.025 V
% Schottky bypass:  Is_sch = 2e-9 A,  Vt = 0.025 V  (lower forward drop)
%
% Nonlinear KCL contributions (current leaving each node via diodes):
%   y(1) = Is_std*exp((V1-V2)/Vt) + Is_sch*exp((V1-V4)/Vt)
%   y(2) = Is_std*exp((V2-V3)/Vt) + Is_std*exp((V2-V5)/Vt) + Is_sch*exp((V2-V6)/Vt)
%   y(3) = Is_std*exp((V3-V4)/Vt) + Is_sch*exp((V3-V6)/Vt)
%   y(4) = Is_std*exp((V4-V5)/Vt) + Is_std*exp((V4-V2)/Vt) + Is_sch*exp((V4-V6)/Vt)
%   y(5) = Is_std*exp((V5-V6)/Vt)
%   y(6) = 0  (reference node)

    Is_std = 1e-9;
    Is_sch = 2e-9;
    Vt     = 0.025;

    % y(1): D1 + D7
    fstruct(1).terms(1) = struct('Is', Is_std, 'coeff', [ 1, -1,  0,  0,  0,  0], 'Vt', Vt);
    fstruct(1).terms(2) = struct('Is', Is_sch, 'coeff', [ 1,  0,  0, -1,  0,  0], 'Vt', Vt);

    % y(2): D2 + D8 + D9
    fstruct(2).terms(1) = struct('Is', Is_std, 'coeff', [ 0,  1, -1,  0,  0,  0], 'Vt', Vt);
    fstruct(2).terms(2) = struct('Is', Is_std, 'coeff', [ 0,  1,  0,  0, -1,  0], 'Vt', Vt);
    fstruct(2).terms(3) = struct('Is', Is_sch, 'coeff', [ 0,  1,  0,  0,  0, -1], 'Vt', Vt);

    % y(3): D3 + D10
    fstruct(3).terms(1) = struct('Is', Is_std, 'coeff', [ 0,  0,  1, -1,  0,  0], 'Vt', Vt);
    fstruct(3).terms(2) = struct('Is', Is_sch, 'coeff', [ 0,  0,  1,  0,  0, -1], 'Vt', Vt);

    % y(4): D4 + D11 + D12
    fstruct(4).terms(1) = struct('Is', Is_std, 'coeff', [ 0,  0,  0,  1, -1,  0], 'Vt', Vt);
    fstruct(4).terms(2) = struct('Is', Is_std, 'coeff', [ 0, -1,  0,  1,  0,  0], 'Vt', Vt);
    fstruct(4).terms(3) = struct('Is', Is_sch, 'coeff', [ 0,  0,  0,  1,  0, -1], 'Vt', Vt);

    % y(5): D5
    fstruct(5).terms(1) = struct('Is', Is_std, 'coeff', [ 0,  0,  0,  0,  1, -1], 'Vt', Vt);

    % y(6): reference node — no nonlinear elements
    fstruct(6).terms = [];
end
