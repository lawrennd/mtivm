function models = gpMtRun(X, y, kernelType, noiseType, theta, prior, display, iters)

% GPMTRUN Run a multi-task GP.


models = mtivm(X, y, kernelType, noiseType, 'none');

for i = 1:length(models)
  models.task(i) = mtivmInit(models.task(i));
end
models = mtivmOptimiseNoise(models, prior, display, iters);
models = mtivmOptimiseKernel(models, prior, display, iters);
