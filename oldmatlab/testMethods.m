numIn = 1;
numTasks = 4;
N = 1000;
numDataPerTask = N*ones(1, numTasks);
numTasksTest = 4;
NTest = 1000;
numDataPerTaskTest = NTest*ones(1, numTasks);
% Theta is of the form [rbfInverseWidth, rbfMultiplier, noiseVariance, biasVariance]
theta = [1 1 0.01 0];
[X, y] = sampleData(theta, numIn, numTasks, numDataPerTask);
[testX, testY] = sampleData(theta, numIn, numTasksTest, numDataPerTaskTest);
iters = 100;


% Simply sub-sample
samps = 25; % 25 samples per task
for task = 1:numTasks
  indices = randperm(numDataPerTask(task));
  Xsamp{task} = X{task}(indices(1:samps), :);
  ysamp{task} = y{task}(indices(1:samps), :);
end
theta = [10 10 10 10];
thetaSub = gpRun(Xsamp, ysamp, theta, iters);
llSub = -neglikelihood(log(thetaSub), X, y);
displayTasks(Xsamp, ysamp, thetaSub);

% Run the IVM
d = 100

[thetaIVM, activeSet] = ivmRun(X, y, theta, d, iters, 10)
llIVM = -neglikelihood(log(thetaIVM), X, y);
displayTasks(X, y, thetaIVM, activeSet);

% Run full GP
%thetaGP = gpRun(X, y, theta, iters);
%llGP = -neglikelihood(log(thetaGP), X, y);
%displayTasks(X, y, thetaGP);
