%% network specifications
l = 2;
cells = [2,2];
%%Nodewights files
nweights = {'n1','n2','n3','n4','n5'};
%% target function
finputs = 2;
foutputs = 1;
zero = [1,0];
one = [0,1];
%f=[0,0,0;0,1,0;1,0,0;1,1,1];
%f=[0,0,0;0,1,1;1,0,1;1,1,1];
%f=[0,0,0;0,1,1;1,0,1;1,1,0];
f=[0,0,1;0,1,1;1,0,1;1,1,0];
%% measurements
M0 = [1,0;0,0];
M1 = [0,0;0,1];
I = [1,0;0,1];
A0 = kron(M0,kron(I,kron(I,I)));
A1 = kron(M1,kron(I,kron(I,I)));
QV0 = kron(I,kron(I,kron(I,M0)));
QV1 = kron(I,kron(I,kron(I,M1)));
IIIM0 = kron(I,kron(I,kron(I,M0)));
IIIM1 = kron(I,kron(I,kron(I,M1)));
IM0II = kron(I,kron(M0,kron(I,I)));
IM1II = kron(I,kron(M1,kron(I,I)));
M0III = kron(M0,kron(I,kron(I,I)));
M1III = kron(M1,kron(I,kron(I,I)));
IIM0I = kron(I,kron(I,kron(M0,I)));
IIM1I = kron(I,kron(I,kron(M1,I)));
%I1I0 = kron(I1,I0);
%I1I1 = kron(I1,I1);
%% CNOT
CNOT = [1,0,0,0;0,1,0,0;0,0,0,1;0,0,1,0];
NOTC = [1,0,0,0;0,0,0,1;0,0,1,0;0,1,0,0];
SWAP = [1,0,0,0;0,0,1,0;0,1,0,0;0,0,0,1];
I = [1,0;0,1];
ICINOT = kron(I,kron(SWAP,I))*kron(I,kron(I,CNOT))*kron(I,kron(SWAP,I));
INOTIC = kron(I,kron(SWAP,I))*kron(I,kron(I,NOTC))*kron(I,kron(SWAP,I));
%% Eval specs
measurements = 100;
tests = 100;
cells = 5;
lambda = 0.01;