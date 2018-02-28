function [ error, esequence, dweights ] = qann(init, learn)
%QANN creates and train a QANN using the input file parameters param.m
params;
if init > 0
    initQnet;
end

esum = 1;
logfaults = zeros(finputs^2,1);
esequence = zeros(1000000,1);
dweights = zeros(1000000,1);
runcount = 1;
errors = zeros(cells,2);
%    esum = 0;
%small routine to extract all inputs to a two bit binary function from f
while (1-esum) < 0.95
if learn > 0

for j=1:finputs^2
    if f(j,1) == 1
        in0 = one;
    else
        in0 = zero;
    end
    if f(j,2) == 1
        in1 = one;
    else
        in1 = zero;
    end
    if f(j,3) == 1
        o = [0,1];
    else
        o = [1,0];
    end
if cells == 1
    o1 = nodeProcess([in0; in1], nweights{1});
    errors(1,:) = o - o1;
    logfaults(j,1) = sqrt((errors(1,1)^2+errors(1,2)^2))/2;
elseif cells == 3
    o1 = nodeProcess([in0; in1], nweights{1});
    errors(1,:) = o - o1;
    o2 = nodeProcess([in0; in1], nweights{2});
    errors(2,:) = o - o2;
    o3 = nodeProcess([o1;o2],nweights{3});
    errors(3,:) = o - o3;
    logfaults(j,1) = sqrt((errors(3,1)^2+errors(3,2)^2))/2;
else
    o1 = nodeProcess([in0; in1], nweights{1});
    errors(1,:) = o - o1;
    o2 = nodeProcess([in0; in1], nweights{2});
    errors(2,:) = o - o2;
    o3 = nodeProcess([o1;o2],nweights{3});
    errors(3,:) = o - o3;
    o4 = nodeProcess([o1;o2],nweights{4});
    errors(4,:) = o - o4;
    o5 = nodeProcess([o3;o4],nweights{5});
    errors(5,:) = o - o5;
    logfaults(j,1) = sqrt((errors(5,1)^2+errors(5,2)^2))/2;
end

esequence(runcount,1) = esum;
runcount = runcount + 1;
esum = mean(logfaults)

if logfaults(j,1) ~= 0
%Do a sort of backpropagation
%Modify all weights inversely proportional to
%their coefficients
for k=1:cells
    if sum(abs(errors(cells,1))) ~= 0
       weights = load(strcat(nweights{k},'.cls'));
       [rows,~] = size(weights);
       for j=1:rows
          diff = (errors(k,1) - weights(j,1));
%          diff = sqrt(error - abs(weights(j,1:2).^2))
%          error
%          weights(j,1:2)
%          abs(error)- abs(weights(j,1:2)).^2
          
%          deltaweights = 
%          diff = sqrt(abs(error) - abs(weights(j,1:2).^2));
%          diffweights = sqrt((abs(weights(j,1))-abs(weights(j,2)))^2)*diff
%          deltaweights = diffweights(1,1)^2 + diffweights(1,2)^2
%          dweights(runcount,1) = deltaweights;
          updated = weights(j,3) + lambda*diff;%deltaweights;
          if updated > 1
              updated = updated - 1;
          elseif updated < 0
              updated = - updated;
          end

          W = exp(-i*2*pi*updated);
          weights(j,1) = real(W);
          weights(j,2) = imag(W);
          weights(j,3) = updated;
       end
       csvwrite(strcat(nweights{k},'.cls'),weights);
    end
end
end
end
end


%logfaults

%% evaluate when error has reached desired target
if esum < 0.05
esequence = esequence(1:runcount-1,1);
error = zeros(tests,1);
lerrors = zeros(finputs^2,1);

for k=1:tests
for j=1:finputs^2
    if f(j,1) == 1
        in0 = one;
    else
        in0 = zero;
    end
    if f(j,2) == 1
        in1 = one;
    else
        in1 = zero;
    end
    if f(j,3) == 1
        o = [0,1];
    else
        o = [1,0];
    end

if cells == 1
    o1 = nodeProcess([in0; in1], nweights{1});
    errors(1,:) = o - o1;
    logfaults(j,1) = sqrt((errors(1,1)^2+errors(1,2)^2))/2;
elseif cells == 3
    o1 = nodeProcess([in0; in1], nweights{1});
    errors(1,:) = o - o1;
    o2 = nodeProcess([in0; in1], nweights{2});
    errors(2,:) = o - o2;
    o3 = nodeProcess([o1;o2],nweights{3});
    errors(3,:) = o - o3;
    logfaults(j,1) = sqrt((errors(3,1)^2+errors(3,2)^2))/2;
else
    o1 = nodeProcess([in0; in1], nweights{1});
    errors(1,:) = o - o1;
    o2 = nodeProcess([in0; in1], nweights{2});
    errors(2,:) = o - o2;
    o3 = nodeProcess([o1;o2],nweights{3});
    errors(3,:) = o - o3;
    o4 = nodeProcess([o1;o2],nweights{4});
    errors(4,:) = o - o4;
    o5 = nodeProcess([o3;o4],nweights{5});
    errors(5,:) = o - o5;
    logfaults(j,1) = sqrt((errors(5,1)^2+errors(5,2)^2))/2;
        
end
%lerror(j,1)  = sqrt((e(1,1))^2);
end
%esum = mean(logfaults)
error(k,1) = mean(logfaults);
%err = mean(error);
end
end
end

