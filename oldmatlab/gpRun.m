function theta = gpRun(X, y, theta, iters)

% GPRUN Run a GP on multi-task data.

theta = optimiseTheta(X, y, [], [], [], theta, iters);
