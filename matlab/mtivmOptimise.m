function models = mtivmOptimise(models, prior, display, innerIters, ...
			     outerIters);

% MTIVMOPTIMISE Optimise the multi-task IVM.

% MTIVM

% Run IVM
for i = 1:outerIters
  models = mtivmOptimiseIVM(models, display);
  models = mtivmOptimiseNoise(models, prior, display, innerIters);
  models = mtivmOptimiseKernel(models, prior, display, innerIters);
end
