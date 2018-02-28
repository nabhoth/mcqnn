function [  ] = initQnet()
%initQnet rendomly initiates weights for 2 qubit inpt and one qubit output
%Quantum Neural Network
% The network is assumed to have one hidden layer
params;
length = 20;
%new
Weights = zeros(2*length,3);
%Old
W1 = zeros(2,3);
W2 = zeros(2,3);
W3 = zeros(2,3);
W4 = zeros(2,3);
W5 = zeros(2,3);
[height,~]  = size(Weights);
for j=1:height
    p = rand(1);
    W = exp(-i*2*pi*p);
    Weights(j,:) =[real(W),imag(W),p];
    
    
%    p = rand(1);
%    W = exp(-i*2*pi*p);
%    W2(j,:) =[real(W),imag(W),p];
%    p = rand(1);
%    W = exp(-i*2*pi*p);
%    W3(j,:) =[real(W),imag(W),p];
%    p = rand(1);
%    W = exp(-i*2*pi*p);
%    W4(j,:) =[real(W),imag(W),p];
%    p = rand(1);
%    W = exp(-i*2*pi*p);
%    W5(j,:) =[real(W),imag(W),p];
end
%old
csvwrite('n1.cls',W1);
csvwrite('n2.cls',W2);
csvwrite('n3.cls',W3);
csvwrite('n4.cls',W3);
csvwrite('n5.cls',W3);
%new
csvwrite('weights.cls',Weights);
end

