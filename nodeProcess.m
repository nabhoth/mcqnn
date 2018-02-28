function [ outputs ] = nodeProcess( qubits, index )
%nodeProcess takes as inputs
% -- a set of input qubits
% -- a scalar as index allowing to read in the data file with weights
% and outputs
% -- a single qubit
% reads in associated weights,
% performs entanglement between all weights and inputs
% then entanglement between all inputs and target input
% then measures all weights
% then measures the output qubit
params;

%% load weights
load(strcat(index,'.cls'));
weights = eval(index);
[finputs,~] = size(weights);

outstates = [];
%% propagate the inputs with weights
for j=1:finputs
    w =[weights(j,1), weights(j,2)];
    outstates = [outstates; kron(w,qubits(j,:))];
end

%% entangle with the weights of the ANN outstates
[rows,~] = size(outstates);
for j=1:rows
    o =CNOT*outstates(j,:)';
    outstates(j,:) = o;
end

%% states arriving to the second layer to each node - build large quantum register
S = kron(outstates(1,:),outstates(2,:));
for j=3:finputs
    w =[weights(j,1),weights(j,2)];
    S = kron(S,outstates(j,:));
end

%% interaction/entanglement between the qubit carrying data
S11 = INOTIC*S';

%% measurements of First control
P0C0 = S11'*M0III'*M0III*S11;
P1C0 = S11'*M1III'*M1III*S11;
M0C0 = sqrt(P0C0);
M1C0 = sqrt(P1C0);

%% measure
[C0m0,C0m1]=measure(P0C0,P1C0,measurements);


%% make the resulting state according to higehr amount of records
if C0m0 > C0m1
    S12 = (M0III*S11)/M0C0;
else
    S12 = (M1III*S11)/M1C0;
end


%% Second control
P0C1 = S12'*IIM0I'*IIM0I*S12;
P1C1 = S12'*IIM1I'*IIM1I*S12;
M0C1 = sqrt(P0C1);
M1C1 = sqrt(P1C1);

%% measure
[C1m0,C1m1]=measure(P0C1,P1C1,measurements);

%% make the resulting state according to higehr amount of records
if C1m0 > C1m1
    S13 = (IIM0I*S12)/M0C1;
else
    S13 = (IIM1I*S12)/M1C1;
end

%% first Target
P0T0 = S13'*IM0II'*IM0II*S13;
P1T0 = S13'*IM1II'*IM1II*S13;
M0T0 = sqrt(P0T0);
M1T0 = sqrt(P1T0);

%% measure
[T0m0,T0m1]=measure(P0T0,P1T0,measurements);

%% make the resulting state according to higehr amount of records
if T0m0 > T0m1
    S14 = (IM0II*S13)/M0T0;
else
    S14 = (IM1II*S13)/M1T0;
end

%% Second target - Collapse it
P0T1 = S14'*IIIM0'*IIIM0*S14;
P1T1 = S14'*IIIM1'*IIIM1*S14;
M0T1 = sqrt(P0T1);
M1T1 = sqrt(P1T1);

%% measure
[T1m0,T1m1]=measure(P0T1,P1T1,measurements);

%% make the resulting state according to higehr amount of records
if T1m0 > T1m1
    S15 = (IIIM0*S14)/M0T1;
else
    S15 = (IIIM1*S14)/M1T1;
end

%% Second Target
%M0T1 = IIIM0*S14;
%M1T1 = IIIM1*S14;

%outputs = zeros(1,2)
%% Generate outputs - Collapse it
%m0 = sum(abs(QV0*S14));
%m1 = sum(abs(QV1*S14));
m0 = sum(abs(IIIM0*S15));
m1 = sum(abs(IIIM1*S15));
outputs = [m0, m1];
%m0 = sum(abs(QV0*S14));
%m1 = sum(abs(QV1*S14));

%if (rand(1) <= abs(m0))
%    outputs(1,1) = 1;
%else
%    outputs(1,2) = 1;
%end
end

%% measure function. Takes as input to probabilities and performs some measurements to determine the frequentist result
function [m0,m1] = measure(coeff0,coeff1,measurements)
m0 = 0;
m1 = 0;
%make n measurements
for j=1:measurements
    p = rand(1);
    if p < coeff0
        m0 = m0 + 1;
    else       
        m1 = m1 + 1;
    end
end
end
