% MTIVM toolbox
% Version 1.0 Monday, December 29, 2003 at 10:49:13
% Copyright (c) 2003 Neil D. Lawrence
% $Revision: 1.1 $
% 
% IVMSELECT Select an IVM data set from multiple tasks.
% This function samples a dataset from a given covariance funciton
% KERNELDIAG returns the diagonal of a kernel matrix
% KERNEL Return the kernel matrix
% GAUSSSAMP Sample from a Gaussian with a given covariance.
% THETACONSTRAIN Prevent kernel parameters from getting too big or small.
% OPTIMISETHETA Optimise the kernel parameters
% IVMSELECT Select an IVM data set from multiple tasks.
% Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
% TESTIVM Run the IVM on sampled data.
% DISPLAYTASKS Show the results.
% GRADIENTEM The gradients with respect to parameters for the M-step.
% Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
% GPRUN Run a GP on multi-task data.
% NEGLIKELIHOOD The negative likelihood of the GP.
% NEGGRADIENT The gradients of the netative likelihood with respect to parameters.
% IVMRUN Run an ivm on multi-task data.
% NEGLIKELIHOODEM The negative objective function for the M-step.
% NEGGRADIENTEM The negative gradients with respect to parameters for the M-step.
% TESTGPSAMP Test sub-sampling the data and fitting a GP.
% Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
% TIMEMETHODS Time the multi-task IVM and simple sub-sampling.
% LOGDET The log of the determinant when argument is positive definite.
% GENERATEDATA Tries to load a sampled data set otherwise generates it.
% PLOTTIMECOMPARISIONRESULTS Prepare comparision plots of the IVM vs sub-sampling.
% IVMSELECTCLASS Select an IVM data set from multiple classification tasks.
% IVMREMOVE Remove points from the IVM active set.
% GENERATEDATACLASS Tries to load a classification data set otherwise generates it.
