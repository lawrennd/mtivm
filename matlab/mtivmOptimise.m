function models = mtivmOptimise(models, optimiseNoise, display, innerIters, ...
			     outerIters);

% MTIVMOPTIMISE Optimise the multi-task IVM.

% MTIVM

% Run IVM
for i = 1:outerIters
  models = mtivmOptimiseIVM(models, display);
  models = mtivmOptimiseKernel(models, display, innerIters);
  if optimiseNoise
    models = mtivmOptimiseIVM(models, display);
    models = mtivmOptimiseNoise(models, display, innerIters);
  end
  mtivmDisplay(models);
end
