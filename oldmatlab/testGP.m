numIn = 1;
numTasks = 4;
N = 300;
numDataPerTask = N*ones(1, numTasks);
% Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
theta = [1 1 0.01 0];
[X, y] = sampleData(theta, numIn, numTasks, numDataPerTask);
theta = [10 10 10 10];
iters = 100;
theta = gpRun(X, y, theta, iters);
ll = -neglikelihood(log(theta), X, y);
displayTasks(X, y, theta);
