% TESTGPSAMP Test sub-sampling the data and fitting a GP.

generateData
samps = 25;
for task = 1:numTasks
  indices = randperm(numDataPerTask(task));
  Xsamp{task} = X{task}(indices(1:samps), :);
  ysamp{task} = y{task}(indices(1:samps), :);
end

theta = [10 10 10 10];
iters = 100;
theta = gpRun(Xsamp, ysamp, theta, iters);
ll = -neglikelihood(log(theta), testX, testY);
displayTasks(Xsamp, ysamp, theta);
