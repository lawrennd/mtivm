function models = gpMtRun(X, y, kernelType, noiseType, theta, optimiseNoise, display, iters)

% MTIVM

% GPMTRUN Run a multi-task GP.

models = mtivm(X, y, kernelType, noiseType, 'none');

for i = 1:length(models)
  models.task(i) = mtivmInit(models.task(i));
end
models = mtivmOptimiseKernel(models, display, iters);
if optimiseNoise
  models = mtivmOptimiseNoise(models, display, iters);
end
