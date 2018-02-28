import numpy as N
import random
from cmath import exp,pi
#initQnet randomly initiates weights 
#Quantum Neural Network
cwidth = 3
ncells = 10
length = 20
#%new
Weights = N.zeros(((2*length),3))
#print('.2f',Weights.shape)
for j in range(2*length):
    p = random.random()
    ra = complex(0,-1)*2*pi*complex(p,0)
    W = exp(ra)
#    print('W: {:.2f}'.format(W))
    Weights[j][0] =W.real
    Weights[j][1] =W.imag
    Weights[j][2] =p
#print(Weights)
N.savetxt("weights.csv", Weights, delimiter=" ")

