function models = gpMtRun(X, y, kernelType, noiseType, theta, prior, display, iters)

% GPMTRUN Run a multi-task GP.

% MTIVM

models = mtivm(X, y, kernelType, noiseType, 'none');

models = mtivmInit(models);
models = mtivmOptimiseNoise(models, prior, display, iters);
models = mtivmOptimiseKernel(models, prior, display, iters);
