function fstruct = build_example_e3()
% Six-node diode network with main chain and shortcut paths.
%
% State variables: x = [V1, V2, V3, V4, V5, V6]
%   V6 = reference / ground node
%
% Each entry represents one diode: I = Is*(exp((Va-Vc)/Vt) - 1)
% KCL: y(anode) += I,  y(cathode) -= I
%
% Standard diodes: Is_std = 1e-9 A,  Vt = 0.025 V
% Schottky bypass:  Is_sch = 2e-9 A,  Vt = 0.025 V
%
% Diode list:
%   D1:  V1 -> V2  (std)    D7:  V1 -> V4  (Schottky)
%   D2:  V2 -> V3  (std)    D8:  V2 -> V5  (std)
%   D3:  V3 -> V4  (std)    D9:  V2 -> V6  (Schottky)
%   D4:  V4 -> V5  (std)    D10: V3 -> V6  (Schottky)
%   D5:  V5 -> V6  (std)    D11: V4 -> V2  (std)
%                            D12: V4 -> V6  (Schottky)

    Is_std = 1e-9;
    Is_sch = 2e-9;
    Vt     = 0.025;

    % D1: V1 -> V2 (std)
    fstruct(1).type  = 'diode';
    fstruct(1).nodes = [1, 2];
    fstruct(1).Is    = Is_std;
    fstruct(1).Vt    = Vt;
    fstruct(1).beta  = [];

    % D2: V2 -> V3 (std)
    fstruct(2).type  = 'diode';
    fstruct(2).nodes = [2, 3];
    fstruct(2).Is    = Is_std;
    fstruct(2).Vt    = Vt;
    fstruct(2).beta  = [];

    % D3: V3 -> V4 (std)
    fstruct(3).type  = 'diode';
    fstruct(3).nodes = [3, 4];
    fstruct(3).Is    = Is_std;
    fstruct(3).Vt    = Vt;
    fstruct(3).beta  = [];

    % D4: V4 -> V5 (std)
    fstruct(4).type  = 'diode';
    fstruct(4).nodes = [4, 5];
    fstruct(4).Is    = Is_std;
    fstruct(4).Vt    = Vt;
    fstruct(4).beta  = [];

    % D5: V5 -> V6 (std)
    fstruct(5).type  = 'diode';
    fstruct(5).nodes = [5, 6];
    fstruct(5).Is    = Is_std;
    fstruct(5).Vt    = Vt;
    fstruct(5).beta  = [];

    % D7: V1 -> V4 (Schottky)
    fstruct(6).type  = 'diode';
    fstruct(6).nodes = [1, 4];
    fstruct(6).Is    = Is_sch;
    fstruct(6).Vt    = Vt;
    fstruct(6).beta  = [];

    % D8: V2 -> V5 (std)
    fstruct(7).type  = 'diode';
    fstruct(7).nodes = [2, 5];
    fstruct(7).Is    = Is_std;
    fstruct(7).Vt    = Vt;
    fstruct(7).beta  = [];

    % D9: V2 -> V6 (Schottky)
    fstruct(8).type  = 'diode';
    fstruct(8).nodes = [2, 6];
    fstruct(8).Is    = Is_sch;
    fstruct(8).Vt    = Vt;
    fstruct(8).beta  = [];

    % D10: V3 -> V6 (Schottky)
    fstruct(9).type  = 'diode';
    fstruct(9).nodes = [3, 6];
    fstruct(9).Is    = Is_sch;
    fstruct(9).Vt    = Vt;
    fstruct(9).beta  = [];

    % D11: V4 -> V2 (std)
    fstruct(10).type  = 'diode';
    fstruct(10).nodes = [4, 2];
    fstruct(10).Is    = Is_std;
    fstruct(10).Vt    = Vt;
    fstruct(10).beta  = [];

    % D12: V4 -> V6 (Schottky)
    fstruct(11).type  = 'diode';
    fstruct(11).nodes = [4, 6];
    fstruct(11).Is    = Is_sch;
    fstruct(11).Vt    = Vt;
    fstruct(11).beta  = [];
end
